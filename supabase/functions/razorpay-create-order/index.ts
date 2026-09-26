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
  stock: number | null;
};

type ProductVariant = {
  label?: unknown;
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
    const { items, address, phone, discount_percent, expected_total_paise } = requestBody as {
      items?: unknown;
      address?: unknown;
      phone?: unknown;
      discount_percent?: unknown;
      expected_total_paise?: unknown;
    };
    if (!Array.isArray(items) || items.length === 0) {
      return json({ error: "Cart is empty" }, 400);
    }
    if (items.length > 50) return json({ error: "Too many cart items" }, 400);
    if (typeof address !== "string" || address.trim().length < 10 || address.length > 500) {
      return json({ error: "Enter a valid shipping address" }, 400);
    }
    const phoneDigits = typeof phone === "string" ? phone.replace(/\D/g, "") : "";
    if (phoneDigits.length !== 10) {
      return json({ error: "Enter a valid 10-digit phone number" }, 400);
    }
    const discountPercent = Number(discount_percent ?? 0);
    if (!Number.isInteger(discountPercent) || discountPercent < 0 || discountPercent > 5) {
      return json({ error: "Invalid discount" }, 400);
    }

    // Fail fast on missing credentials, before creating an orphan order.
    const razorpayKeyId = keyId();

    const admin = createClient(supabaseUrl, serviceKey);

    // Cart item ids may carry a variant suffix ("<product-id>:v<index>") when
    // the shopper picked a size on the product page; the base UUID always
    // resolves to a real product.
    const uuidPattern = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    const baseIds = [...new Set(items.map((item: CartRequestItem) => {
      if (typeof item.product_id !== "string" || !uuidPattern.test(item.product_id.split(":v")[0])) return "";
      return item.product_id.split(":v")[0];
    }))];
    if (baseIds.includes("")) return json({ error: "Invalid cart item" }, 400);
    const { data: products, error: prodErr } = await admin
      .from("products")
      .select("id, price, variants, is_active, stock")
      .in("id", baseIds);
    if (prodErr) throw prodErr;

    const productRows = (products || []) as unknown as ProductRow[];
    const productMap = new Map(productRows.map((product) => [product.id, product]));
    let subtotalPaise = 0;
    const quantitiesByProduct = new Map<string, number>();
    const orderItems: Array<{
      product_id: string;
      quantity: number;
      price: number;
      variant_label: string | null;
    }> = [];
    for (const item of items as CartRequestItem[]) {
      if (typeof item.product_id !== "string") {
        return json({ error: "Invalid cart item" }, 400);
      }
      const rawId = item.product_id;
      const vMatch = rawId.match(/^([0-9a-f-]{36}):v(\d+)$/i);
      if (!uuidPattern.test(rawId) && !vMatch) return json({ error: "Invalid cart item" }, 400);
      const pid = vMatch ? vMatch[1] : rawId;
      const product = productMap.get(pid);
      if (!product || !product.is_active) {
        return json({ error: `Unavailable product: ${pid}` }, 400);
      }
      // Price comes from the DB variant when one was selected, never the client.
      let price = Number(product.price);
      let variantLabel: string | null = null;
      if (vMatch) {
        const variant = (Array.isArray(product.variants)
          ? product.variants as ProductVariant[]
          : []
        )[parseInt(vMatch[2], 10)];
        if (!variant) {
          return json({ error: `Invalid variant for ${pid}` }, 400);
        }
        price = Number(variant.price ?? product.price);
        variantLabel = typeof variant.label === "string" ? variant.label : null;
      }
      if (!Number.isFinite(price) || price <= 0) {
        return json({ error: `Invalid price for ${pid}` }, 400);
      }
      const qty = Number(item.quantity);
      if (!Number.isInteger(qty) || qty < 1 || qty > 100) {
        return json({ error: `Invalid quantity for ${pid}` }, 400);
      }
      const pricePaise = Math.round(price * 100);
      if (Math.abs(price * 100 - pricePaise) > 0.000001) {
        return json({ error: `Invalid price precision for ${pid}` }, 400);
      }
      subtotalPaise += pricePaise * qty;
      quantitiesByProduct.set(pid, (quantitiesByProduct.get(pid) || 0) + qty);
      orderItems.push({
        product_id: pid,
        quantity: qty,
        price,
        variant_label: variantLabel,
      });
    }
    for (const [pid, quantity] of quantitiesByProduct) {
      const stock = Number(productMap.get(pid)?.stock);
      if (!Number.isInteger(stock) || stock < quantity) {
        return json({ error: `Insufficient stock for ${pid}` }, 409);
      }
    }
    // Minimum order value, enforced server-side on the subtotal (excl. shipping)
    // so it can't be bypassed by calling this function directly.
    const MIN_ORDER_VALUE = 2000;
    if (subtotalPaise < MIN_ORDER_VALUE * 100) {
      return json(
        {
          error:
            `Minimum order value is ₹${MIN_ORDER_VALUE}. Please add more items to your cart.`,
        },
        400,
      );
    }

    // The browser chooses the surprise percentage, but the server caps it and
    // calculates the actual saving from authoritative database prices.
    const discountPaise = Math.round(subtotalPaise * discountPercent / 100);
    const discountAmount = discountPaise / 100;
    const amountPaise = subtotalPaise - discountPaise + 10000;
    const total = amountPaise / 100;
    if (!Number.isSafeInteger(amountPaise) || amountPaise <= 0) return json({ error: "Invalid order total" }, 400);
    if (Number(expected_total_paise) !== amountPaise) {
      return json({ error: "Cart prices have changed. Please remove and add the products again before paying." }, 409);
    }

    // Create the pending order.
    const { data: order, error: orderErr } = await admin
      .from("orders")
      .insert({
        user_id: user.id,
        total_amount: total,
        discount_percent: discountPercent,
        discount_amount: discountAmount,
        address: address.trim(),
        status: "pending",
        payment_provider: "razorpay",
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
      .insert(orderItems.map((oi) => ({ ...oi, order_id: order.id })));
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
          amount: amountPaise,
          currency: "INR",
          receipt: order.id,
          notes: {
            user_id: user.id,
            phone: phoneDigits,
            discount_percent: String(discountPercent),
            discount_amount: discountAmount.toFixed(2),
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
      amount: amountPaise,
      currency: "INR",
      discountPercent,
      discountAmount,
    });
  } catch (e) {
    console.error("razorpay-create-order error", e);
    return json({ error: "Could not prepare payment. Please try again." }, 500);
  }
});
