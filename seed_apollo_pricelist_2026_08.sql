-- APL Apollo CPVC + uPVC price list (August 2026) — from owner-provided CSVs.
-- 4 existing products get corrected prices; 436 new products are inserted.
-- (34 CPVC items were skipped: already live with the same price.)
-- Images are in /public/images/apollo/{cpvc,upvc} — deploy with the frontend.
-- Safe to re-run: new rows are tagged with Source='apollo-pricelist-august-2026'
-- and deleted before re-insert; price updates are idempotent.

ALTER TABLE products ADD COLUMN IF NOT EXISTS variants JSONB DEFAULT '[]'::jsonb;

-- 1) Price corrections for products that already exist (matched by id).
  UPDATE products SET price = 16.5 WHERE id = 'fb979c3a-b1de-45f3-b639-f9f3915d73b3'; -- Apollo CPVC Elbow 90° 3/4" (20mm)
  UPDATE products SET price = 7 WHERE id = 'c7b76015-76dd-4106-a261-37532ee6c7ea'; -- Apollo CPVC End Cap 1/2" (15mm)
  UPDATE products SET price = 12 WHERE id = 'b93b965a-14aa-4536-9a1b-063aee89e4cc'; -- Apollo CPVC End Cap 3/4" (20mm)
  UPDATE products SET price = 19 WHERE id = '3e470df7-3125-4545-8df0-d7ab74af3089'; -- Apollo CPVC End Cap 1" (25mm)

-- 2) Insert the new products.
DO $$
DECLARE
  v_parent UUID;
  v_cpvc UUID;
  v_upvc UUID;
