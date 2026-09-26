#!/usr/bin/env bash
# One-shot Razorpay + Supabase Edge Function setup.
#
# Reads credentials from ../.razorpay.env, pushes them to Supabase as function
# secrets, applies pending database migrations, and deploys the Razorpay
# functions. Secret values are never echoed.
#
# Usage:  bash scripts/setup-razorpay.sh
set -euo pipefail

cd "$(dirname "$0")/.."

PROJECT_REF="jcqqepifotecmrjdyeup"
ENV_FILE=".razorpay.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE not found."
  echo "Copy .razorpay.env.example to .razorpay.env and fill in the values first."
  exit 1
fi

# shellcheck disable=SC1090
set -a; . "./$ENV_FILE"; set +a

missing=()
for v in SUPABASE_ACCESS_TOKEN RAZORPAY_KEY_ID RAZORPAY_KEY_SECRET RAZORPAY_WEBHOOK_SECRET; do
  [ -z "${!v:-}" ] && missing+=("$v")
done
if [ ${#missing[@]} -gt 0 ]; then
  echo "ERROR: these are still empty in $ENV_FILE: ${missing[*]}"
  exit 1
fi

export SUPABASE_ACCESS_TOKEN
SB="npx --yes supabase@2.116.0"

echo "==> 1/4 Checking Supabase access token"
$SB projects list >/dev/null
echo "    OK"

echo "==> 2/4 Applying pending database migrations"
$SB db push --project-ref "$PROJECT_REF"
echo "    Done"

echo "==> 3/4 Setting Edge Function secrets"
$SB secrets set --project-ref "$PROJECT_REF" \
  "RAZORPAY_KEY_ID=$RAZORPAY_KEY_ID" \
  "RAZORPAY_KEY_SECRET=$RAZORPAY_KEY_SECRET" \
  "RAZORPAY_WEBHOOK_SECRET=$RAZORPAY_WEBHOOK_SECRET" >/dev/null
echo "    Done"

echo "==> 4/4 Deploying functions"
$SB functions deploy razorpay-create-order razorpay-verify razorpay-webhook --project-ref "$PROJECT_REF"

# Remove the obsolete PhonePe functions and secrets, if present. Harmless.
$SB functions delete phonepe-pay --project-ref "$PROJECT_REF" >/dev/null 2>&1 || true
$SB functions delete phonepe-status --project-ref "$PROJECT_REF" >/dev/null 2>&1 || true
$SB secrets unset --project-ref "$PROJECT_REF" \
  PHONEPE_CLIENT_ID PHONEPE_CLIENT_SECRET PHONEPE_CLIENT_VERSION PHONEPE_ENV \
  PHONEPE_MERCHANT_ID PHONEPE_SALT_KEY PHONEPE_SALT_INDEX PHONEPE_BASE_URL \
  >/dev/null 2>&1 || true

rm -f "$ENV_FILE"
echo "Removed $ENV_FILE."
echo
echo "Dashboard action still required: create a Razorpay webhook for"
echo "https://$PROJECT_REF.supabase.co/functions/v1/razorpay-webhook"
echo "using the same RAZORPAY_WEBHOOK_SECRET and enable payment.captured + order.paid."
