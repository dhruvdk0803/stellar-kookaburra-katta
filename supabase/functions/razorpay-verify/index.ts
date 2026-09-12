// Razorpay payment verification — Supabase Edge Function (Deno).
//
// A signed Checkout response is necessary but not sufficient: this function
// also binds it to the caller's pending local order and checks Razorpay's
// authoritative order/payment records before confirming fulfilment.
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";
import {
  cors,
  json,
  razorpayFetch,
  verifySignature,
} from "../_shared/razorpay.ts";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return json({ verified: false, error: "Method not allowed" }, 405);

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const authHeader = req.headers.get("Authorization") || "";
    const userClient = createClient(supabaseUrl, anonKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const {
      data: { user },
    } = await userClient.auth.getUser();
    if (!user) return json({ verified: false, error: "Unauthorized" }, 401);

    const body = await req.json();
    const orderId = body?.order;
    const razorpayOrderId = body?.razorpay_order_id;
    const razorpayPaymentId = body?.razorpay_payment_id;
    const razorpaySignature = body?.razorpay_signature;
    if (
      typeof orderId !== "string" ||
      typeof razorpayOrderId !== "string" ||
      typeof razorpayPaymentId !== "string" ||
      typeof razorpaySignature !== "string"
    ) {
      return json({ verified: false, error: "Missing payment fields" }, 400);
    }

    const admin = createClient(supabaseUrl, serviceKey);
    const { data: order, error: orderError } = await admin
      .from("orders")
      .select("id, user_id, total_amount, status, payment_provider, payment_provider_order_id, payment_id")
      .eq("id", orderId)
      .single();
    if (orderError || !order || order.user_id !== user.id) {
      return json({ verified: false, error: "Order not found" }, 404);
    }

    // A duplicate client request after a successful redirect is harmless, but
    // only when it refers to the same payment already stored on the order.
    if (order.status === "confirmed") {
      return json({
        verified: order.payment_id === razorpayPaymentId,
        orderId,
        error: order.payment_id === razorpayPaymentId ? undefined : "Order is already confirmed",
      }, order.payment_id === razorpayPaymentId ? 200 : 409);
    }
    if (order.status !== "pending") {
      return json({ verified: false, error: "Order is not payable" }, 409);
    }
    if (
      order.payment_provider !== "razorpay" ||
      order.payment_provider_order_id !== razorpayOrderId
    ) {
      return json({ verified: false, error: "Payment order mismatch" }, 400);
    }

    // Razorpay requires the order id held by the server for HMAC validation;
    // never substitute an id supplied by Checkout here.
    const valid = await verifySignature(
      order.payment_provider_order_id,
      razorpayPaymentId,
      razorpaySignature,
    );
    if (!valid) {
      console.error("Razorpay signature verification failed", orderId);
      return json({ verified: false, error: "Invalid payment signature" }, 400);
    }

    const expectedAmount = Math.round(Number(order.total_amount) * 100);
    const [gatewayOrderResponse, paymentResponse] = await Promise.all([
      razorpayFetch(`/orders/${order.payment_provider_order_id}`),
      razorpayFetch(`/payments/${razorpayPaymentId}`),
    ]);
    const [gatewayOrder, payment] = await Promise.all([
      gatewayOrderResponse.json().catch(() => ({})),
      paymentResponse.json().catch(() => ({})),
    ]);

    // The order and payment must always match the amount created from database
    // prices. Payment capture can lag a successful Checkout handler briefly.
    if (
      !gatewayOrderResponse.ok ||
      !paymentResponse.ok ||
      gatewayOrder?.receipt !== order.id ||
      Number(gatewayOrder?.amount) !== expectedAmount ||
      payment?.order_id !== order.payment_provider_order_id ||
      Number(payment?.amount) !== expectedAmount
    ) {
      console.error("Razorpay payment state mismatch", orderId);
      return json({ verified: false, error: "Payment state mismatch" }, 409);
    }
    if (gatewayOrder?.status !== "paid" || payment?.status !== "captured") {
      if (payment?.status === "authorized") {
        return json({ verified: false, pending: true, orderId }, 202);
      }
      return json({ verified: false, error: "Payment has not been captured" }, 409);
    }

    const { error: updateError } = await admin
      .from("orders")
      .update({
        status: "confirmed",
        payment_id: razorpayPaymentId,
        payment_status: payment.status,
        payment_verified_at: new Date().toISOString(),
      })
      .eq("id", order.id)
      .eq("user_id", user.id);
    if (updateError) throw updateError;

    return json({ verified: true, orderId });
  } catch (e) {
    console.error("razorpay-verify error", e);
    return json({ verified: false, error: String((e as Error)?.message || e) }, 500);
  }
});
