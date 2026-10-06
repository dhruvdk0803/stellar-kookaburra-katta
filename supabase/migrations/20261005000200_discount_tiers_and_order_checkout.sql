-- Cart-value discount tiers, richer order records and UPI on Delivery (2026-10-05).
--
-- 1. discount_tiers: the progressive cart discount, read by the storefront and
--    applied by the order edge functions (the server is the source of truth).
--    The HIGHEST active tier whose min_subtotal <= cart subtotal applies its
--    percent to the WHOLE subtotal (never marginal/stacked). Shipping is not
--    discounted. Everyone may read active tiers; only admins may change them.
-- 2. orders gains subtotal/shipping amounts, payment_method, the customer's
--    contact phone and an optional delivery map pin. All new columns are
--    nullable (or defaulted), so existing orders keep working unchanged.
--    The existing discount_percent/discount_amount columns are reused; their
--    range check is relaxed from 0..5 to 0..50 to match discount_tiers.
-- 3. UPI on Delivery (replaces Cash on Delivery): payment_method/provider
--    'upi_on_delivery'. Such an order is placed ONLY through
--    place_upi_on_delivery_order() (service role, called by the place-upi-order
--    edge function). Because no online payment confirms it, its stock is
--    reserved atomically at placement, and released again if it is cancelled.
--    It may move pending -> confirmed -> processing -> shipped -> delivered
--    without a gateway capture; Razorpay orders still require a captured
--    payment before fulfilment and stock is still debited on payment
--    confirmation (confirm_razorpay_payment, unchanged).
--
-- Run this BEFORE deploying the updated razorpay-create-order and the new
-- place-upi-order edge functions (they write the new columns). Safe to run
-- more than once.

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Discount tiers
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.discount_tiers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  min_subtotal numeric(12, 2) NOT NULL
    CONSTRAINT discount_tiers_min_subtotal_positive CHECK (min_subtotal > 0)
    CONSTRAINT discount_tiers_min_subtotal_key UNIQUE,
  discount_percent numeric(5, 2) NOT NULL
    CONSTRAINT discount_tiers_discount_percent_range
      CHECK (discount_percent > 0 AND discount_percent <= 50),
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.discount_tiers IS
  'Cart-value discount: the highest active tier with min_subtotal <= cart subtotal applies discount_percent to the whole subtotal (excl. shipping).';

CREATE OR REPLACE FUNCTION public.touch_discount_tier_updated_at()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS discount_tiers_touch_updated_at ON public.discount_tiers;
CREATE TRIGGER discount_tiers_touch_updated_at
  BEFORE UPDATE ON public.discount_tiers
  FOR EACH ROW EXECUTE FUNCTION public.touch_discount_tier_updated_at();

ALTER TABLE public.discount_tiers ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public.discount_tiers FROM PUBLIC, anon, authenticated;
GRANT SELECT ON public.discount_tiers TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.discount_tiers TO authenticated;
GRANT ALL ON public.discount_tiers TO service_role;

DROP POLICY IF EXISTS "Read active discount tiers" ON public.discount_tiers;
CREATE POLICY "Read active discount tiers" ON public.discount_tiers
  FOR SELECT TO anon, authenticated
  USING (is_active OR (SELECT public.is_admin()));

DROP POLICY IF EXISTS "Admins insert discount tiers" ON public.discount_tiers;
CREATE POLICY "Admins insert discount tiers" ON public.discount_tiers
  FOR INSERT TO authenticated
  WITH CHECK ((SELECT public.is_admin()));

DROP POLICY IF EXISTS "Admins update discount tiers" ON public.discount_tiers;
CREATE POLICY "Admins update discount tiers" ON public.discount_tiers
  FOR UPDATE TO authenticated
  USING ((SELECT public.is_admin()))
  WITH CHECK ((SELECT public.is_admin()));

DROP POLICY IF EXISTS "Admins delete discount tiers" ON public.discount_tiers;
CREATE POLICY "Admins delete discount tiers" ON public.discount_tiers
  FOR DELETE TO authenticated
  USING ((SELECT public.is_admin()));

-- Starting tiers. Existing thresholds are never overwritten on a re-run, so
-- edits made later in Admin survive.
INSERT INTO public.discount_tiers (min_subtotal, discount_percent, is_active) VALUES
  (2000, 1.0, true),   -- ₹2,000+ : 1%   (confirmed by the client)
  (3000, 1.4, true),   -- ₹3,000+ : 1.4% (confirmed by the client)
  -- !!! NOT CONFIRMED BY THE CLIENT !!! The ₹4,000 -> 1.7% tier is a
  -- placeholder, so it is seeded INACTIVE and gives no discount until the owner
  -- switches it on (Admin > Discounts) or changes the amount/percent there.
  (4000, 1.7, false)
