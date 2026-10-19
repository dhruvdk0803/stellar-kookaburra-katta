// Owner WhatsApp alert for a new order, sent with the official WhatsApp Cloud
// API (Meta) as the approved template described in orderAlert.ts.
//
// Secrets (supabase secrets set ...):
//   WHATSAPP_TOKEN            permanent System User access token (whatsapp_business_messaging)
//   WHATSAPP_PHONE_NUMBER_ID  "Phone number ID" of the sending number (API Setup page)
//   OWNER_WHATSAPP            owner's WhatsApp number, e.g. 919876543210
// Optional: WHATSAPP_TEMPLATE (default new_order_alert),
//           WHATSAPP_TEMPLATE_LANG (default en), WHATSAPP_API_VERSION (default v25.0).
//
// Guarantees:
//   * at most one alert per order: orders.owner_notified_at is claimed with a
//     conditional UPDATE, so razorpay-verify and razorpay-webhook racing on the
//     same payment send one message;
//   * never breaks checkout: every failure is logged and swallowed, and a failed
//     send releases the claim so a later confirmation can retry.
import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";
import { buildOrderAlertParams, toWhatsAppNumber } from "./orderAlert.ts";

const SEND_TIMEOUT_MS = 10_000;

declare const EdgeRuntime: { waitUntil(promise: Promise<unknown>): void } | undefined;

const env = (name: string, fallback = ""): string => Deno.env.get(name)?.trim() || fallback;

async function sendOwnerAlert(admin: SupabaseClient, orderId: string): Promise<void> {
  const token = env("WHATSAPP_TOKEN");
  const phoneNumberId = env("WHATSAPP_PHONE_NUMBER_ID");
  const owner = toWhatsAppNumber(env("OWNER_WHATSAPP"));
  if (!token || !phoneNumberId || !owner) {
    console.warn("Owner order alert skipped: WHATSAPP_TOKEN / WHATSAPP_PHONE_NUMBER_ID / OWNER_WHATSAPP not set");
    return;
  }

  const { data: order, error: claimError } = await admin
    .from("orders")
    .update({ owner_notified_at: new Date().toISOString() })
    .eq("id", orderId)
    .is("owner_notified_at", null)
    .select("id, user_id, total_amount, discount_amount, payment_provider, address, contact_phone, delivery_latitude, delivery_longitude")
    .maybeSingle();
  if (claimError) {
    console.error("Owner order alert: could not claim order", orderId, claimError.message);
    return;
  }
  if (!order) return; // already alerted (or no such order)

  const release = async () => {
    const { error } = await admin.from("orders").update({ owner_notified_at: null }).eq("id", orderId);
    if (error) console.error("Owner order alert: could not release claim", orderId, error.message);
  };

  try {
    const [itemsResult, profileResult] = await Promise.all([
      admin
        .from("order_items")
        .select("product_name_snapshot, variant_label, quantity, price")
        .eq("order_id", orderId),
      admin.from("profiles").select("name").eq("id", order.user_id).maybeSingle(),
    ]);
    if (itemsResult.error) throw itemsResult.error;

    const params = buildOrderAlertParams(order, itemsResult.data ?? [], profileResult.data?.name ?? "");
    const url = `https://graph.facebook.com/${env("WHATSAPP_API_VERSION", "v25.0")}/${phoneNumberId}/messages`;
    const response = await fetch(url, {
      method: "POST",
      headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        messaging_product: "whatsapp",
        to: owner,
        type: "template",
        template: {
          name: env("WHATSAPP_TEMPLATE", "new_order_alert"),
          language: { code: env("WHATSAPP_TEMPLATE_LANG", "en") },
          components: [{ type: "body", parameters: params.map((text) => ({ type: "text", text })) }],
        },
      }),
      signal: AbortSignal.timeout(SEND_TIMEOUT_MS),
    });
    if (!response.ok) {
      const body = await response.json().catch(() => null);
      throw new Error(`WhatsApp API HTTP ${response.status}: ${body?.error?.message ?? "unknown error"}`);
    }
  } catch (e) {
    console.error("Owner order alert failed", orderId, e instanceof Error ? e.message : e);
    await release();
  }
}

/**
 * Alert the owner about a confirmed/placed order without delaying the customer's
 * response: runs in the background when the runtime supports it. Never throws.
 */
export function notifyOwnerOfOrder(admin: SupabaseClient, orderId: string): void {
  const task = sendOwnerAlert(admin, orderId).catch((e) =>
    console.error("Owner order alert crashed", orderId, e instanceof Error ? e.message : e)
  );
  if (typeof EdgeRuntime !== "undefined" && EdgeRuntime?.waitUntil) EdgeRuntime.waitUntil(task);
}
