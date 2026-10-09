// Razorpay order creation — Supabase Edge Function (Deno).
//
// Flow: authenticate the user, recompute the order total from authoritative DB
// prices and the server-decided random discount (never trust the client), create a
// pending order, and create the corresponding Razorpay order. Returns the
// Razorpay key id + order id so the client can open checkout.js.
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";
import { cors, json, keyId, razorpayFetch } from "../_shared/razorpay.ts";
import { parseCheckoutRequest } from "../_shared/checkout.ts";
import {
  matchesExpectedTotal,
  normalizeDiscountPercent,
  orderSummary,
  priceCart,
  type ProductRow,
  staleTotalBody,
} from "../_shared/pricing.ts";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405);

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

    // Identify the caller from their JWT.
    const authHeader = req.headers.get("Authorization") || "";
    const userClient = createClient(supabaseUrl, anonKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const {
      data: { user },
    } = await userClient.auth.getUser();
    if (!user) return json({ error: "Unauthorized" }, 401);

    const requestBody: unknown = await req.json().catch(() => null);
    // Validates items, address, phone and the optional map pin. Any
    // discount_percent sent by the browser is ignored.
    const request = parseCheckoutRequest(requestBody);
    if (!request.ok) return json({ error: request.error }, request.status);

    // Fail fast on missing credentials, before creating an orphan order.
    const razorpayKeyId = keyId();

    const admin = createClient(supabaseUrl, serviceKey);
    const [productResult, discountResult] = await Promise.all([
      admin
        .from("products")
        .select("id, price, variants, is_active, stock")
        .in("id", request.productIds),
      // The random discount is decided in SQL from a server-held secret, this
      // customer and the number of pieces (more pieces -> higher percent). Only
      // product_id and quantity are sent; nothing the browser claims about a
      // discount is used.
      admin.rpc("get_cart_discount_percent", {
        p_user_id: user.id,
        p_items: request.items.map((item) => {
          const { product_id, quantity } = item as { product_id: unknown; quantity: unknown };
          return { product_id, quantity: Number(quantity) };
        }),
      }),
    ]);
    if (productResult.error) throw productResult.error;
    // Never silently charge a wrong total: if the discount cannot be decided, stop.
    const discountPercent = normalizeDiscountPercent(discountResult.data);
    if (discountResult.error || discountPercent === null) {
      console.error("get_cart_discount_percent failed", discountResult.error?.message ?? discountResult.data);
      return json({ error: "Could not calculate your discount. Please try again." }, 500);
    }

    const priced = priceCart({
      items: request.items,
      products: (productResult.data || []) as unknown as ProductRow[],
      discountPercent,
    });
    if (!priced.ok) return json({ error: priced.error }, priced.status);

    // The browser sends the total it displayed. A mismatch means prices or the
    // cart discount changed; return the server's figures so the UI refreshes.
    if (!matchesExpectedTotal(request.expectedTotalPaise, priced)) {
      return json(staleTotalBody(priced), 409);
    }
    const summary = orderSummary(priced);

    // Create the pending order.
    const { data: order, error: orderErr } = await admin
      .from("orders")
      .insert({
        user_id: user.id,
        total_amount: summary.total,
        subtotal_amount: summary.subtotal,
        discount_percent: summary.discountPercent,
        discount_amount: summary.discountAmount,
        shipping_amount: summary.shipping,
        address: request.address,
        contact_phone: request.phoneDigits,
        delivery_latitude: request.location.latitude,
        delivery_longitude: request.location.longitude,
        delivery_location_label: request.location.label,
        status: "pending",
        payment_provider: "razorpay",
        payment_method: "razorpay",
        payment_status: "created",
      })
      .select()
      .single();
    if (orderErr) throw orderErr;

    const discardDraftOrder = async () => {
      const { error } = await admin.from("orders").delete().eq("id", order.id);
      if (error) console.error("Could not discard incomplete checkout order", order.id, error);
    };

    const { error: itemsErr } = await admin
      .from("order_items")
      .insert(priced.orderItems.map((oi) => ({ ...oi, order_id: order.id })));
    if (itemsErr) {
      await discardDraftOrder();
      throw itemsErr;
    }

    // Create the Razorpay order (amount in paise).
    let resp: Response;
    try {
      resp = await razorpayFetch("/orders", {
        method: "POST",
        body: JSON.stringify({
          amount: priced.totalPaise,
          currency: "INR",
          receipt: order.id,
          notes: {
            user_id: user.id,
            phone: request.phoneDigits,
            subtotal: summary.subtotal.toFixed(2),
            discount_percent: String(summary.discountPercent),
            discount_amount: summary.discountAmount.toFixed(2),
          },
        }),
      });
    } catch (error) {
      await discardDraftOrder();
      throw error;
    }
    const data = await resp.json().catch(() => ({}));

    if (!resp.ok || !data?.id) {
      // Roll back the order so failed attempts don't leave orphans.
      await discardDraftOrder();
      console.error("Razorpay order creation failed", resp.status, JSON.stringify(data));
      return json(
        {
          error:
            data?.error?.description || data?.error?.reason ||
            "Razorpay order creation failed",
        },
        502,
      );
    }

    // Store the provider order before handing it to the browser. The verify
    // endpoint and webhook both require this exact id, preventing a signed
    // payment for one order from being replayed against another local order.
    const { error: gatewayOrderErr } = await admin
      .from("orders")
      .update({
        payment_provider_order_id: data.id,
        payment_status: data.status || "created",
      })
      .eq("id", order.id)
      .eq("user_id", user.id);
    if (gatewayOrderErr) {
      console.error("Could not persist Razorpay order id", gatewayOrderErr);
      await discardDraftOrder();
      return json({ error: "Could not prepare payment. Please try again." }, 500);
    }

    return json({
      keyId: razorpayKeyId,
      rzpOrderId: data.id,
      dbOrderId: order.id,
      amount: priced.totalPaise,
      currency: "INR",
      ...summary,
    });
  } catch (e) {
    console.error("razorpay-create-order error", e);
    return json({ error: "Could not prepare payment. Please try again." }, 500);
  }
});