ON CONFLICT (min_subtotal) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 2. Order columns
-- ---------------------------------------------------------------------------
ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS subtotal_amount numeric(12, 2),
  ADD COLUMN IF NOT EXISTS shipping_amount numeric(12, 2),
  ADD COLUMN IF NOT EXISTS payment_method text,
  ADD COLUMN IF NOT EXISTS contact_phone text,
  ADD COLUMN IF NOT EXISTS delivery_latitude double precision,
  ADD COLUMN IF NOT EXISTS delivery_longitude double precision,
  ADD COLUMN IF NOT EXISTS delivery_location_label text,
  ADD COLUMN IF NOT EXISTS stock_reserved boolean NOT NULL DEFAULT false;

COMMENT ON COLUMN public.orders.subtotal_amount IS 'Sum of item price x quantity before discount and shipping (NULL on orders placed before 2026-10-05).';
COMMENT ON COLUMN public.orders.shipping_amount IS 'Flat shipping charged on the order (NULL on orders placed before 2026-10-05).';
COMMENT ON COLUMN public.orders.payment_method IS 'razorpay (paid online) or upi_on_delivery (paid by UPI at handover). NULL on legacy orders.';
COMMENT ON COLUMN public.orders.contact_phone IS '10-digit phone the customer entered at checkout.';
COMMENT ON COLUMN public.orders.stock_reserved IS 'True while this order holds stock taken at placement (UPI on Delivery); cancelling releases it.';

-- Existing Razorpay orders were all paid (or attempted) online.
UPDATE public.orders
SET payment_method = 'razorpay'
WHERE payment_method IS NULL
  AND payment_provider = 'razorpay';

ALTER TABLE public.orders
  DROP CONSTRAINT IF EXISTS orders_discount_percent_range,
  DROP CONSTRAINT IF EXISTS orders_payment_method_check,
  DROP CONSTRAINT IF EXISTS orders_subtotal_amount_nonnegative,
  DROP CONSTRAINT IF EXISTS orders_shipping_amount_nonnegative,
  DROP CONSTRAINT IF EXISTS orders_contact_phone_format,
  DROP CONSTRAINT IF EXISTS orders_delivery_latitude_range,
  DROP CONSTRAINT IF EXISTS orders_delivery_longitude_range,
  DROP CONSTRAINT IF EXISTS orders_delivery_coordinates_pair,
  DROP CONSTRAINT IF EXISTS orders_delivery_location_label_length;

ALTER TABLE public.orders
  ADD CONSTRAINT orders_discount_percent_range
    CHECK (discount_percent >= 0 AND discount_percent <= 50),
  ADD CONSTRAINT orders_payment_method_check
    CHECK (payment_method IS NULL OR payment_method IN ('razorpay', 'upi_on_delivery')),
  ADD CONSTRAINT orders_subtotal_amount_nonnegative
    CHECK (subtotal_amount IS NULL OR subtotal_amount >= 0),
  ADD CONSTRAINT orders_shipping_amount_nonnegative
    CHECK (shipping_amount IS NULL OR shipping_amount >= 0),
  ADD CONSTRAINT orders_contact_phone_format
    CHECK (contact_phone IS NULL OR contact_phone ~ '^[0-9]{10}$'),
  ADD CONSTRAINT orders_delivery_latitude_range
    CHECK (delivery_latitude IS NULL OR delivery_latitude BETWEEN -90 AND 90),
  ADD CONSTRAINT orders_delivery_longitude_range
    CHECK (delivery_longitude IS NULL OR delivery_longitude BETWEEN -180 AND 180),
  ADD CONSTRAINT orders_delivery_coordinates_pair
    CHECK ((delivery_latitude IS NULL) = (delivery_longitude IS NULL)),
  ADD CONSTRAINT orders_delivery_location_label_length
    CHECK (delivery_location_label IS NULL OR char_length(delivery_location_label) <= 500);

-- ---------------------------------------------------------------------------
-- 3. Fulfilment rules
-- ---------------------------------------------------------------------------
-- Same rules as 20260926000000, with the Razorpay checks also keyed on
-- payment_method. Orders of any other method (UPI on Delivery, legacy PhonePe)
-- can be fulfilled without a gateway capture.
CREATE OR REPLACE FUNCTION public.guard_order_fulfilment()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE
  paid_online boolean := OLD.payment_provider IS NOT DISTINCT FROM 'razorpay'
    OR OLD.payment_method IS NOT DISTINCT FROM 'razorpay';
