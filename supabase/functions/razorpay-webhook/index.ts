// Razorpay webhook receiver — recovery path for successful payments when the
// shopper closes the browser before the Checkout handler can call verify.
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";
import {
  cors,
  json,
  verifyWebhookSignature,
} from "../_shared/razorpay.ts";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405);

  try {
    // Verify the exact raw body before parsing it; re-serialising JSON would
    // produce a different byte sequence and invalidate Razorpay's signature.
    const rawBody = await req.text();
    const signature = req.headers.get("x-razorpay-signature");
    if (!await verifyWebhookSignature(rawBody, signature)) {
      return json({ error: "Invalid webhook signature" }, 401);
    }

    const event = JSON.parse(rawBody);
    const eventName = event?.event;
    if (eventName !== "payment.captured" && eventName !== "order.paid") {
      return json({ received: true, ignored: true });
    }

    const gatewayOrder = event?.payload?.order?.entity;
    const payment = event?.payload?.payment?.entity;
    const orderId = gatewayOrder?.receipt;
    if (
      typeof orderId !== "string" ||
      typeof gatewayOrder?.id !== "string" ||
      typeof payment?.id !== "string" ||
      payment?.status !== "captured"
    ) {
      return json({ received: true, ignored: true });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const admin = createClient(supabaseUrl, serviceKey);
    const { data: order, error: orderError } = await admin
      .from("orders")
      .select("id, total_amount, status, payment_provider, payment_provider_order_id, payment_id")
      .eq("id", orderId)
      .single();
    if (orderError || !order) return json({ received: true, ignored: true });

    const expectedAmount = Math.round(Number(order.total_amount) * 100);
    if (
      order.payment_provider !== "razorpay" ||
      order.payment_provider_order_id !== gatewayOrder.id ||
      payment.order_id !== gatewayOrder.id ||
      Number(gatewayOrder.amount) !== expectedAmount ||
      Number(payment.amount) !== expectedAmount
    ) {
      console.error("Razorpay webhook payment state mismatch", orderId);
      return json({ error: "Payment order mismatch" }, 400);
    }

    if (order.status === "confirmed") {
      return json({ received: true, confirmed: order.payment_id === payment.id });
    }
    if (order.status !== "pending") {
      return json({ received: true, ignored: true });
    }

    const { error: updateError } = await admin
      .from("orders")
      .update({
        status: "confirmed",
        payment_id: payment.id,
        payment_status: payment.status,
        payment_verified_at: new Date().toISOString(),
      })
      .eq("id", order.id);
    if (updateError) throw updateError;

    return json({ received: true, confirmed: true, orderId });
  } catch (e) {
    console.error("razorpay-webhook error", e);
    return json({ error: String((e as Error)?.message || e) }, 500);
  }
});