BEGIN
  SELECT id INTO v_parent FROM categories WHERE slug='apollo' OR lower(name)='apollo' LIMIT 1;
  IF v_parent IS NULL THEN
    INSERT INTO categories (name, slug) VALUES ('Apollo','apollo') RETURNING id INTO v_parent;
  END IF;
  SELECT id INTO v_cpvc FROM categories WHERE parent_id=v_parent AND name='CPVC Fittings & Pipes' LIMIT 1;
  IF v_cpvc IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('CPVC Fittings & Pipes', 'apollo-cpvc-fittings-pipes', v_parent) RETURNING id INTO v_cpvc;
  END IF;
  SELECT id INTO v_upvc FROM categories WHERE parent_id=v_parent AND name='SWR / uPVC Pipes & Fittings' LIMIT 1;
  IF v_upvc IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('SWR / uPVC Pipes & Fittings', 'apollo-swr-upvc-pipes-fittings', v_parent) RETURNING id INTO v_upvc;
  END IF;

  -- Remove rows from any earlier run of this script, then re-insert.
  DELETE FROM products WHERE specs->>'Source' = 'apollo-pricelist-august-2026';

  INSERT INTO products (name, description, price, image_url, images, specs, variants, category_id, stock, is_active) VALUES
  ('Apollo CPVC Pipe SDR 11 1/2" (15mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 210, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 11 1/2" (15mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 349, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 11 3/4" (20mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 295, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 11 3/4" (20mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 492, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 11 1" (25mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 466, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 11 1" (25mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 777, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 11 1-1/4" (32mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 675, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 11 1-1/4" (32mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1125, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 11 1-1/2" (40mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1013, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 11 1-1/2" (40mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1688, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 11 2" (50mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1740, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 11 2" (50mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 2899, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 13.5 1/2" (15mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 183, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 13.5 1/2" (15mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 304, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 13.5 3/4" (20mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 268, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 13.5 3/4" (20mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 447, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 13.5 1" (25mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 423, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 13.5 1" (25mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 705, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 13.5 1-1/4" (32mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 628, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 13.5 1-1/4" (32mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1047, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 13.5 1-1/2" (40mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 878, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 13.5 1-1/2" (40mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1463, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 13.5 2" (50mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1470, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SDR 13.5 2" (50mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 2449, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SCH 40 2-1/2" (65mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 2768, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SCH 40 2-1/2" (65mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 4613, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SCH 40 3" (80mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 3731, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SCH 40 3" (80mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 6218, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SCH 40 4" (100mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 5216, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SCH 40 4" (100mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 8693, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SCH 80 2-1/2" (65mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 3596, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SCH 80 2-1/2" (65mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 5993, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SCH 80 3" (80mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 4980, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SCH 80 3" (80mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 8299, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SCH 80 4" (100mm) - 3 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 7392, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Pipe SCH 80 4" (100mm) - 5 Mtr', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 12319, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Coupler 2" (50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 158, '/images/apollo/cpvc/apollo cpvc coupler.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Coupler 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 392, '/images/apollo/cpvc/apollo cpvc coupler.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Coupler 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 535, '/images/apollo/cpvc/apollo cpvc coupler.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Coupler 4" (100mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 799, '/images/apollo/cpvc/apollo cpvc coupler.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Elbow 90° 1-1/4" (32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 22, '/images/apollo/cpvc/apollo cpvc ELBOW 90°.webp', ARRAY['/images/apollo/cpvc/apollo cpvc ELBOW 90°.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Elbow 90° 1-1/2" (40mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 124, '/images/apollo/cpvc/apollo cpvc ELBOW 90°.webp', ARRAY['/images/apollo/cpvc/apollo cpvc ELBOW 90°.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Elbow 90° 2" (50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 259, '/images/apollo/cpvc/apollo cpvc ELBOW 90°.webp', ARRAY['/images/apollo/cpvc/apollo cpvc ELBOW 90°.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Elbow 90° 4" (100mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1395, '/images/apollo/cpvc/apollo cpvc ELBOW 90°.webp', ARRAY['/images/apollo/cpvc/apollo cpvc ELBOW 90°.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Tee 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 18, '/images/apollo/cpvc/apollo cpvc TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Tee 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 27, '/images/apollo/cpvc/apollo cpvc TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Tee 1-1/4" (32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 83, '/images/apollo/cpvc/apollo cpvc TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Tee 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1215, '/images/apollo/cpvc/apollo cpvc TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Tee 4" (100mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 2194, '/images/apollo/cpvc/apollo cpvc TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Elbow 45° 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 21, '/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Elbow 45° 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 34, '/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Elbow 45° 1-1/4" (32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 74, '/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Elbow 45° 1-1/2" (40mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 133, '/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Elbow 45° 2" (50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 304, '/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Elbow 45° 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 754, '/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Elbow 45° 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1182, '/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Elbow 45° 4" (100mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 2082, '/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc ELBOW 45°.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Tee 3/4" x 1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 41, '/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Tee 1" x 3/4" (25x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 58, '/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Tee 1-1/4" x 3/4" (32x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 124, '/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Tee 1-1/4" x 1" (32x25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 110, '/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Tee 1-1/2" x 3/4" (40x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 138, '/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Tee 1-1/2" x 1" (40x25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 141, '/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Tee 1-1/2" x 1-1/4" (40x32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 169, '/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Tee 2" x 1" (50x25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 293, '/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Tee 2" x 1-1/4" (50x32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 270, '/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Tee 2" x 1-1/2" (50x40mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 254, '/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc rEDUCING TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC End Cap 1-1/2" (40mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 45, '/images/apollo/cpvc/apollo cpvc END CAP.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc END CAP.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC End Cap 2" (50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 96, '/images/apollo/cpvc/apollo cpvc END CAP.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc END CAP.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC End Cap 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 282, '/images/apollo/cpvc/apollo cpvc END CAP.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc END CAP.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Plastic Threaded 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 12, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Plastic Threaded 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 21, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Plastic Threaded 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 32, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Plastic Threaded 1-1/4" (32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 48, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Plastic Threaded 1-1/2" (40mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 59, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Plastic Threaded 2" (50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 112, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Plastic Threaded 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 411, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Plastic Threaded 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 580, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Plastic Threaded 4" (100mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1103, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Plastic Threaded 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 16, '/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Plastic Threaded 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 28, '/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Plastic Threaded 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 40, '/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Plastic Threaded 1-1/4" (32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 93, '/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Plastic Threaded 1-1/2" (40mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 102, '/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Plastic Threaded 2" (50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 158, '/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Plastic Threaded 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 396, '/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Plastic Threaded 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 552, '/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Plastic Threaded 4" (100mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1080, '/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Brass Threaded 1/2"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 144, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Brass Threaded 3/4"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 162, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Brass Threaded 1"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 240, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Brass Threaded 1-1/4"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 522, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Brass Threaded 1-1/2"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 624, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor Brass Threaded 2"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1197, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Brass Threaded 1/2"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 135, '/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Brass Threaded 3/4"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 154, '/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Brass Threaded 1"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 250, '/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Brass Threaded 1-1/4"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 517, '/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Brass Threaded 1-1/2"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 593, '/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor Brass Threaded 2"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1071, '/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Tank Connector 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 50, '/images/apollo/cpvc/apollo cpvc TANK CONNECTOR.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TANK CONNECTOR.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Tank Connector 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 54, '/images/apollo/cpvc/apollo cpvc TANK CONNECTOR.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TANK CONNECTOR.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Tank Connector 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 77, '/images/apollo/cpvc/apollo cpvc TANK CONNECTOR.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TANK CONNECTOR.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Tank Connector 1-1/4" (32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 135, '/images/apollo/cpvc/apollo cpvc TANK CONNECTOR.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TANK CONNECTOR.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Tank Connector 1-1/2" (40mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 164, '/images/apollo/cpvc/apollo cpvc TANK CONNECTOR.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TANK CONNECTOR.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Tank Connector 2" (50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 259, '/images/apollo/cpvc/apollo cpvc TANK CONNECTOR.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TANK CONNECTOR.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Ball Valve 1-1/4" (32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 484, '/images/apollo/cpvc/apollo cpvc BALL VALVE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc BALL VALVE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Ball Valve 1-1/2" (40mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 765, '/images/apollo/cpvc/apollo cpvc BALL VALVE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc BALL VALVE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Ball Valve 2" (50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1328, '/images/apollo/cpvc/apollo cpvc BALL VALVE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc BALL VALVE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Ball Valve 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 5569, '/images/apollo/cpvc/apollo cpvc BALL VALVE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc BALL VALVE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Ball Valve 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 7707, '/images/apollo/cpvc/apollo cpvc BALL VALVE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc BALL VALVE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Ball Valve 4" (100mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 12657, '/images/apollo/cpvc/apollo cpvc BALL VALVE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc BALL VALVE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC End Plug Threaded 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 18, '/images/apollo/cpvc/apollo cpvc END PLUG THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc END PLUG THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Coupler 3/4" x 1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 15, '/images/apollo/cpvc/apollo cpvc coupler.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Coupler 1-1/2" x 1" (40x25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 101, '/images/apollo/cpvc/apollo cpvc coupler.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Coupler 1" x 3/4" (25x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 29, '/images/apollo/cpvc/apollo cpvc coupler.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Coupler 1-1/4" x 1" (32x25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 63, '/images/apollo/cpvc/apollo cpvc coupler.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Coupler 2" x 1-1/4" (50x32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 185, '/images/apollo/cpvc/apollo cpvc coupler.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Coupler 1-1/2" x 3/4" (40x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 102, '/images/apollo/cpvc/apollo cpvc coupler.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Coupler 2" x 1" (50x25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 169, '/images/apollo/cpvc/apollo cpvc coupler.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Coupler 1-1/4" x 3/4" (32x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 59, '/images/apollo/cpvc/apollo cpvc coupler.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Elbow 3/4" x 1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 21, '/images/apollo/cpvc/apollo cpvc REDUCING ELBOW.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING ELBOW.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Elbow 1" x 3/4" (25x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 40, '/images/apollo/cpvc/apollo cpvc REDUCING ELBOW.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING ELBOW.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Transition Bush 1/2" x 1/2"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 7, '/images/apollo/cpvc/apollo cpvc TRANSITION BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TRANSITION BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Transition Bush 3/4" x 3/4"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 9, '/images/apollo/cpvc/apollo cpvc TRANSITION BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TRANSITION BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Transition Bush 1" x 1"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 18, '/images/apollo/cpvc/apollo cpvc TRANSITION BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TRANSITION BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Transition Bush 1-1/4" x 1-1/4"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 32, '/images/apollo/cpvc/apollo cpvc TRANSITION BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TRANSITION BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Transition Bush 1-1/2" x 1-1/2"', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 45, '/images/apollo/cpvc/apollo cpvc TRANSITION BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TRANSITION BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Cross Tee 1-1/4" (32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 158, '/images/apollo/cpvc/apollo cpvc CROSS TEE.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc CROSS TEE.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Non Return Valve (NRV) 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 339, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Non Return Valve (NRV) 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 603, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Non Return Valve (NRV) 1-1/4" (32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1448, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Non Return Valve (NRV) 1-1/2" (40mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1791, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Tee Brass Threaded ½" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 93, '/images/apollo/cpvc/apollo cpvc FEMALE TEE BRASS THREADED.webp', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE TEE BRASS THREADED.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Tee Brass Threaded ¾" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 124, '/images/apollo/cpvc/apollo cpvc FEMALE TEE BRASS THREADED.webp', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE TEE BRASS THREADED.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Tee Brass Threaded 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 264, '/images/apollo/cpvc/apollo cpvc FEMALE TEE BRASS THREADED.webp', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE TEE BRASS THREADED.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Tee Brass Threaded 1¼" (32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 328, '/images/apollo/cpvc/apollo cpvc FEMALE TEE BRASS THREADED.webp', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE TEE BRASS THREADED.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush ¾" × ½" (20×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 13, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 1" × ½" (25×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 17, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 1" × ¾" (25×20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 16, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 1¼" × ¾" (32×20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 31, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 1¼" × 1" (32×25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 25, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 1½" × ¾" (40×20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 41, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 1½" × 1" (40×25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 40, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 1½" × 1¼" (40×32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 34, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 2" × 1¼" (50×32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 85, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 2" × 1½" (50×40mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 77, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 2" × 1" (50×25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 79, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 2½" × 2" (65×50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 254, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 3" × 2½" (80×65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 400, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 3" × 2" (80×50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 456, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 4" × 3" (100×80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 648, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 4" × 2½" (100×65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 760, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Bush 4" × 2" (100×50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 777, '/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc REDUCING BUSH.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Tank Connector-Pipe-Fitment ¾" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 57, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Tank Connector-Pipe-Fitment 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 79, '/images/apollo/cpvc/apollo cpvc TANK CONNECTOR-PIPE-FITMENT.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc TANK CONNECTOR-PIPE-FITMENT.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Concealed Valve Swept ¾" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1512, '/images/apollo/cpvc/apollo cpvc CONCEALED VALVE SWEPT.webp', ARRAY['/images/apollo/cpvc/apollo cpvc CONCEALED VALVE SWEPT.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Concealed Valve Swept 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1764, '/images/apollo/cpvc/apollo cpvc CONCEALED VALVE SWEPT.webp', ARRAY['/images/apollo/cpvc/apollo cpvc CONCEALED VALVE SWEPT.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Concealed Valve Swept ¾" × ½" (20×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 825, '/images/apollo/cpvc/apollo cpvc CONCEALED VALVE SWEPT.webp', ARRAY['/images/apollo/cpvc/apollo cpvc CONCEALED VALVE SWEPT.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Mixer Adaptor ¾" × ½" (20×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 338, '/images/apollo/cpvc/apollo cpvc MIXER ADAPTOR.webp', ARRAY['/images/apollo/cpvc/apollo cpvc MIXER ADAPTOR.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Mixer Adaptor 1" × ½" (25×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 507, '/images/apollo/cpvc/apollo cpvc MIXER ADAPTOR.webp', ARRAY['/images/apollo/cpvc/apollo cpvc MIXER ADAPTOR.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor With Hexagonal Brass Inserts 1" × 1" (25×25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 383, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor With Hexagonal Brass Inserts 1¼" × 1¼" (32×32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 637, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor With Hexagonal Brass Inserts 1½" × 1½" (40×40mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 975, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor With Hexagonal Brass Inserts 2" (50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1638, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor With Hexagonal Brass Inserts 2½" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1386, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor With Hexagonal Brass Inserts 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1638, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Adaptor With Hexagonal Brass Inserts 4" (100mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 2394, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor With Hexagonal Brass Inserts ¾" × ½" (20×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 173, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor With Hexagonal Brass Inserts 1" × 1" (25×25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 383, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor With Hexagonal Brass Inserts 1¼" × 1¼" (32×32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 650, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor With Hexagonal Brass Inserts 1½" × 1½" (40×40mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1013, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor With Hexagonal Brass Inserts 2" (50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1890, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor With Hexagonal Brass Inserts 2½" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 2175, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor With Hexagonal Brass Inserts 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 2738, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Male Adaptor With Hexagonal Brass Inserts 4" (100mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 4425, '/images/apollo/cpvc/apollo cpvc pipe.webp', ARRAY['/images/apollo/cpvc/apollo cpvc pipe.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Male Adaptor Brass Threaded ¾" × ½" (20×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 120, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Male Adaptor Brass Threaded 1" × ½" (25×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 209, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Male Adaptor Brass Threaded 1" × ¾" (25×20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 215, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Female Tee Brass Threaded ¾" × ½" (20×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 78, '/images/apollo/cpvc/apollo cpvc FEMALE TEE BRASS THREADED.webp', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE TEE BRASS THREADED.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Female Tee Brass Threaded 1" × ½" (25×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 129, '/images/apollo/cpvc/apollo cpvc FEMALE TEE BRASS THREADED.webp', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE TEE BRASS THREADED.webp'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Elbow Brass Threaded ½" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 66, '/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Elbow Brass Threaded ¾" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 118, '/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Elbow Brass Threaded 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 290, '/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Female Elbow Brass Threaded 1¼" (32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 482, '/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Female Adaptor Brass Threaded ¾" × ½" (20×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 76, '/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Female Adaptor Brass Threaded 1" × ½" (25×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 96, '/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ADAPTOR BRASS THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Female Adaptor Plastic Threaded ¾" × ½" (20×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 27, '/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc feMALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Male Adaptor Plastic Threaded ¾" × ½" (20×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 20, '/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg', ARRAY['/images/apollo/cpvc/apollo cpvc MALE ADAPTOR PLASTIC THREADED.jpg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Female Elbow Brass Threaded ¾" × ½" (20×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 71, '/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Female Elbow Brass Threaded 1" × ½" (25×15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 115, '/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo CPVC Reducing Female Elbow Brass Threaded 1" × ¾" (25×20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE(R) CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE(R) CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 184, '/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg', ARRAY['/images/apollo/cpvc/apollo cpvc FEMALE ELBOW BRASS THREADED.jpeg'], '{"Brand": "APL Apollo", "Material": "CPVC (Chlorinated Polyvinyl Chloride)", "GST": "18%", "Category": "CPVC Fittings & Pipes"}'::jsonb, NULL, v_cpvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1/2" (15mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 211, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 3/4" (20mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 276, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1" (25mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 411, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1-1/4" (32mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 546, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1-1/2" (40mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 675, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 2" (50mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 929, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 2-1/2" (65mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1502, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 3" (80mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 2020, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 4" (100mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 2876, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 6" (150mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 5309, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 8" (200mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 8058, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1/2" (15mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 422, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 3/4" (20mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 552, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1" (25mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 822, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1-1/4" (32mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1092, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1-1/2" (40mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1350, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 2" (50mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1858, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 2-1/2" (65mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 3004, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 3" (80mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 4040, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 4" (100mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 5752, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 6" (150mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 10618, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 8" (200mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 16116, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1/2" (15mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 429, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 3/4" (20mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 562, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1" (25mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 836, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1-1/4" (32mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1113, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1-1/2" (40mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1376, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 2" (50mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1894, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 2-1/2" (65mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 3060, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 3" (80mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 4119, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 4" (100mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 5866, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1/2" (15mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 218, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 3/4" (20mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 285, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1" (25mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 423, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1-1/4" (32mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 562, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 1-1/2" (40mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 695, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 2" (50mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 958, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 2-1/2" (65mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1548, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 3" (80mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 2081, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-40 4" (100mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 2963, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1/2" (15mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 260, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 3/4" (20mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 362, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1" (25mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 524, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1-1/4" (32mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 713, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1-1/2" (40mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 886, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 2" (50mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1269, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 2-1/2" (65mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1993, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 3" (80mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 2722, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 4" (100mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 4022, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 6" (150mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 8058, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 8" (200mm) - 3 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 12324, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1/2" (15mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 519, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 3/4" (20mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 724, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1" (25mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1048, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1-1/4" (32mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1426, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1-1/2" (40mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1772, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 2" (50mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 2538, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 2-1/2" (65mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 3686, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 3" (80mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 5424, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 4" (100mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 8045, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 6" (150mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 16116, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 8" (200mm) - 6 Mtr Plain End', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 24648, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1/2" (15mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 522, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 3/4" (20mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 731, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1" (25mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1059, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1-1/4" (32mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1440, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1-1/2" (40mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1790, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 2" (50mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 2564, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 2-1/2" (65mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 4025, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 3" (80mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 5494, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 4" (100mm) - 6 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 8122, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1/2" (15mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 265, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 3/4" (20mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 369, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1" (25mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 535, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1-1/4" (32mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 728, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 1-1/2" (40mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 904, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 2" (50mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1296, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 2-1/2" (65mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 2034, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 3" (80mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 2776, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC Pipe SCH-80 4" (100mm) - 3 Mtr Threaded', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 4101, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Coupler 1/2" (15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 8, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Coupler 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 12, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Coupler 1" (25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 19, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Coupler 1-1/4" (32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 28, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Coupler 1-1/2" (40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 36, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Coupler 2" (50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 54, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Coupler 3/4"×1/2" (20×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 13, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Coupler 1"×1/2" (25×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 16, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Coupler 1"×3/4" (25×20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 19, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Coupler 1-1/4"×1" (32×25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 29, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Coupler 1-1/2"×1" (40×25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 40, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Coupler 2"×1" (50×25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 48, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Coupler 2"×1-1/2" (50×40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 51, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tee 1/2" (15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 14, '/images/apollo/upvc/apollo upvc tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tee 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 21, '/images/apollo/upvc/apollo upvc tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tee 1" (25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 33, '/images/apollo/upvc/apollo upvc tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tee 1-1/4" (32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 52, '/images/apollo/upvc/apollo upvc tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tee 1-1/2" (40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 77, '/images/apollo/upvc/apollo upvc tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tee 2" (50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 128, '/images/apollo/upvc/apollo upvc tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Tee 3/4"×1/2" (20×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 22, '/images/apollo/upvc/apollo upvc reducing tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Tee 1"×1/2" (25×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 32, '/images/apollo/upvc/apollo upvc reducing tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Tee 1"×3/4" (25×20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 33, '/images/apollo/upvc/apollo upvc reducing tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Tee 1-1/2"×1" (40×25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 71, '/images/apollo/upvc/apollo upvc reducing tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Tee 2"×1" (50×25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 115, '/images/apollo/upvc/apollo upvc reducing tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Tee 2"×1-1/2" (50×40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 120, '/images/apollo/upvc/apollo upvc reducing tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Tee 1-1/2"×3/4" (40×20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 63, '/images/apollo/upvc/apollo upvc reducing tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Elbow 90° 1/2" (15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 11, '/images/apollo/upvc/apollo upvc elbow 90.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 90.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Elbow 90° 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 16, '/images/apollo/upvc/apollo upvc elbow 90.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 90.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Elbow 90° 1" (25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 25, '/images/apollo/upvc/apollo upvc elbow 90.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 90.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Elbow 90° 1-1/4" (32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 40, '/images/apollo/upvc/apollo upvc elbow 90.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 90.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Elbow 90° 1-1/2" (40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 57, '/images/apollo/upvc/apollo upvc elbow 90.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 90.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Elbow 2" (50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 84, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Elbow 3/4"×1/2" (20×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 18, '/images/apollo/upvc/apollo upvc reducing elbow.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing elbow.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Elbow 1"×1/2" (25×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 26, '/images/apollo/upvc/apollo upvc reducing elbow.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing elbow.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Elbow 1"×3/4" (25×20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 34, '/images/apollo/upvc/apollo upvc reducing elbow.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing elbow.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Elbow 45° 1/2" (15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 11, '/images/apollo/upvc/apollo upvc elbow 45.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 45.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Elbow 45° 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 15, '/images/apollo/upvc/apollo upvc elbow 45.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 45.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Elbow 45° 1" (25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 24, '/images/apollo/upvc/apollo upvc elbow 45.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 45.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Elbow 45° 1-1/4" (32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 38, '/images/apollo/upvc/apollo upvc elbow 45.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 45.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Elbow 45° 1-1/2" (40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 44, '/images/apollo/upvc/apollo upvc elbow 45.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 45.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Elbow 45° 2" (50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 71, '/images/apollo/upvc/apollo upvc elbow 45.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 45.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Ball Valve 1/2" (15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 78, '/images/apollo/upvc/apollo upvc ball valve.jpg', ARRAY['/images/apollo/upvc/apollo upvc ball valve.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Ball Valve 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 116, '/images/apollo/upvc/apollo upvc ball valve.jpg', ARRAY['/images/apollo/upvc/apollo upvc ball valve.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Ball Valve 1" (25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 184, '/images/apollo/upvc/apollo upvc ball valve.jpg', ARRAY['/images/apollo/upvc/apollo upvc ball valve.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Ball Valve 1-1/4" (32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 291, '/images/apollo/upvc/apollo upvc ball valve.jpg', ARRAY['/images/apollo/upvc/apollo upvc ball valve.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Ball Valve 1-1/2" (40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 439, '/images/apollo/upvc/apollo upvc ball valve.jpg', ARRAY['/images/apollo/upvc/apollo upvc ball valve.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Ball Valve 2" (50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 654, '/images/apollo/upvc/apollo upvc ball valve.jpg', ARRAY['/images/apollo/upvc/apollo upvc ball valve.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Union 1/2" (15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 26, '/images/apollo/upvc/apollo upvc union.jpg', ARRAY['/images/apollo/upvc/apollo upvc union.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Union 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 34, '/images/apollo/upvc/apollo upvc union.jpg', ARRAY['/images/apollo/upvc/apollo upvc union.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Union 1" (25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 50, '/images/apollo/upvc/apollo upvc union.jpg', ARRAY['/images/apollo/upvc/apollo upvc union.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Union 1-1/4" (32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 74, '/images/apollo/upvc/apollo upvc union.jpg', ARRAY['/images/apollo/upvc/apollo upvc union.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Union 1-1/2" (40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 120, '/images/apollo/upvc/apollo upvc union.jpg', ARRAY['/images/apollo/upvc/apollo upvc union.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Union 2" (50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 176, '/images/apollo/upvc/apollo upvc union.jpg', ARRAY['/images/apollo/upvc/apollo upvc union.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tank Connector Short 1/2" (15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 24, '/images/apollo/upvc/apollo upvc tank connector short.jpg', ARRAY['/images/apollo/upvc/apollo upvc tank connector short.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tank Connector Short 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 29, '/images/apollo/upvc/apollo upvc tank connector short.jpg', ARRAY['/images/apollo/upvc/apollo upvc tank connector short.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tank Connector Short 1" (25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 39, '/images/apollo/upvc/apollo upvc tank connector short.jpg', ARRAY['/images/apollo/upvc/apollo upvc tank connector short.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tank Connector Short 1-1/4" (32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 60, '/images/apollo/upvc/apollo upvc tank connector short.jpg', ARRAY['/images/apollo/upvc/apollo upvc tank connector short.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tank Connector Short 1-1/2" (40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 82, '/images/apollo/upvc/apollo upvc tank connector short.jpg', ARRAY['/images/apollo/upvc/apollo upvc tank connector short.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tank Connector Short 2" (50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 116, '/images/apollo/upvc/apollo upvc tank connector short.jpg', ARRAY['/images/apollo/upvc/apollo upvc tank connector short.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tank Connector Long 1/2" (15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 47, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tank Connector Long 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 61, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tank Connector Long 1" (25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 87, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 End Cap 1/2" (15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 6, '/images/apollo/upvc/apollo upvc end cap.jpg', ARRAY['/images/apollo/upvc/apollo upvc end cap.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 End Cap 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 9, '/images/apollo/upvc/apollo upvc end cap.jpg', ARRAY['/images/apollo/upvc/apollo upvc end cap.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 End Cap 1" (25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 15, '/images/apollo/upvc/apollo upvc end cap.jpg', ARRAY['/images/apollo/upvc/apollo upvc end cap.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 End Cap 1-1/4" (32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 19, '/images/apollo/upvc/apollo upvc end cap.jpg', ARRAY['/images/apollo/upvc/apollo upvc end cap.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 End Cap 1-1/2" (40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 27, '/images/apollo/upvc/apollo upvc end cap.jpg', ARRAY['/images/apollo/upvc/apollo upvc end cap.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 End Cap 2" (50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 44, '/images/apollo/upvc/apollo upvc end cap.jpg', ARRAY['/images/apollo/upvc/apollo upvc end cap.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Bush 3/4"×1/2" (20×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 4, '/images/apollo/upvc/apollo upvc reducing bush.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing bush.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Bush 1"×1/2" (25×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 8, '/images/apollo/upvc/apollo upvc reducing bush.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing bush.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Bush 1"×3/4" (25×20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 9, '/images/apollo/upvc/apollo upvc reducing bush.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing bush.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Bush 1-1/4"×1" (32×25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 13, '/images/apollo/upvc/apollo upvc reducing bush.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing bush.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Bush 1-1/2"×1" (40×25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 32, '/images/apollo/upvc/apollo upvc reducing bush.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing bush.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Bush 2"×1" (50×25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 37, '/images/apollo/upvc/apollo upvc reducing bush.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing bush.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Reducing Bush 2"×1-1/2" (50×40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 33, '/images/apollo/upvc/apollo upvc reducing bush.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing bush.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Plastic Threaded 1/2" (15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 8, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Plastic Threaded 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 10, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Plastic Threaded 1" (25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 16, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Plastic Threaded 1-1/4" (32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 29, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Plastic Threaded 1-1/2" (40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 32, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Plastic Threaded 2" (50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 50, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Brass Threaded 1/2"×1/2" (15×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 98, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Brass Threaded 3/4"×3/4" (20×20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 129, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Brass Threaded 1"×1" (25×25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 193, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Brass Threaded 1"×1/2" (25×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 124, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Brass Threaded 3/4"×1/2" (20×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 99, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Brass Threaded 1-1/4"×1-1/4" (32×32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 432, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Brass Threaded 1-1/2"×1-1/2" (40×40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 416, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor Brass Threaded 2"×2" (50×50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 672, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Plastic Threaded 1/2" (15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 8, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Plastic Threaded 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 12, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Plastic Threaded 1" (25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 21, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Plastic Threaded 1-1/4" (32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 27, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Plastic Threaded 1-1/2" (40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 36, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Plastic Threaded 2" (50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 54, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Brass Threaded 1/2"×1/2" (15×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 61, '/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Brass Threaded 3/4"×3/4" (20×20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 93, '/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Brass Threaded 1"×1" (25×25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 172, '/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Brass Threaded 1"×1/2" (25×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 81, '/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Brass Threaded 3/4"×1/2" (20×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 64, '/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Brass Threaded 1-1/4"×1-1/4" (32×32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 280, '/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Brass Threaded 1-1/2"×1-1/2" (40×40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 408, '/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor Brass Threaded 2"×2" (50×50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 544, '/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female adaptor brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Elbow Brass Threaded 1/2"×1/2" (15×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 72, '/images/apollo/upvc/apollo upvc female elbow brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female elbow brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Elbow Brass Threaded 3/4"×1/2" (20×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 80, '/images/apollo/upvc/apollo upvc female elbow brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female elbow brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Elbow Brass Threaded 1"×1/2" (25×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 96, '/images/apollo/upvc/apollo upvc female elbow brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female elbow brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Elbow Brass Threaded 3/4"×3/4" (20×20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 110, '/images/apollo/upvc/apollo upvc female elbow brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female elbow brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Elbow Brass Threaded 1"×1" (25×25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 205, '/images/apollo/upvc/apollo upvc female elbow brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female elbow brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Tee Brass Threaded 1/2"×1/2" (15×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 88, '/images/apollo/upvc/apollo upvc female tee brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female tee brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Tee Brass Threaded 3/4"×1/2" (20×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 91, '/images/apollo/upvc/apollo upvc female tee brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female tee brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Tee Brass Threaded 1"×1/2" (25×15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 118, '/images/apollo/upvc/apollo upvc female tee brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female tee brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Tee Brass Threaded 1"×1" (25×25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 238, '/images/apollo/upvc/apollo upvc female tee brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female tee brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Tee Brass Threaded 3/4"×3/4" (20×20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 122, '/images/apollo/upvc/apollo upvc female tee brass threaded.jpg', ARRAY['/images/apollo/upvc/apollo upvc female tee brass threaded.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Step Over Bend 1/2" (15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 36, '/images/apollo/upvc/apollo upvc step over bend.jpg', ARRAY['/images/apollo/upvc/apollo upvc step over bend.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Step Over Bend 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 56, '/images/apollo/upvc/apollo upvc step over bend.jpg', ARRAY['/images/apollo/upvc/apollo upvc step over bend.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Step Over Bend 1" (25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 79, '/images/apollo/upvc/apollo upvc step over bend.jpg', ARRAY['/images/apollo/upvc/apollo upvc step over bend.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Step Over Bend 1-1/4" (32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 124, '/images/apollo/upvc/apollo upvc step over bend.jpg', ARRAY['/images/apollo/upvc/apollo upvc step over bend.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Threaded Coupler 1-1/4" (32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 29, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 End Plug 1/2" (15mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 10, '/images/apollo/upvc/apollo upvc end plug.jpg', ARRAY['/images/apollo/upvc/apollo upvc end plug.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 End Plug 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 13, '/images/apollo/upvc/apollo upvc end plug.jpg', ARRAY['/images/apollo/upvc/apollo upvc end plug.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor with Hexagonal Brass Inserts 2-1/2" (65mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1720, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor with Hexagonal Brass Inserts 3" (80mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 2240, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Male Adaptor with Hexagonal Brass Inserts 4" (100mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 3600, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor with Hexagonal Brass Inserts 2-1/2" (65mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 976, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor with Hexagonal Brass Inserts 3" (80mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1120, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Female Adaptor with Hexagonal Brass Inserts 4" (100mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1640, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 NRV (Non Returnable Valve) 3/4" (20mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 244, '/images/apollo/upvc/apollo upvc nrv.jpg', ARRAY['/images/apollo/upvc/apollo upvc nrv.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 NRV (Non Returnable Valve) 1" (25mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 428, '/images/apollo/upvc/apollo upvc nrv.jpg', ARRAY['/images/apollo/upvc/apollo upvc nrv.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 NRV (Non Returnable Valve) 1-1/4" (32mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 820, '/images/apollo/upvc/apollo upvc nrv.jpg', ARRAY['/images/apollo/upvc/apollo upvc nrv.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 NRV (Non Returnable Valve) 1-1/2" (40mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1211, '/images/apollo/upvc/apollo upvc nrv.jpg', ARRAY['/images/apollo/upvc/apollo upvc nrv.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 80 Tuff Seal Teflon Tape (Bath Fittings) 12mm x 0.1mm x 10 Mtr', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 22, '/images/apollo/upvc/apollo upvc pipe plain.jpg', ARRAY['/images/apollo/upvc/apollo upvc pipe plain.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Coupler 2-1/2" (65mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 90, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Coupler 3" (80mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 126, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Coupler 4" (100mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 198, '/images/apollo/upvc/apollo upvc coupler.jpg', ARRAY['/images/apollo/upvc/apollo upvc coupler.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Tee 2-1/2" (65mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 192, '/images/apollo/upvc/apollo upvc tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Tee 3" (80mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 298, '/images/apollo/upvc/apollo upvc tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Tee 4" (100mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 540, '/images/apollo/upvc/apollo upvc tee.jpg', ARRAY['/images/apollo/upvc/apollo upvc tee.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Elbow 45° 2-1/2" (65mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 140, '/images/apollo/upvc/apollo upvc elbow 45.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 45.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Elbow 45° 3" (80mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 210, '/images/apollo/upvc/apollo upvc elbow 45.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 45.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Elbow 45° 4" (100mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 330, '/images/apollo/upvc/apollo upvc elbow 45.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 45.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Elbow 90° 2-1/2" (65mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 144, '/images/apollo/upvc/apollo upvc elbow 90.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 90.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Elbow 90° 3" (80mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 216, '/images/apollo/upvc/apollo upvc elbow 90.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 90.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Elbow 90° 4" (100mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 378, '/images/apollo/upvc/apollo upvc elbow 90.jpg', ARRAY['/images/apollo/upvc/apollo upvc elbow 90.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 End Cap 2-1/2" (65mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 71, '/images/apollo/upvc/apollo upvc end cap.jpg', ARRAY['/images/apollo/upvc/apollo upvc end cap.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 End Cap 3" (80mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 118, '/images/apollo/upvc/apollo upvc end cap.jpg', ARRAY['/images/apollo/upvc/apollo upvc end cap.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 End Cap 4" (100mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 174, '/images/apollo/upvc/apollo upvc end cap.jpg', ARRAY['/images/apollo/upvc/apollo upvc end cap.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Union 2-1/2" (65mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 462, '/images/apollo/upvc/apollo upvc union.jpg', ARRAY['/images/apollo/upvc/apollo upvc union.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Union 3" (80mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 630, '/images/apollo/upvc/apollo upvc union.jpg', ARRAY['/images/apollo/upvc/apollo upvc union.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Union 4" (100mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 1490, '/images/apollo/upvc/apollo upvc union.jpg', ARRAY['/images/apollo/upvc/apollo upvc union.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Male Adaptor Plastic Threaded 2-1/2" (65mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 82, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Male Adaptor Plastic Threaded 3" (80mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 130, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Male Adaptor Plastic Threaded 4" (100mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 222, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Reducing Bush 4"×3" (100×80mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 140, '/images/apollo/upvc/apollo upvc reducing bush.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing bush.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Reducing Bush 4"×2-1/2" (100×65mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 152, '/images/apollo/upvc/apollo upvc reducing bush.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing bush.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Reducing Bush 4"×2" (100×50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 142, '/images/apollo/upvc/apollo upvc reducing bush.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing bush.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Reducing Bush 3"×2-1/2" (80×65mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 82, '/images/apollo/upvc/apollo upvc reducing bush.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing bush.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Reducing Bush 3"×2" (80×50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 102, '/images/apollo/upvc/apollo upvc reducing bush.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing bush.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Reducing Bush 2-1/2"×2" (65×50mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 51, '/images/apollo/upvc/apollo upvc reducing bush.jpg', ARRAY['/images/apollo/upvc/apollo upvc reducing bush.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Female Adaptor Plastic Threaded 2-1/2" (65mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 85, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Female Adaptor Plastic Threaded 3" (80mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 132, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Female Adaptor Plastic Threaded 4" (100mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 219, '/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif', ARRAY['/images/apollo/upvc/apollo upvc male adaptor plastic threaded.avif'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Ball Valve (LH) 2-1/2" (65mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 3300, '/images/apollo/upvc/apollo upvc ball valve.jpg', ARRAY['/images/apollo/upvc/apollo upvc ball valve.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Ball Valve (LH) 3" (80mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 4860, '/images/apollo/upvc/apollo upvc ball valve.jpg', ARRAY['/images/apollo/upvc/apollo upvc ball valve.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true),
  ('Apollo uPVC SCH 40 Ball Valve (LH) 4" (100mm)', 'APL Apollo uPVC piping and fittings are designed for domestic water supply and pressure applications, offering leak-proof, long-lasting performance.

Key features:
- Extra-strong, corrosion-resistant uPVC construction
- Smooth bore for efficient, silent flow
- ISI certified; conforming to IS:15111 / IS:4985 standards
- Leak-proof solvent-welded joints
- UV and weather resistant', 8220, '/images/apollo/upvc/apollo upvc ball valve.jpg', ARRAY['/images/apollo/upvc/apollo upvc ball valve.jpg'], '{"Brand": "APL Apollo", "Material": "uPVC (Unplasticized Polyvinyl Chloride)", "GST": "18%", "Category": "SWR / uPVC Pipes & Fittings"}'::jsonb, NULL, v_upvc, 100, true);
  UPDATE products SET specs = specs || '{"Source":"apollo-pricelist-august-2026"}'::jsonb
    WHERE specs->>'Source' IS DISTINCT FROM 'apollo-pricelist-august-2026'
      AND id IN (SELECT id FROM products WHERE specs->>'Brand' = 'APL Apollo' AND specs->>'Source' IS NULL);
END $$;
