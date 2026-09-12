-- Persist gateway identifiers so payment confirmations can be bound to the
-- exact local order that created them. Existing orders remain valid because
-- all fields are nullable.
ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS payment_provider TEXT,
  ADD COLUMN IF NOT EXISTS payment_provider_order_id TEXT,
  ADD COLUMN IF NOT EXISTS payment_id TEXT,
  ADD COLUMN IF NOT EXISTS payment_status TEXT,
  ADD COLUMN IF NOT EXISTS payment_verified_at TIMESTAMP WITH TIME ZONE;

-- A provider order and a captured payment must never be attached to two local
-- orders. Partial indexes preserve compatibility with historic PhonePe orders.
CREATE UNIQUE INDEX IF NOT EXISTS orders_payment_provider_order_id_key
  ON public.orders (payment_provider, payment_provider_order_id)
  WHERE payment_provider_order_id IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS orders_payment_id_key
  ON public.orders (payment_id)
  WHERE payment_id IS NOT NULL;
