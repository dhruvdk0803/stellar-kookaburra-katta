// UPI on Delivery order placement — Supabase Edge Function (Deno).
//
// The customer pays by UPI when the order is handed over, so no gateway is
// involved. Flow: authenticate the user, recompute the total from
// authoritative DB prices and the server-decided random discount (never
// trust the client), then call the place_upi_on_delivery_order() SQL function, which in
// ONE transaction re-checks stock under row locks, inserts the order + items
// and reserves (decrements) the stock. Cancelling the order later releases
// that stock again (orders_release_reserved_stock trigger).
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";
import { cors, json } from "../_shared/razorpay.ts";
import { parseCheckoutRequest } from "../_shared/checkout.ts";
import {
  matchesExpectedTotal,
  normalizeDiscountPercent,
  orderSummary,
  priceCart,
  type ProductRow,
  staleTotalBody,
} from "../_shared/pricing.ts";

// place_upi_on_delivery_order() raises SQLSTATE PT409 when a product sold out
// or was hidden between pricing and placement (PostgREST maps PT409 to 409).
const STOCK_CONFLICT_CODE = "PT409";

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

    const admin = createClient(supabaseUrl, serviceKey);
    const [productResult, discountResult] = await Promise.all([
      admin
        .from("products")
        .select("id, price, variants, is_active, stock")
        .in("id", request.productIds),
      // The random discount is decided in SQL from a server-held secret and
      // the cart contents (same cart -> same percent). Only product_id and
      // quantity are sent; nothing the browser claims about a discount is used.
      admin.rpc("get_cart_discount_percent", {
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

    // Same stale-total contract as razorpay-create-order.
    if (!matchesExpectedTotal(request.expectedTotalPaise, priced)) {
      return json(staleTotalBody(priced), 409);
    }
    const summary = orderSummary(priced);

    const { data: orderId, error: placeErr } = await admin.rpc(
      "place_upi_on_delivery_order",
      {
        p_user_id: user.id,
        p_address: request.address,
        p_contact_phone: request.phoneDigits,
        p_items: priced.orderItems,
        p_subtotal_amount: summary.subtotal,
        p_discount_percent: summary.discountPercent,
        p_discount_amount: summary.discountAmount,
        p_shipping_amount: summary.shipping,
        p_total_amount: summary.total,
        p_delivery_latitude: request.location.latitude,
        p_delivery_longitude: request.location.longitude,
        p_delivery_location_label: request.location.label,
      },
    );
    if (placeErr) {
      if (
        placeErr.code === STOCK_CONFLICT_CODE ||
        /^(Insufficient stock|Unavailable product)/.test(placeErr.message ?? "")
      ) {
        return json({ error: placeErr.message || "Some items are no longer available." }, 409);
      }
      throw placeErr;
    }
    if (typeof orderId !== "string" || orderId === "") {
      throw new Error("Order placement returned no order id");
    }

    return json({ dbOrderId: orderId, ...summary });
  } catch (e) {
    console.error("place-upi-order error", e);
    return json({ error: "Could not place your order. Please try again." }, 500);
  }
});
