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
2. Run `bash scripts/setup-razorpay.sh` in a reviewed environment. It applies
   all pending Supabase migrations, sets Supabase secrets, deploys the Razorpay functions, and
   removes the legacy PhonePe functions and secrets.
3. In Razorpay Dashboard, enable automatic payment capture. Add the webhook URL
   printed by the script, use the same webhook secret, and subscribe to
   `payment.captured` and `order.paid`.
4. Make a test-mode payment before swapping to live Razorpay keys.

The webhook is a recovery path if a customer closes the page before the browser
can complete the normal signature-verification call.

## Backend release checks

Apply database migrations before deploying the three Razorpay Edge Functions,
then deploy the storefront. The 2026-09-26 migrations restrict profile and
order writes, align product primary images, and make payment confirmation and
stock updates one database operation. Both payment functions require the new
`confirm_razorpay_payment` database function.

In a staging project, check these flows with test-mode Razorpay keys before a
live release:

- Review existing `profiles` rows with `role = 'admin'` and confirm each owner;
  the new rule prevents future self-promotion but cannot identify past edits.
- Edit a product's gallery and option images in Admin, save, then open it from
  search and from its direct product URL.
- Try to change a customer profile's `role` and to insert an order with a
  browser session; both writes must be denied.
- Pay for an in-stock product and confirm the order appears once, its payment
  ID is stored, and stock decreases once even if verification and webhook both run.
- Reduce stock between checkout and payment capture; the paid order must show
  `inventory_issue` to staff and the customer, without taking stock negative.
- Test an abandoned checkout and an invalid webhook signature. Neither may
  mark an order as paid.
