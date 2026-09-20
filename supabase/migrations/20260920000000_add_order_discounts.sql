-- Record the surprise cart discount used to calculate the paid order total.
ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS discount_percent NUMERIC(5, 2) NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS discount_amount NUMERIC(12, 2) NOT NULL DEFAULT 0;

ALTER TABLE public.orders
  DROP CONSTRAINT IF EXISTS orders_discount_percent_range,
  DROP CONSTRAINT IF EXISTS orders_discount_amount_nonnegative;

ALTER TABLE public.orders
  ADD CONSTRAINT orders_discount_percent_range
    CHECK (discount_percent >= 0 AND discount_percent <= 5),
  ADD CONSTRAINT orders_discount_amount_nonnegative
    CHECK (discount_amount >= 0);