BEGIN
  IF OLD.payment_id IS NOT NULL AND NEW.status = 'pending' THEN
    RAISE EXCEPTION 'A paid order cannot return to pending.' USING ERRCODE = '23514';
  END IF;
  IF OLD.status = 'cancelled' AND NEW.status IS DISTINCT FROM OLD.status THEN
    RAISE EXCEPTION 'A cancelled order cannot be reopened.' USING ERRCODE = '23514';
  END IF;
  IF auth.role() IS DISTINCT FROM 'service_role'
    AND paid_online AND NEW.status = 'cancelled' THEN
    RAISE EXCEPTION 'Razorpay orders require payment or refund reconciliation before cancellation.'
      USING ERRCODE = '23514';
  END IF;
  IF NEW.status IN ('confirmed', 'processing', 'shipped', 'delivered')
    AND paid_online
    AND NEW.payment_status IS DISTINCT FROM 'captured' THEN
    RAISE EXCEPTION 'A Razorpay order cannot be fulfilled before payment capture.'
      USING ERRCODE = '23514';
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS orders_guard_fulfilment ON public.orders;
CREATE TRIGGER orders_guard_fulfilment
  BEFORE UPDATE OF status ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.guard_order_fulfilment();

-- Cancelling an order that holds reserved stock (UPI on Delivery) puts that
-- stock back exactly once. Runs after orders_guard_fulfilment (triggers fire
-- in name order), so a rejected status change never touches stock. A
-- cancelled order can never be reopened, so released stock is never re-used
-- by the same order.
CREATE OR REPLACE FUNCTION public.release_reserved_order_stock()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  released record;
BEGIN
  -- Lock products in the same order as placement and payment confirmation.
  FOR released IN
    SELECT product_id, sum(quantity)::integer AS quantity
    FROM public.order_items
    WHERE order_id = NEW.id AND product_id IS NOT NULL
    GROUP BY product_id
    ORDER BY product_id
  LOOP
    UPDATE public.products
    SET stock = coalesce(stock, 0) + released.quantity
    WHERE id = released.product_id;
  END LOOP;
  NEW.stock_reserved := false;
  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public.release_reserved_order_stock() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS orders_release_reserved_stock ON public.orders;
CREATE TRIGGER orders_release_reserved_stock
  BEFORE UPDATE OF status ON public.orders
  FOR EACH ROW
  WHEN (NEW.status = 'cancelled' AND OLD.status IS DISTINCT FROM 'cancelled' AND OLD.stock_reserved)
  EXECUTE FUNCTION public.release_reserved_order_stock();

