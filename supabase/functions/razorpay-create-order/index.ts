// Razorpay order creation — Supabase Edge Function (Deno).
//
// Flow: authenticate the user, recompute the order total from authoritative DB
// prices (never trust the client), create a pending order, and create the
// corresponding Razorpay order. Returns the Razorpay key id + order id so the
// client can open checkout.js.
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";
import { cors, json, keyId, razorpayFetch } from "../_shared/razorpay.ts";

type CartRequestItem = {
  product_id?: unknown;
  quantity?: unknown;
};

type ProductRow = {
  id: string;
  price: unknown;
  variants?: unknown;
  is_active: boolean;
};

type ProductVariant = {
  price?: unknown;
};

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

    const requestBody: unknown = await req.json();
    if (!requestBody || typeof requestBody !== "object") {
      return json({ error: "Invalid checkout request" }, 400);
    }
    const { items, address, phone } = requestBody as {
      items?: unknown;
      address?: unknown;
      phone?: unknown;
    };
    if (!Array.isArray(items) || items.length === 0) {
      return json({ error: "Cart is empty" }, 400);
    }
    if (!address || typeof address !== "string") {
      return json({ error: "Address is required" }, 400);
    }

    // Fail fast on missing credentials, before creating an orphan order.
    const razorpayKeyId = keyId();

    const admin = createClient(supabaseUrl, serviceKey);

    // Cart item ids may carry a variant suffix ("<product-id>:v<index>") when
    // the shopper picked a size on the product page; the base UUID always
    // resolves to a real product.
    const baseIds = [
      ...new Set(items.map((item: CartRequestItem) => {
        if (typeof item.product_id !== "string") return "";
        return item.product_id.split(":v")[0];
      })),
    ];
    if (baseIds.includes("")) return json({ error: "Invalid cart item" }, 400);
    const { data: products, error: prodErr } = await admin
      .from("products")
      .select("id, price, variants, is_active")
      .in("id", baseIds);
    if (prodErr) throw prodErr;

    const productRows = (products || []) as unknown as ProductRow[];
    const productMap = new Map(productRows.map((product) => [product.id, product]));
    let subtotal = 0;
    const orderItems: Array<{ product_id: string; quantity: number; price: number }> = [];
    for (const item of items as CartRequestItem[]) {
      if (typeof item.product_id !== "string") {
        return json({ error: "Invalid cart item" }, 400);
      }
      const rawId = item.product_id;
      const vMatch = rawId.match(/^(.+):v(\d+)$/);
      const pid = vMatch ? vMatch[1] : rawId;
      const product = productMap.get(pid);
      if (!product || !product.is_active) {
        return json({ error: `Unavailable product: ${pid}` }, 400);
      }
      // Price comes from the DB variant when one was selected, never the client.
      let price = Number(product.price);
      if (vMatch) {
        const variant = (Array.isArray(product.variants)
          ? product.variants as ProductVariant[]
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
      const qty = Number(item.quantity);
      if (!Number.isInteger(qty) || qty < 1) {
        return json({ error: `Invalid quantity for ${pid}` }, 400);
      }
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
        payment_provider: "razorpay",
        payment_status: "created",
      })
      .select()
      .single();
    if (orderErr) throw orderErr;

    const { error: itemsErr } = await admin
      .from("order_items")
      .insert(orderItems.map((oi) => ({ ...oi, order_id: order.id })));
    if (itemsErr) throw itemsErr;

    // Create the Razorpay order (amount in paise).
    const amountPaise = Math.round(total * 100);
    const resp = await razorpayFetch("/orders", {
      method: "POST",
      body: JSON.stringify({
        amount: amountPaise,
        currency: "INR",
        receipt: order.id,
        notes: {
          user_id: user.id,
          phone: String(phone || "").replace(/\D/g, "").slice(-10),
        },
      }),
    });
    const data = await resp.json().catch(() => ({}));

    if (!resp.ok || !data?.id) {
      // Roll back the order so failed attempts don't leave orphans.
      await admin.from("order_items").delete().eq("order_id", order.id);
      await admin.from("orders").delete().eq("id", order.id);
      console.error("Razorpay order creation failed", resp.status, JSON.stringify(data));
      return json(
        {
          error:
            data?.error?.description || data?.error?.reason ||
            "Razorpay order creation failed",
          detail: data,
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
      return json({ error: "Could not prepare payment. Please try again." }, 500);
    }

    return json({
      keyId: razorpayKeyId,
      rzpOrderId: data.id,
      dbOrderId: order.id,
      amount: amountPaise,
      currency: "INR",
    });
  } catch (e) {
    console.error("razorpay-create-order error", e);
    return json({ error: String((e as Error)?.message || e) }, 500);
  }
});
