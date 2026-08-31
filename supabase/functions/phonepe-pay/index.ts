// PhonePe payment initiation — Supabase Edge Function (Deno).
//
// Standard Checkout V2. Flow: authenticate the user, recompute the order total
// from authoritative DB prices (never trust the client), create a pending
// order, mint an OAuth token, call /checkout/v2/pay, and return the hosted
// checkout redirect URL.
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";
import {
  authHeaders,
  cors,
  getAccessToken,
  json,
  pgBase,
} from "../_shared/phonepe.ts";

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

    const { items, address, phone } = await req.json();
    if (!Array.isArray(items) || items.length === 0) {
      return json({ error: "Cart is empty" }, 400);
    }
    if (!address || typeof address !== "string") {
      return json({ error: "Address is required" }, 400);
    }

    // Fail fast on missing/bad credentials, before creating an orphan order.
    const token = await getAccessToken();

    const admin = createClient(supabaseUrl, serviceKey);

    // Cart item ids may carry a variant suffix ("<product-id>:v<index>") when
    // the shopper picked a size on the product page; the base UUID always
    // resolves to a real product.
    const baseIds = [
      ...new Set(items.map((i: any) => String(i.product_id).split(":v")[0])),
    ];
    const { data: products, error: prodErr } = await admin
      .from("products")
      .select("id, price, variants")
      .in("id", baseIds);
    if (prodErr) throw prodErr;

    const productMap = new Map((products || []).map((p: any) => [p.id, p]));
    let subtotal = 0;
    const orderItems: any[] = [];
    for (const it of items) {
      const rawId = String(it.product_id);
      const vMatch = rawId.match(/^(.+):v(\d+)$/);
      const pid = vMatch ? vMatch[1] : rawId;
      const product = productMap.get(pid);
      if (!product) {
        return json({ error: `Invalid product: ${pid}` }, 400);
      }
      // Price comes from the DB variant when one was selected, never the client.
      let price = Number(product.price);
      if (vMatch) {
        const variant = (Array.isArray(product.variants)
          ? product.variants
          : []
        )[parseInt(vMatch[2], 10)];
        if (!variant) {
          return json({ error: `Invalid variant for ${pid}` }, 400);
        }
        price = Number(variant.price ?? product.price);
      }
      if (!Number.isFinite(price) || price <= 0) {
        return json({ error: `Invalid price for ${pid}` }, 400);
      }
      const qty = Math.max(1, parseInt(it.quantity) || 1);
      subtotal += price * qty;
      orderItems.push({ product_id: pid, quantity: qty, price });
    }
    // Minimum order value, enforced server-side on the subtotal (excl. shipping)
    // so it can't be bypassed by calling this function directly.
    const MIN_ORDER_VALUE = 2000;
    if (subtotal < MIN_ORDER_VALUE) {
      return json(
        {
          error:
            `Minimum order value is ₹${MIN_ORDER_VALUE}. Please add more items to your cart.`,
        },
        400,
      );
    }

    const shipping = 100;
    const total = subtotal + shipping;
    if (total <= 0) return json({ error: "Invalid order total" }, 400);

    // Create the pending order.
    const { data: order, error: orderErr } = await admin
      .from("orders")
      .insert({
        user_id: user.id,
        total_amount: total,
        address,
        status: "pending",
      })
      .select()
      .single();
    if (orderErr) throw orderErr;

    const { error: itemsErr } = await admin
      .from("order_items")
      .insert(orderItems.map((oi) => ({ ...oi, order_id: order.id })));
    if (itemsErr) throw itemsErr;

    const appOrigin = (
      req.headers.get("origin") ||
      Deno.env.get("APP_BASE_URL") ||
      ""
    ).replace(/\/$/, "");

    // V2 payload. merchantOrderId: our UUID (36 chars; '-' is allowed, max 63).
    // No callbackUrl here — server-to-server callbacks are configured as a
    // webhook in the PhonePe dashboard; we confirm by polling order status.
    const payload = {
      merchantOrderId: order.id,
      amount: Math.round(total * 100), // paise
      expireAfter: 1200,
      metaInfo: {
        udf1: user.id,
        udf2: String(phone || "").replace(/\D/g, "").slice(-10),
      },
      paymentFlow: {
        type: "PG_CHECKOUT",
        message: "Order payment",
        merchantUrls: {
          redirectUrl: `${appOrigin}/payment-status?order=${order.id}`,
        },
      },
    };

    const resp = await fetch(`${pgBase()}/checkout/v2/pay`, {
      method: "POST",
      headers: authHeaders(token),
      body: JSON.stringify(payload),
    });
    const data = await resp.json().catch(() => ({}));
    const redirectUrl = data?.redirectUrl;

    if (!resp.ok || !redirectUrl) {
      // Roll back the order so failed/blocked attempts don't leave orphans.
      await admin.from("order_items").delete().eq("order_id", order.id);
      await admin.from("orders").delete().eq("id", order.id);
      console.error("PhonePe pay failed", resp.status, JSON.stringify(data));
      return json(
        {
          error: data?.message || "PhonePe initiation failed",
          code: data?.code || null,
          detail: data,
        },
        502,
      );
    }

    return json({ redirectUrl, orderId: order.id });
  } catch (e) {
    console.error("phonepe-pay error", e);
    return json({ error: String((e as Error)?.message || e) }, 500);
  }
});
