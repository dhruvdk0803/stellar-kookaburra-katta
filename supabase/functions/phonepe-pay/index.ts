// PhonePe (PG / Hermes) payment initiation — Supabase Edge Function (Deno).
//
// Flow: authenticate the user, recompute the order total from authoritative
// DB prices (never trust the client), create a pending order, sign the request
// with the PhonePe salt key (X-VERIFY), call /pg/v1/pay, and return the hosted
// checkout redirect URL.
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(obj: unknown, status = 200) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { ...cors, "Content-Type": "application/json" },
  });
}

async function sha256Hex(msg: string): Promise<string> {
  const buf = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(msg),
  );
  return [...new Uint8Array(buf)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

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

    // Build & sign the PhonePe pay request.
    const merchantId = Deno.env.get("PHONEPE_MERCHANT_ID")!;
    const saltKey = Deno.env.get("PHONEPE_SALT_KEY")!;
    const saltIndex = Deno.env.get("PHONEPE_SALT_INDEX") || "1";
    const base =
      Deno.env.get("PHONEPE_BASE_URL") || "https://api.phonepe.com/apis/hermes";
    const appOrigin = (
      req.headers.get("origin") ||
      Deno.env.get("APP_BASE_URL") ||
      ""
    ).replace(/\/$/, "");

    const payload = {
      merchantId,
      merchantTransactionId: order.id, // UUID, ≤38 chars, alphanumeric + '-'
      merchantUserId: user.id.replace(/-/g, "").slice(0, 36),
      amount: Math.round(total * 100), // paise
      redirectUrl: `${appOrigin}/payment-status?order=${order.id}`,
      redirectMode: "REDIRECT",
      callbackUrl: `${supabaseUrl}/functions/v1/phonepe-status?order=${order.id}`,
      mobileNumber: String(phone || "").replace(/\D/g, "").slice(-10),
      paymentInstrument: { type: "PAY_PAGE" },
    };

    const base64 = btoa(JSON.stringify(payload));
    const xVerify =
      (await sha256Hex(base64 + "/pg/v1/pay" + saltKey)) + "###" + saltIndex;

    const resp = await fetch(`${base}/pg/v1/pay`, {
      method: "POST",
      headers: { "Content-Type": "application/json", "X-VERIFY": xVerify },
      body: JSON.stringify({ request: base64 }),
    });
    const data = await resp.json();
    const redirectUrl = data?.data?.instrumentResponse?.redirectInfo?.url;

    if (!redirectUrl) {
      // Roll back the order so failed/blocked attempts don't leave orphans.
      await admin.from("order_items").delete().eq("order_id", order.id);
      await admin.from("orders").delete().eq("id", order.id);
      return json(
        {
          error: "PhonePe initiation failed",
          code: data?.code || null,
          detail: data,
        },
        502,
      );
    }

    return json({ redirectUrl, orderId: order.id });
  } catch (e) {
    return json({ error: String((e as Error)?.message || e) }, 500);
  }
});
