-- Keep payment and privilege decisions in the database. The browser may read
-- its own orders, but only the payment functions (service role) create them.
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = (SELECT auth.uid()) AND role = 'admin'
  );
$$;

REVOKE UPDATE ON public.profiles FROM PUBLIC, anon, authenticated;
GRANT UPDATE (name, phone) ON public.profiles TO authenticated;

DROP POLICY IF EXISTS "Admins can view profiles" ON public.profiles;
CREATE POLICY "Admins can view profiles" ON public.profiles
  FOR SELECT TO authenticated USING (public.is_admin());

DROP POLICY IF EXISTS "Users insert own orders" ON public.orders;
DROP POLICY IF EXISTS "Users insert own order items" ON public.order_items;
REVOKE INSERT, DELETE, UPDATE ON public.orders FROM PUBLIC, anon, authenticated;
REVOKE INSERT, DELETE, UPDATE ON public.order_items FROM PUBLIC, anon, authenticated;
-- Admin staff can change fulfilment status, but cannot forge payment fields,
-- prices, customer IDs, or order items through the public API.
GRANT UPDATE (status) ON public.orders TO authenticated;

ALTER TABLE public.orders DROP CONSTRAINT IF EXISTS orders_status_check;
ALTER TABLE public.orders ADD CONSTRAINT orders_status_check
  CHECK (status IN ('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled'));

CREATE OR REPLACE FUNCTION public.guard_order_fulfilment()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  IF OLD.payment_id IS NOT NULL AND NEW.status = 'pending' THEN
    RAISE EXCEPTION 'A paid order cannot return to pending.' USING ERRCODE = '23514';
  END IF;
  IF OLD.status = 'cancelled' AND NEW.status IS DISTINCT FROM OLD.status THEN
    RAISE EXCEPTION 'A cancelled order cannot be reopened.' USING ERRCODE = '23514';
  END IF;
  IF auth.role() IS DISTINCT FROM 'service_role'
    AND OLD.payment_provider = 'razorpay' AND NEW.status = 'cancelled' THEN
    RAISE EXCEPTION 'Razorpay orders require payment or refund reconciliation before cancellation.'
      USING ERRCODE = '23514';
  END IF;
  IF NEW.status IN ('confirmed', 'processing', 'shipped', 'delivered')
    AND OLD.payment_provider = 'razorpay'
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

-- images[1] is the catalog's primary photo. Keep the legacy image_url column
-- aligned for older catalog views and order snapshots.
CREATE OR REPLACE FUNCTION public.sync_product_primary_image()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.images IS DISTINCT FROM OLD.images THEN
      NEW.image_url := NEW.images[1];
      RETURN NEW;
    END IF;
  END IF;
  IF coalesce(array_length(NEW.images, 1), 0) > 0 THEN
    NEW.image_url := NEW.images[1];
  ELSIF NEW.image_url IS NOT NULL AND btrim(NEW.image_url) <> '' THEN
    NEW.images := ARRAY[NEW.image_url];
  ELSE
    NEW.image_url := NULL;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS products_sync_primary_image ON public.products;
CREATE TRIGGER products_sync_primary_image
  BEFORE INSERT OR UPDATE OF images, image_url ON public.products
  FOR EACH ROW EXECUTE FUNCTION public.sync_product_primary_image();

-- Historical rows can be audited separately; these checks still reject bad
-- values on all new inserts and edits immediately.
ALTER TABLE public.products ADD CONSTRAINT products_price_positive
  CHECK (price > 0) NOT VALID;
ALTER TABLE public.products ADD CONSTRAINT products_stock_nonnegative
  CHECK (stock >= 0) NOT VALID;
ALTER TABLE public.order_items ADD CONSTRAINT order_items_quantity_positive
  CHECK (quantity > 0) NOT VALID;
ALTER TABLE public.order_items ADD CONSTRAINT order_items_price_nonnegative
  CHECK (price >= 0) NOT VALID;
ALTER TABLE public.orders ADD CONSTRAINT orders_total_positive
  CHECK (total_amount > 0) NOT VALID;

-- The bucket enforces the same limits as the admin form, including requests
-- sent directly to Storage rather than through the site.
UPDATE storage.buckets
SET file_size_limit = 10485760,
    allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/avif', 'image/gif']::text[]
WHERE id = 'product-images';
