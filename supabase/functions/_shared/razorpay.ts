// Shared Razorpay helpers — Standard Checkout (Orders API + signature verify).
//
// Flow: create an order server-side via the Orders API (key id + secret), hand
// the `order_id` to the Razorpay checkout.js client, then verify the payment's
// HMAC-SHA256 signature (payload `order_id|payment_id`) server-side before
// marking the order confirmed.

export const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
};

export function json(obj: unknown, status = 200) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { ...cors, "Content-Type": "application/json" },
  });
}

export function keyId(): string {
  const v = Deno.env.get("RAZORPAY_KEY_ID");
  if (!v) {
    throw new Error("Razorpay is not configured: set RAZORPAY_KEY_ID.");
  }
  return v;
}

export function keySecret(): string {
  const v = Deno.env.get("RAZORPAY_KEY_SECRET");
  if (!v) {
    throw new Error("Razorpay is not configured: set RAZORPAY_KEY_SECRET.");
  }
  return v;
}

/** Fetch a Razorpay API endpoint with HTTP Basic auth (key id:secret). */
export function razorpayFetch(path: string, init: RequestInit = {}) {
  const auth = btoa(`${keyId()}:${keySecret()}`);
  return fetch(`https://api.razorpay.com/v1${path}`, {
    ...init,
    headers: {
      Authorization: `Basic ${auth}`,
      "Content-Type": "application/json",
      ...(init.headers || {}),
    },
  });
}

/** Compare two signatures without exiting early on the first mismatch. */
export function signaturesMatch(expected: string, received: string): boolean {
  if (expected.length !== received.length) return false;
  let difference = 0;
  for (let i = 0; i < expected.length; i += 1) {
    difference |= expected.charCodeAt(i) ^ received.charCodeAt(i);
  }
  return difference === 0;
}

async function hmacHex(payload: string, secret: string): Promise<string> {
  const enc = new TextEncoder();
  const key = await crypto.subtle.importKey(
    "raw",
    enc.encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const sig = await crypto.subtle.sign("HMAC", key, enc.encode(payload));
  return [...new Uint8Array(sig)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

/**
 * Verify a Razorpay payment signature (HMAC-SHA256, hex, of
 * `order_id|payment_id`) against the merchant key secret.
 */
export async function verifySignature(
  orderId: string,
  paymentId: string,
  signature: string,
): Promise<boolean> {
  const payload = `${orderId}|${paymentId}`;
  const hex = await hmacHex(payload, keySecret());
  return signaturesMatch(hex, signature.toLowerCase());
}

/** Verify a webhook body using the secret configured in Razorpay Dashboard. */
export async function verifyWebhookSignature(
  rawBody: string,
  signature: string | null,
): Promise<boolean> {
  const secret = Deno.env.get("RAZORPAY_WEBHOOK_SECRET");
  if (!secret) {
    throw new Error("Razorpay webhook is not configured: set RAZORPAY_WEBHOOK_SECRET.");
  }
  if (!signature) return false;
  const hex = await hmacHex(rawBody, secret);
  return signaturesMatch(hex, signature.toLowerCase());
}
