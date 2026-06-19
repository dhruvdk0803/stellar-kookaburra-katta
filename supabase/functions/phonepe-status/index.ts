// PhonePe (PG / Hermes) payment status check + callback — Supabase Edge Function.
//
// Called two ways:
//   1. By PhonePe's server (the callbackUrl) after the user pays.
//   2. By our frontend /payment-status page when the user is redirected back.
//
// Either way it queries PhonePe's authoritative status API, then updates the
// order: 'confirmed' on success, otherwise left 'pending' (the orders.status
// CHECK constraint has no 'failed' state). Public (verify_jwt = false) so the
// PhonePe server callback can reach it; it trusts only PhonePe's signed status.
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
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

  try {
    const url = new URL(req.url);
    let orderId = url.searchParams.get("order");
    if (!orderId && req.method === "POST") {
      try {
        const body = await req.json();
        orderId = body.order || body.orderId || null;
      } catch {
        // ignore — PhonePe callback posts a different shape; we rely on ?order=
      }
    }
    if (!orderId) return json({ error: "order id required" }, 400);

    const merchantId = Deno.env.get("PHONEPE_MERCHANT_ID")!;
    const saltKey = Deno.env.get("PHONEPE_SALT_KEY")!;
    const saltIndex = Deno.env.get("PHONEPE_SALT_INDEX") || "1";
    const base =
      Deno.env.get("PHONEPE_BASE_URL") || "https://api.phonepe.com/apis/hermes";

    const path = `/pg/v1/status/${merchantId}/${orderId}`;
    const xVerify =
      (await sha256Hex(path + saltKey)) + "###" + saltIndex;

    const resp = await fetch(`${base}${path}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "X-VERIFY": xVerify,
        "X-MERCHANT-ID": merchantId,
      },
    });
    const data = await resp.json();

    const code = data?.code as string | undefined;
    const state = data?.data?.state as string | undefined;
    const success = data?.success === true && code === "PAYMENT_SUCCESS";

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const admin = createClient(supabaseUrl, serviceKey);

    if (success) {
      await admin
        .from("orders")
        .update({ status: "confirmed" })
        .eq("id", orderId);
    }

    return json({
      orderId,
      success,
      code: code || null,
      state: state || code || "UNKNOWN",
      amount: data?.data?.amount ?? null,
    });
  } catch (e) {
    return json({ error: String((e as Error)?.message || e) }, 500);
  }
});
