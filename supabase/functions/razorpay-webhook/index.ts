// Razorpay webhook receiver — recovery path for successful payments when the
// shopper closes the browser before the Checkout handler can call verify.
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";
import {
  cors,
  json,
  razorpayFetch,
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

    const eventOrder = event?.payload?.order?.entity;
    const eventPayment = event?.payload?.payment?.entity;
    const providerOrderId = eventPayment?.order_id || eventOrder?.id;
    if (typeof providerOrderId !== "string" || typeof eventPayment?.id !== "string") {
      return json({ received: true, ignored: true });
    }

    // payment.captured often contains only a payment entity. Fetch both
    // provider records so this recovery path works for that event as well.
    const [orderResponse, paymentResponse] = await Promise.all([
      razorpayFetch(`/orders/${encodeURIComponent(providerOrderId)}`),
      razorpayFetch(`/payments/${encodeURIComponent(eventPayment.id)}`),
    ]);
    if (!orderResponse.ok || !paymentResponse.ok) {
      return json({ error: "Could not check payment state" }, 503);
    }
    const [gatewayOrder, payment] = await Promise.all([
      orderResponse.json(), paymentResponse.json(),
    ]);
    const orderId = gatewayOrder?.receipt;
    if (typeof orderId !== "string" || payment?.status !== "captured" || gatewayOrder?.status !== "paid") {
      return json({ error: "Payment is not ready for confirmation" }, 503);
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const admin = createClient(supabaseUrl, serviceKey);
    const { data: order, error: orderError } = await admin
      .from("orders")
      .select("id, total_amount, status, payment_provider, payment_provider_order_id, payment_id, inventory_issue")
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

    if (order.payment_id) {
      return json({ received: true, confirmed: order.payment_id === payment.id });
    }
    if (order.status !== "pending") {
      return json({ received: true, ignored: true });
    }

    const { data: confirmation, error: confirmError } = await admin.rpc(
      "confirm_razorpay_payment",
      {
        p_order_id: order.id,
        p_provider_order_id: gatewayOrder.id,
        p_payment_id: payment.id,
      },
    );
    if (confirmError) throw confirmError;

    return json({ received: true, confirmed: true, orderId, inventoryIssue: confirmation?.inventory_issue === true });
  } catch (e) {
    console.error("razorpay-webhook error", e);
    return json({ error: "Could not process webhook" }, 500);
  }
});
