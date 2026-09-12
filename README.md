# Katta Interiors

## Local development

```bash
npm install
npm run dev
```

## Razorpay payment setup

The checkout uses Razorpay Standard Checkout and Supabase Edge Functions. The
server recalculates prices from the database, so browser cart prices are never
trusted.

1. Copy `.razorpay.env.example` to `.razorpay.env` and fill in the Supabase
   access token, Razorpay API keys, and a new webhook secret. Do not commit it.
2. Run `bash scripts/setup-razorpay.sh`. It applies the payment metadata
   migration, sets Supabase secrets, deploys the Razorpay functions, and
   removes the legacy PhonePe functions and secrets.
3. In Razorpay Dashboard, enable automatic payment capture. Add the webhook URL
   printed by the script, use the same webhook secret, and subscribe to
   `payment.captured` and `order.paid`.
4. Make a test-mode payment before swapping to live Razorpay keys.

The webhook is a recovery path if a customer closes the page before the browser
can complete the normal signature-verification call.
