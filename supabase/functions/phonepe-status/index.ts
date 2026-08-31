// PhonePe order status check — Supabase Edge Function (Standard Checkout V2).
//
// Called by our /payment-status page (and usable as a webhook landing point)
// after the user is redirected back from PhonePe. It queries PhonePe's
// authoritative order-status API and updates the order: 'confirmed' on
// COMPLETED, otherwise left 'pending' (the orders.status CHECK constraint has
// no 'failed' state). Public (verify_jwt = false) so PhonePe's server can reach
// it; it trusts only PhonePe's response, never the caller.
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

  try {
    const url = new URL(req.url);
    let orderId = url.searchParams.get("order");
    if (!orderId && req.method === "POST") {
      try {
        const body = await req.json();
        orderId = body.order || body.orderId ||
          body?.payload?.merchantOrderId || null;
      } catch {
        // ignore — fall back to ?order=
      }
    }
    if (!orderId) return json({ error: "order id required" }, 400);

    const token = await getAccessToken();

    const resp = await fetch(
      `${pgBase()}/checkout/v2/order/${orderId}/status?details=false`,
      { method: "GET", headers: authHeaders(token) },
    );
    const data = await resp.json().catch(() => ({}));

    if (!resp.ok) {
      console.error("PhonePe status failed", resp.status, JSON.stringify(data));
      return json({
        orderId,
        success: false,
        code: data?.code || null,
        state: "UNKNOWN",
        error: data?.message || "Status lookup failed",
      }, 502);
    }

    // V2 states: PENDING | COMPLETED | FAILED
    const state = (data?.state as string | undefined) || "UNKNOWN";
    const success = state === "COMPLETED";

    if (success) {
      const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
      const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
      const admin = createClient(supabaseUrl, serviceKey);
      await admin
        .from("orders")
        .update({ status: "confirmed" })
        .eq("id", orderId);
    }

    return json({
      orderId,
      success,
      code: state,
      state,
      amount: data?.amount ?? null,
    });
  } catch (e) {
    console.error("phonepe-status error", e);
    return json({ error: String((e as Error)?.message || e) }, 500);
  }
});
