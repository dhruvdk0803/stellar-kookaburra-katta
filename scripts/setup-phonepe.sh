#!/usr/bin/env bash
# One-shot PhonePe + Supabase Edge Function setup.
#
# Reads credentials from ../.phonepe.env, pushes them to Supabase as function
# secrets, deploys the two PhonePe functions, and verifies that PhonePe's OAuth
# handshake actually succeeds. Secret values are never echoed.
#
# Usage:  bash scripts/setup-phonepe.sh
set -euo pipefail

cd "$(dirname "$0")/.."

PROJECT_REF="jcqqepifotecmrjdyeup"
ENV_FILE=".phonepe.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE not found."
  echo "Copy .phonepe.env.example to .phonepe.env and fill in the values first."
  exit 1
fi

# shellcheck disable=SC1090
set -a; . "./$ENV_FILE"; set +a

missing=()
for v in SUPABASE_ACCESS_TOKEN PHONEPE_CLIENT_ID PHONEPE_CLIENT_SECRET; do
  [ -z "${!v:-}" ] && missing+=("$v")
done
if [ ${#missing[@]} -gt 0 ]; then
  echo "ERROR: these are still empty in $ENV_FILE: ${missing[*]}"
  exit 1
fi

PHONEPE_CLIENT_VERSION="${PHONEPE_CLIENT_VERSION:-1}"
PHONEPE_ENV="${PHONEPE_ENV:-SANDBOX}"
APP_BASE_URL="${APP_BASE_URL:-}"

export SUPABASE_ACCESS_TOKEN
SB="npx --yes supabase@2.116.0"

echo "==> 1/5 Checking Supabase access token"
$SB projects list >/dev/null
echo "    OK"

echo "==> 2/5 Verifying PhonePe credentials against their OAuth endpoint"
if [ "$(printf '%s' "$PHONEPE_ENV" | tr '[:lower:]' '[:upper:]')" = "PRODUCTION" ]; then
  AUTH_URL="https://api.phonepe.com/apis/identity-manager/v1/oauth/token"
else
  AUTH_URL="https://api-preprod.phonepe.com/apis/pg-sandbox/v1/oauth/token"
fi
AUTH_BODY=$(curl -s -m 30 -X POST "$AUTH_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "client_id=$PHONEPE_CLIENT_ID" \
  --data-urlencode "client_secret=$PHONEPE_CLIENT_SECRET" \
  --data-urlencode "client_version=$PHONEPE_CLIENT_VERSION" \
  --data-urlencode "grant_type=client_credentials")
if printf '%s' "$AUTH_BODY" | grep -q '"access_token"'; then
  echo "    OK - PhonePe issued a token for $PHONEPE_ENV"
else
  echo "    FAILED. PhonePe's response (no token issued):"
  printf '    %s\n' "$AUTH_BODY"
  echo "    Check the client_id/client_secret/client_version and PHONEPE_ENV."
  exit 1
fi

echo "==> 3/5 Setting Edge Function secrets"
$SB secrets set --project-ref "$PROJECT_REF" \
  "PHONEPE_CLIENT_ID=$PHONEPE_CLIENT_ID" \
  "PHONEPE_CLIENT_SECRET=$PHONEPE_CLIENT_SECRET" \
  "PHONEPE_CLIENT_VERSION=$PHONEPE_CLIENT_VERSION" \
  "PHONEPE_ENV=$PHONEPE_ENV" \
  ${APP_BASE_URL:+"APP_BASE_URL=$APP_BASE_URL"} >/dev/null
echo "    Done"

# The dead V1 secrets, if present. Failure here is harmless.
$SB secrets unset --project-ref "$PROJECT_REF" \
  PHONEPE_MERCHANT_ID PHONEPE_SALT_KEY PHONEPE_SALT_INDEX PHONEPE_BASE_URL \
  >/dev/null 2>&1 || true

echo "==> 4/5 Deploying functions"
$SB functions deploy phonepe-pay phonepe-status --project-ref "$PROJECT_REF"

echo "==> 5/5 Smoke-testing the deployed status function"
RESP=$(curl -s -m 40 -X POST \
  "https://$PROJECT_REF.supabase.co/functions/v1/phonepe-status" \
  -H "Content-Type: application/json" \
  -d '{"order":"00000000-0000-0000-0000-000000000000"}')
echo "    $RESP"
echo
if printf '%s' "$RESP" | grep -q 'BLOCKED_MERCHANT'; then
  echo "STILL BLOCKED - the credentials are not valid for this environment."
elif printf '%s' "$RESP" | grep -qi 'not.*found\|does not exist\|NOT_FOUND'; then
  echo "SUCCESS - PhonePe authenticated and reported 'unknown order', which is"
  echo "the correct answer for a fake order id. The gateway is live."
else
  echo "Review the response above."
fi

rm -f "$ENV_FILE"
echo "Removed $ENV_FILE."
