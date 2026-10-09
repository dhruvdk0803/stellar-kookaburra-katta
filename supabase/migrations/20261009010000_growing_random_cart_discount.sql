-- Growing random cart discount (2026-10-09) - replaces the per-cart hash from
-- 20261009000000_random_cart_discount.sql (settings + secret tables are reused).
--
-- Business rule (owner's decision, 2026-10-09):
--   * Every CUSTOMER gets their own random discount curve (guests share one
--     "guest" curve; after login the customer's own curve applies).
--   * The discount grows with the NUMBER OF PIECES in the cart (sum of
--     quantities): adding any piece always raises it, removing one lowers it.
--     Which products they are does not matter.
--   * It starts just above discount_settings.min_percent for 1 piece and climbs
--     towards max_percent (max 5%), never past it. Near the top the increase per
--     piece becomes smaller than 0.01% and the shown value stops moving.
--
-- How it works: each piece i adds a random step in [0.5, 1.5) (from
-- md5(secret | customer | i)), so steps differ per customer and per piece but
-- are always positive -> the total only goes up as pieces are added. The total
-- is turned into a percent with a half-life curve: after `v_half_pieces` steps
-- the customer is halfway between min and max.
--
-- Who is the customer: the order edge functions call this with the service role
-- and pass p_user_id. For everyone else p_user_id is IGNORED and auth.uid() is
-- used (null -> guest), so nobody can look up another customer's curve.
--
-- Run this BEFORE deploying the updated razorpay-create-order and
-- place-upi-order edge functions. Safe to run more than once.

BEGIN;

DROP FUNCTION IF EXISTS public.get_cart_discount_percent(jsonb);

CREATE OR REPLACE FUNCTION public.get_cart_discount_percent(
  p_items jsonb,
  p_user_id uuid DEFAULT NULL
)
RETURNS numeric
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_enabled boolean;
  v_min numeric;
  v_max numeric;
  v_secret text;
  v_customer text;
  v_pieces integer;
  v_curve numeric;        -- this customer's random number in [0, 1)
  v_half_pieces numeric;  -- steps needed to reach halfway between min and max
  v_steps numeric := 0;
  v_hash bigint;
BEGIN
  SELECT s.enabled, s.min_percent, s.max_percent
    INTO v_enabled, v_min, v_max
    FROM public.discount_settings s
   WHERE s.id = 1;
  IF NOT FOUND OR NOT v_enabled THEN
    RETURN 0;
  END IF;

  IF p_items IS NULL
     OR jsonb_typeof(p_items) <> 'array'
     OR jsonb_array_length(p_items) = 0
     OR jsonb_array_length(p_items) > 50 THEN
    RETURN 0;
  END IF;

  -- Number of pieces = sum of quantities over valid lines (same validation as before).
  SELECT sum((e.value ->> 'quantity')::integer)
    INTO v_pieces
    FROM jsonb_array_elements(p_items) AS e(value)
   WHERE jsonb_typeof(e.value) = 'object'
     AND jsonb_typeof(e.value -> 'product_id') = 'string'
     AND jsonb_typeof(e.value -> 'quantity') = 'number'
     AND (e.value ->> 'quantity') ~ '^[0-9]{1,3}$'
     AND CASE WHEN (e.value ->> 'quantity') ~ '^[0-9]{1,3}$'
              THEN (e.value ->> 'quantity')::integer BETWEEN 1 AND 100
              ELSE false END
     AND lower(e.value ->> 'product_id')
         ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}(:v[0-9]+)?$';
  IF v_pieces IS NULL OR v_pieces < 1 THEN
    RETURN 0;
  END IF;

  SELECT d.secret INTO v_secret FROM public.discount_secret d WHERE d.id = 1;
  IF v_secret IS NULL THEN
    RETURN 0;
  END IF;

  -- Only the service role (order edge functions) may name the customer.
  IF coalesce(auth.jwt() ->> 'role', '') = 'service_role' THEN
    v_customer := p_user_id::text;
  ELSE
    v_customer := auth.uid()::text;
  END IF;
  v_customer := coalesce(v_customer, 'guest');

  v_hash := ('x' || substr(md5(v_secret || '|curve|' || v_customer), 1, 8))::bit(32)::bigint;
  v_curve := v_hash / 4294967296.0;

  -- How fast THIS customer's discount climbs: halfway to max after 3 to 10 pieces (owner's choice).
  v_half_pieces := 3 + v_curve * 7;

  -- Past 300 pieces every customer is already at the top of their curve.
  FOR i IN 1 .. least(v_pieces, 300) LOOP
    v_hash := ('x' || substr(md5(v_secret || '|' || v_customer || '|' || i), 1, 8))::bit(32)::bigint;
    v_steps := v_steps + 0.5 + v_hash / 4294967296.0;
  END LOOP;

  RETURN round(v_min + (v_max - v_min) * (1 - power(2::numeric, -v_steps / v_half_pieces)), 2);
END;
$$;

REVOKE ALL ON FUNCTION public.get_cart_discount_percent(jsonb, uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_cart_discount_percent(jsonb, uuid) TO anon, authenticated, service_role;

COMMENT ON FUNCTION public.get_cart_discount_percent(jsonb, uuid) IS
  'Per-customer random cart discount in [min_percent, max_percent] that rises with every piece added (sum of quantities). p_user_id is honoured only for service_role; others get their own curve (auth.uid(), or guest).';

COMMIT;
