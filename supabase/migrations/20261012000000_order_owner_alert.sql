-- Owner WhatsApp alert for new orders (2026-10-12).
--
-- orders.owner_notified_at is set by the order edge functions (service role)
-- when the owner's WhatsApp alert is sent, so each order is announced once even
-- when razorpay-verify and razorpay-webhook confirm the same payment. NULL means
-- "not alerted yet" (also for every order placed before this feature).
-- Safe to run more than once.

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS owner_notified_at timestamptz;

COMMENT ON COLUMN public.orders.owner_notified_at IS
  'When the owner WhatsApp alert for this order was sent (edge functions, service role). NULL = not alerted.';
