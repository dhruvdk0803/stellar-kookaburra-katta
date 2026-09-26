-- A successful payment and its inventory debit must be one database action.
-- If availability changed after checkout, keep the paid order visible and
-- flag it for staff instead of hiding the payment or allowing negative stock.
ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS inventory_issue boolean NOT NULL DEFAULT false;

CREATE OR REPLACE FUNCTION public.confirm_razorpay_payment(
  p_order_id uuid,
  p_provider_order_id text,
  p_payment_id text
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  target_order public.orders%ROWTYPE;
  needed record;
  available integer;
  shortfall boolean := false;
BEGIN
  IF auth.role() IS DISTINCT FROM 'service_role' THEN
    RAISE EXCEPTION 'Payment confirmation is server only.' USING ERRCODE = '42501';
  END IF;

  SELECT * INTO target_order FROM public.orders
  WHERE id = p_order_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Order not found.' USING ERRCODE = 'P0002';
  END IF;
  IF target_order.payment_provider IS DISTINCT FROM 'razorpay'
    OR target_order.payment_provider_order_id IS DISTINCT FROM p_provider_order_id THEN
    RAISE EXCEPTION 'Payment order mismatch.' USING ERRCODE = '23514';
  END IF;
  IF target_order.payment_id IS NOT NULL THEN
    IF target_order.payment_id IS DISTINCT FROM p_payment_id THEN
      RAISE EXCEPTION 'Order already has another payment.' USING ERRCODE = '23505';
    END IF;
    RETURN jsonb_build_object('confirmed', true, 'inventory_issue', target_order.inventory_issue);
  END IF;
  IF target_order.status IS DISTINCT FROM 'pending' THEN
    RAISE EXCEPTION 'Order is not payable.' USING ERRCODE = '23514';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.order_items WHERE order_id = p_order_id) THEN
    RAISE EXCEPTION 'Order has no items.' USING ERRCODE = '23514';
  END IF;

  -- Product locks are acquired in stable order across concurrent payments.
  FOR needed IN
    SELECT product_id, sum(quantity)::integer AS quantity
    FROM public.order_items
    WHERE order_id = p_order_id
    GROUP BY product_id
    ORDER BY product_id NULLS LAST
  LOOP
    IF needed.product_id IS NULL THEN
      shortfall := true;
      CONTINUE;
    END IF;
    SELECT stock INTO available FROM public.products
    WHERE id = needed.product_id FOR UPDATE;
    IF NOT FOUND OR coalesce(available, 0) < needed.quantity THEN
      shortfall := true;
    END IF;
  END LOOP;

  IF NOT shortfall THEN
    UPDATE public.products AS product
    SET stock = product.stock - required.quantity
    FROM (
      SELECT product_id, sum(quantity)::integer AS quantity
      FROM public.order_items
      WHERE order_id = p_order_id
      GROUP BY product_id
    ) AS required
    WHERE product.id = required.product_id;
  END IF;

  UPDATE public.orders
  SET status = 'confirmed',
      payment_id = p_payment_id,
      payment_status = 'captured',
      payment_verified_at = now(),
      inventory_issue = shortfall
  WHERE id = p_order_id;

  RETURN jsonb_build_object('confirmed', true, 'inventory_issue', shortfall);
END;
$$;

REVOKE ALL ON FUNCTION public.confirm_razorpay_payment(uuid, text, text)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.confirm_razorpay_payment(uuid, text, text)
  TO service_role;