-- ---------------------------------------------------------------------------
-- 4. UPI on Delivery placement (server only)
-- ---------------------------------------------------------------------------
-- The edge function prices the cart from the database; this function makes
-- placement atomic: it locks the products, rejects sold-out or hidden items
-- (SQLSTATE PT409 -> HTTP 409), inserts the order and its items, and reserves
-- the stock. Unlike a Razorpay payment (money already taken, so a shortfall is
-- only flagged), nothing has been paid yet, so a shortfall rejects the order.
CREATE OR REPLACE FUNCTION public.place_upi_on_delivery_order(
  p_user_id uuid,
  p_address text,
  p_contact_phone text,
  p_items jsonb,
  p_subtotal_amount numeric,
  p_discount_percent numeric,
  p_discount_amount numeric,
  p_shipping_amount numeric,
  p_total_amount numeric,
  p_delivery_latitude double precision DEFAULT NULL,
  p_delivery_longitude double precision DEFAULT NULL,
  p_delivery_location_label text DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  new_order_id uuid;
  needed record;
  available integer;
  product_active boolean;
  items_subtotal numeric;
BEGIN
  IF auth.role() IS DISTINCT FROM 'service_role' THEN
    RAISE EXCEPTION 'Order placement is server only.' USING ERRCODE = '42501';
  END IF;
  IF p_user_id IS NULL OR p_address IS NULL OR btrim(p_address) = '' THEN
    RAISE EXCEPTION 'Order is missing the customer or address.' USING ERRCODE = '22023';
  END IF;

  -- Unpaid UPI orders hold stock until an admin confirms or cancels them, so cap
  -- how many one customer can leave waiting at the same time.
  IF (SELECT count(*) FROM public.orders AS open_order
      WHERE open_order.user_id = p_user_id
        AND open_order.stock_reserved
        AND open_order.status = 'pending') >= 3 THEN
    RAISE EXCEPTION 'You already have 3 UPI on Delivery orders waiting for confirmation. Please wait for them to be confirmed, or contact us.'
      USING ERRCODE = 'PT409';
  END IF;
  IF jsonb_typeof(p_items) IS DISTINCT FROM 'array' OR jsonb_array_length(p_items) = 0 THEN
    RAISE EXCEPTION 'Order has no items.' USING ERRCODE = '22023';
  END IF;
  IF EXISTS (
    SELECT 1 FROM jsonb_array_elements(p_items) AS item
    WHERE jsonb_typeof(item) IS DISTINCT FROM 'object'
      OR item->>'product_id' IS NULL
      OR (item->>'quantity')::integer < 1
      OR (item->>'price')::numeric <= 0
  ) THEN
    RAISE EXCEPTION 'Order has an invalid item.' USING ERRCODE = '22023';
  END IF;

  SELECT sum((item->>'price')::numeric * (item->>'quantity')::integer)
  INTO items_subtotal
  FROM jsonb_array_elements(p_items) AS item;
  IF items_subtotal IS DISTINCT FROM p_subtotal_amount
    OR p_discount_amount IS NULL OR p_discount_amount < 0
    OR p_shipping_amount IS NULL OR p_shipping_amount < 0
    OR p_total_amount IS DISTINCT FROM p_subtotal_amount - p_discount_amount + p_shipping_amount
    OR p_total_amount <= 0 THEN
    RAISE EXCEPTION 'Order totals do not add up.' USING ERRCODE = '22023';
  END IF;

  -- Product locks are acquired in stable order across concurrent checkouts.
  FOR needed IN
    SELECT (item->>'product_id')::uuid AS product_id,
           sum((item->>'quantity')::integer)::integer AS quantity
    FROM jsonb_array_elements(p_items) AS item
    GROUP BY 1
    ORDER BY 1
  LOOP
    SELECT product.stock, product.is_active
    INTO available, product_active
    FROM public.products AS product
    WHERE product.id = needed.product_id
    FOR NO KEY UPDATE;
    IF NOT FOUND OR product_active IS NOT TRUE THEN
      RAISE EXCEPTION 'Unavailable product: %', needed.product_id USING ERRCODE = 'PT409';
    END IF;
    IF coalesce(available, 0) < needed.quantity THEN
      RAISE EXCEPTION 'Insufficient stock for %', needed.product_id USING ERRCODE = 'PT409';
    END IF;
  END LOOP;

  INSERT INTO public.orders (
    user_id, total_amount, subtotal_amount, discount_percent, discount_amount,
    shipping_amount, address, contact_phone, status, payment_provider,
    payment_method, payment_status, delivery_latitude, delivery_longitude,
    delivery_location_label, stock_reserved
  ) VALUES (
    p_user_id, p_total_amount, p_subtotal_amount, coalesce(p_discount_percent, 0), p_discount_amount,
    p_shipping_amount, btrim(p_address), p_contact_phone, 'pending', 'upi_on_delivery',
    'upi_on_delivery', 'pending', p_delivery_latitude, p_delivery_longitude,
    nullif(btrim(p_delivery_location_label), ''), true
  )
  RETURNING id INTO new_order_id;

  INSERT INTO public.order_items (order_id, product_id, quantity, price, variant_label)
  SELECT new_order_id,
         (line.item->>'product_id')::uuid,
         (line.item->>'quantity')::integer,
         (line.item->>'price')::numeric,
         line.item->>'variant_label'
  FROM jsonb_array_elements(p_items) WITH ORDINALITY AS line(item, position)
  ORDER BY line.position;

  UPDATE public.products AS product
  SET stock = product.stock - required.quantity
  FROM (
    SELECT (item->>'product_id')::uuid AS product_id,
           sum((item->>'quantity')::integer)::integer AS quantity
    FROM jsonb_array_elements(p_items) AS item
    GROUP BY 1
  ) AS required
  WHERE product.id = required.product_id;

  RETURN new_order_id;
END;
$$;

REVOKE ALL ON FUNCTION public.place_upi_on_delivery_order(
  uuid, text, text, jsonb, numeric, numeric, numeric, numeric, numeric,
  double precision, double precision, text
) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.place_upi_on_delivery_order(
  uuid, text, text, jsonb, numeric, numeric, numeric, numeric, numeric,
  double precision, double precision, text
) TO service_role;

COMMIT;

-- Make the API pick up the new table, columns and function immediately.
NOTIFY pgrst, 'reload schema';
