// Shared PhonePe helpers — Standard Checkout V2 (OAuth / O-Bearer).
//
// The old PG "Hermes" V1 API (salt key + X-VERIFY hash on /pg/v1/*) is
// deprecated and returns BLOCKED_MERCHANT for merchants provisioned with V2
// credentials. V2 uses client_id / client_secret / client_version to mint a
// short-lived access token, which is then sent as `Authorization: O-Bearer …`.

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

/** SANDBOX until PHONEPE_ENV is explicitly set to PRODUCTION. */
function isProd(): boolean {
  return (Deno.env.get("PHONEPE_ENV") || "SANDBOX").toUpperCase() ===
    "PRODUCTION";
}

/** Base URL for the payment APIs (pay / order status). */
export function pgBase(): string {
  return isProd()
    ? "https://api.phonepe.com/apis/pg"
    : "https://api-preprod.phonepe.com/apis/pg-sandbox";
}

/** Base URL for the OAuth token API — a *different* host in production. */
function authUrl(): string {
  return isProd()
    ? "https://api.phonepe.com/apis/identity-manager/v1/oauth/token"
    : "https://api-preprod.phonepe.com/apis/pg-sandbox/v1/oauth/token";
}

// Cached across invocations while the isolate stays warm; refreshed 60s early.
let cachedToken: { token: string; expiresAt: number } | null = null;

export async function getAccessToken(): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  if (cachedToken && cachedToken.expiresAt - 60 > now) return cachedToken.token;

  const clientId = Deno.env.get("PHONEPE_CLIENT_ID");
  const clientSecret = Deno.env.get("PHONEPE_CLIENT_SECRET");
  const clientVersion = Deno.env.get("PHONEPE_CLIENT_VERSION") || "1";
  if (!clientId || !clientSecret) {
    throw new Error(
      "PhonePe is not configured: set PHONEPE_CLIENT_ID and PHONEPE_CLIENT_SECRET.",
    );
  }

  const body = new URLSearchParams({
    client_id: clientId,
    client_version: clientVersion,
    client_secret: clientSecret,
    grant_type: "client_credentials",
  });

  const resp = await fetch(authUrl(), {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body,
  });
  const data = await resp.json().catch(() => ({}));

  if (!resp.ok || !data?.access_token) {
    throw new Error(
      `PhonePe auth failed (${resp.status}): ${
        data?.message || data?.code || JSON.stringify(data)
      }`,
    );
  }

  cachedToken = {
    token: data.access_token,
    expiresAt: Number(data.expires_at) || now + 600,
  };
  return cachedToken.token;
}

export function authHeaders(token: string) {
  return {
    "Content-Type": "application/json",
    Authorization: `O-Bearer ${token}`,
  };
}
