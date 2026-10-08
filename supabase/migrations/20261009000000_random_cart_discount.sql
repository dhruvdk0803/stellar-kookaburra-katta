-- Random cart discount (2026-10-09) - replaces the tiered cart discount.
--
-- Business rule (owner's decision): the automatic discount is a RANDOM
-- percentage between discount_settings.min_percent and max_percent (max 5%),
-- e.g. 2.37%, applied to the WHOLE cart subtotal. There is no minimum order and
-- there are no tiers. Shipping is free.
--
-- How it works: get_cart_discount_percent(items) derives the percent from a
-- server-held secret and the canonical cart (product ids + quantities), so
--   * it CHANGES whenever the cart changes (product added/removed, quantity or
--     variant changed), and
--   * it is STABLE for an identical cart (same items + quantities, in any line
--     order) so refreshing the page never re-rolls it.
-- The browser can never choose it: the order edge functions call this same
-- function with the service role and price the order with the result.
-- Guests may call it too (anon) so the cart can show the percent before login.
--
-- The old discount_tiers table is left in place but is no longer used.
-- orders.discount_percent / discount_amount are unchanged.
--
-- Run this BEFORE deploying the updated razorpay-create-order and
-- place-upi-order edge functions. Safe to run more than once.

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Settings (admin editable, single row)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.discount_settings (
  id integer PRIMARY KEY DEFAULT 1
    CONSTRAINT discount_settings_single_row CHECK (id = 1),
  enabled boolean NOT NULL DEFAULT true,
  min_percent numeric(4, 2) NOT NULL DEFAULT 0.50,
  max_percent numeric(4, 2) NOT NULL DEFAULT 5.00,
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT discount_settings_percent_range
    CHECK (min_percent >= 0 AND min_percent <= max_percent AND max_percent <= 5)
);

COMMENT ON TABLE public.discount_settings IS
  'Single-row settings for the random cart discount: a percent in [min_percent, max_percent] (max 5) derived per cart by get_cart_discount_percent().';

CREATE OR REPLACE FUNCTION public.touch_discount_settings_updated_at()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS discount_settings_touch_updated_at ON public.discount_settings;
CREATE TRIGGER discount_settings_touch_updated_at
  BEFORE UPDATE ON public.discount_settings
  FOR EACH ROW EXECUTE FUNCTION public.touch_discount_settings_updated_at();

ALTER TABLE public.discount_settings ENABLE ROW LEVEL SECURITY;

-- Admins read and update the row (no INSERT/DELETE for clients). Everyone else,
-- guests included, learns the percent only through get_cart_discount_percent().
REVOKE ALL ON public.discount_settings FROM PUBLIC, anon, authenticated;
GRANT SELECT ON public.discount_settings TO authenticated;
GRANT UPDATE (enabled, min_percent, max_percent) ON public.discount_settings TO authenticated;
GRANT ALL ON public.discount_settings TO service_role;

DROP POLICY IF EXISTS "Admins read discount settings" ON public.discount_settings;
CREATE POLICY "Admins read discount settings" ON public.discount_settings
  FOR SELECT TO authenticated
  USING ((SELECT public.is_admin()));

DROP POLICY IF EXISTS "Admins update discount settings" ON public.discount_settings;
CREATE POLICY "Admins update discount settings" ON public.discount_settings
  FOR UPDATE TO authenticated
  USING ((SELECT public.is_admin()))
  WITH CHECK ((SELECT public.is_admin()));

INSERT INTO public.discount_settings (id, enabled, min_percent, max_percent)
VALUES (1, true, 0.50, 5.00)
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 2. Secret (never readable by any API role)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.discount_secret (
  id integer PRIMARY KEY DEFAULT 1
    CONSTRAINT discount_secret_single_row CHECK (id = 1),
  secret text NOT NULL
    DEFAULT replace(gen_random_uuid()::text || gen_random_uuid()::text, '-', '')
);

COMMENT ON TABLE public.discount_secret IS
  'Server-held secret mixed into the random cart discount. RLS on, no policies, no grants: only get_cart_discount_percent() (SECURITY DEFINER) reads it. To re-roll every cart: UPDATE public.discount_secret SET secret = ... in the SQL editor.';

ALTER TABLE public.discount_secret ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.discount_secret FROM PUBLIC, anon, authenticated, service_role;

INSERT INTO public.discount_secret (id) VALUES (1) ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 3. get_cart_discount_percent(p_items jsonb) -> numeric
-- ---------------------------------------------------------------------------
-- p_items: JSON array of {product_id: text, quantity: int}. product_id may end
-- in ":v<n>" (variant). Returns 0 when the discount is disabled, the input is
-- not a non-empty array of at most 50 elements, or no line is valid. Malformed
-- lines (non-object, quantity not a whole number 1..100, bad product_id) are
-- ignored. Canonical cart = lower-cased ids (variant index without leading
-- zeros), quantities of duplicate ids summed, sorted by id, joined as
-- 'id:qty,id:qty'. percent = round(min + f * (max - min), 2) where
-- f = first 8 hex chars of md5(secret || '|' || canonical) / 2^32.
CREATE OR REPLACE FUNCTION public.get_cart_discount_percent(p_items jsonb)
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
  v_canonical text;
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

  SELECT string_agg(t.pid || ':' || t.qty::text, ',' ORDER BY t.pid COLLATE "C")
    INTO v_canonical
    FROM (
      SELECT regexp_replace(lower(e.value ->> 'product_id'), ':v0*([0-9]+)$', ':v\1') AS pid,
             sum((e.value ->> 'quantity')::integer) AS qty
        FROM jsonb_array_elements(p_items) AS e(value)
       WHERE jsonb_typeof(e.value) = 'object'
         AND jsonb_typeof(e.value -> 'product_id') = 'string'
         AND jsonb_typeof(e.value -> 'quantity') = 'number'
         AND (e.value ->> 'quantity') ~ '^[0-9]{1,3}$'
         AND CASE WHEN (e.value ->> 'quantity') ~ '^[0-9]{1,3}$'
                  THEN (e.value ->> 'quantity')::integer BETWEEN 1 AND 100
                  ELSE false END
         AND lower(e.value ->> 'product_id')
             ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}(:v[0-9]+)?$'
       GROUP BY 1
    ) AS t;
  IF v_canonical IS NULL THEN
    RETURN 0;
  END IF;

  SELECT d.secret INTO v_secret FROM public.discount_secret d WHERE d.id = 1;
  IF v_secret IS NULL THEN
    RETURN 0;
  END IF;

  v_hash := ('x' || substr(md5(v_secret || '|' || v_canonical), 1, 8))::bit(32)::bigint;
  RETURN round(v_min + (v_hash / 4294967296.0) * (v_max - v_min), 2);
END;
$$;

REVOKE ALL ON FUNCTION public.get_cart_discount_percent(jsonb) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_cart_discount_percent(jsonb) TO anon, authenticated, service_role;

COMMENT ON FUNCTION public.get_cart_discount_percent(jsonb) IS
  'Deterministic pseudo-random cart discount percent in [min_percent, max_percent] from a server secret and the canonical cart; 0 when disabled or the cart is empty/invalid.';

COMMIT;
