-- APL Apollo products seeded from Apollo Price List Brochure March 2026 PDF.
-- Replaces existing Apollo products with accurate, size-specific items from the official price list.
-- Safe to re-run: deletes existing Apollo products first, then inserts new ones.

DO $$
DECLARE
  v_parent UUID;
  v_sub0 UUID;  -- CPVC Fittings & Pipes
  v_sub1 UUID;  -- SWR / uPVC Pipes & Fittings
  v_sub2 UUID;  -- Solvent Cement
  v_sub3 UUID;  -- Water Tanks
BEGIN
  -- Parent category
  SELECT id INTO v_parent FROM categories WHERE slug='apollo' OR lower(name)='apollo' LIMIT 1;
  IF v_parent IS NULL THEN
    INSERT INTO categories (name, slug) VALUES ('Apollo','apollo') RETURNING id INTO v_parent;
  END IF;

  SELECT id INTO v_sub0 FROM categories WHERE parent_id=v_parent AND name='CPVC Fittings & Pipes' LIMIT 1;
  IF v_sub0 IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('CPVC Fittings & Pipes', 'apollo-cpvc-fittings-pipes', v_parent) RETURNING id INTO v_sub0;
  END IF;

  SELECT id INTO v_sub1 FROM categories WHERE parent_id=v_parent AND name='SWR / uPVC Pipes & Fittings' LIMIT 1;
  IF v_sub1 IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('SWR / uPVC Pipes & Fittings', 'apollo-swr-upvc-pipes-fittings', v_parent) RETURNING id INTO v_sub1;
  END IF;

  SELECT id INTO v_sub2 FROM categories WHERE parent_id=v_parent AND name='Solvent Cement' LIMIT 1;
  IF v_sub2 IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('Solvent Cement', 'apollo-solvent-cement', v_parent) RETURNING id INTO v_sub2;
  END IF;

  SELECT id INTO v_sub3 FROM categories WHERE parent_id=v_parent AND name='Water Tanks' LIMIT 1;
  IF v_sub3 IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('Water Tanks', 'apollo-water-tanks', v_parent) RETURNING id INTO v_sub3;
  END IF;

  -- Delete existing Apollo products (optional: comment out to keep old products)
  DELETE FROM products WHERE category_id IN (v_sub0, v_sub1, v_sub2, v_sub3);

  -- Insert products from Apollo Price List March 2026
  INSERT INTO products (name, description, price, image_url, images, specs, category_id, stock, is_active) VALUES
  ('Apollo CPVC-X Transition Bush 1/2"x1/2" (15x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 9, '/images/apollo/apollo-transition-bush-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-transition-bush-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15x15","Size (inch)":"1/2\"x1/2\"","Item Code":"CM0246010V","Standard Packaging":"900 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X End Cap 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 9, '/images/apollo/apollo-end-cap-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-end-cap-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CMN02020V","Standard Packaging":"2000 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Coupler 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 13, '/images/apollo/apollo-coupler-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-coupler-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CMN02010V","Standard Packaging":"1200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 15, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CM02080V","Standard Packaging":"800 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Bush 3/4"x1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 17, '/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"CMN02060W0V","Standard Packaging":"1400 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Elbow 90° 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 18, '/images/apollo/apollo-elbow-90-degree-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-elbow-90-degree-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CMN02030V","Standard Packaging":"900 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Coupler 3/4"x1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 20, '/images/apollo/apollo-reducing-coupler-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"CMN02050W0V","Standard Packaging":"750 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X End Plug Threaded 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 20, '/images/apollo/apollo-end-plug-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-end-plug-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CMN02130V","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Bush 1"x1/2" (25x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 21, '/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25x15","Size (inch)":"1\"x1/2\"","Item Code":"CMN0206010V","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 21, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CM02100V","Standard Packaging":"700 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Tee 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 23, '/images/apollo/apollo-tee-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tee-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CMN02040V","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Transition Bush 3/4"x3/4" (20x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 23, '/images/apollo/apollo-transition-bush-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-transition-bush-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20x20","Size (inch)":"3/4\"x3/4\"","Item Code":"CMN0246010W","Standard Packaging":"800 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X End Cap 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 25, '/images/apollo/apollo-end-cap-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-end-cap-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02020W","Standard Packaging":"900 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Male Adaptor Plastic Threaded 3/4"x1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 26, '/images/apollo/apollo-reducing-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"CMN02280W0V","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Elbow 45° 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 27, '/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02280W","Standard Packaging":"450 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Elbow 3/4"x1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 27, '/images/apollo/apollo-reducing-elbow-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-reducing-elbow-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"CMN02270W0V","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Coupler 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 32, '/images/apollo/apollo-coupler-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-coupler-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02010W","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Bush 1"x3/4" (25x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 33, '/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25x20","Size (inch)":"1\"x3/4\"","Item Code":"CMN0206010W","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Female Adaptor Plastic Threaded 3/4"x1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 35, '/images/apollo/apollo-reducing-female-adaptor-plastic-threaded-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-reducing-female-adaptor-plastic-threaded-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"CMN02290W0V","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 42, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02080W","Standard Packaging":"500 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Bush 1-1/4"x3/4" (32x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 45, '/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"32x20","Size (inch)":"1-1/4\"x3/4\"","Item Code":"CMN02061U0W","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Elbow 90° 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 47, '/images/apollo/apollo-elbow-90-degree-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-elbow-90-degree-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02030W","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Elbow 1"x3/4" (25x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 53, '/images/apollo/apollo-reducing-elbow-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-reducing-elbow-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25x20","Size (inch)":"1\"x3/4\"","Item Code":"CMN0227010W","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 53, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02100W","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Tee 3/4"x1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 54, '/images/apollo/apollo-reducing-tee-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-tee-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"CMN02070W0V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Tee 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 59, '/images/apollo/apollo-tee-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tee-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02040W","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X End Cap 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 59, '/images/apollo/apollo-end-cap-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-end-cap-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CMN020201","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Transition Bush 1"x1" (25x25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 60, '/images/apollo/apollo-transition-bush-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-transition-bush-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25x25","Size (inch)":"1\"x1\"","Item Code":"CMN02460101","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Cross Tee 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 60, '/images/apollo/apollo-cross-tee-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-cross-tee-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02140W","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Union 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 63, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CM02110V","Standard Packaging":"250 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Tank Connector 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 66, '/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CMN02090V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Tank Connector-pipe-fitment 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 75, '/images/apollo/apollo-tank-connector-pipe-fitment-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-pipe-fitment-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02300W","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Coupler 1"x3/4" (25x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 78, '/images/apollo/apollo-reducing-coupler-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25x20","Size (inch)":"1\"x3/4\"","Item Code":"CMN0205010W","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 78, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CMN020801","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SDR-13.5 1/2" (15mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SDR-13.5
Length: 3mtr/5mtr
Price shown is per meter.', 81, '/images/apollo/apollo-cpvc-pipe-sdr-135.jpg', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-135.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Pipe Type":"SDR-13.5","Standard Packaging":"50 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 87, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CM02200V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SDR-11 1/2" (15mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SDR-11
Length: 3mtr/5mtr
Price shown is per meter.', 93, '/images/apollo/apollo-cpvc-pipe-sdr-11.webp', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-11.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Pipe Type":"SDR-11","Standard Packaging":"50 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 3/4"x1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 94, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"CMN02210W0V","Standard Packaging":"250 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Elbow 45° 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 98, '/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CMN022801","Standard Packaging":"225 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Coupler 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 99, '/images/apollo/apollo-coupler-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-coupler-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CMN020101","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Female Adaptor Brass Threaded 3/4"x1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 101, '/images/apollo/apollo-reducing-female-adaptor-brass-threaded-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-reducing-female-adaptor-brass-threaded-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"CMN02190W0V","Standard Packaging":"420 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Tank Connector 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 102, '/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02090W","Standard Packaging":"140 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Bush 1-1/4"x1" (32x25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 102, '/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"32x25","Size (inch)":"1-1/4\"x1\"","Item Code":"CMN02061U01","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Tee 3/4"x1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 103, '/images/apollo/apollo-tee-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tee-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"CMN02230W0V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Bush 1-1/2"x3/4" (40x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 105, '/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"40x20","Size (inch)":"1-1/2\"x3/4\"","Item Code":"CMN02061V0W","Standard Packaging":"225 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Step Over Bend 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 115, '/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02260W","Standard Packaging":"75 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SDR-13.5 3/4" (20mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SDR-13.5
Length: 3mtr/5mtr
Price shown is per meter.', 119, '/images/apollo/apollo-cpvc-pipe-sdr-135.jpg', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-135.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Pipe Type":"SDR-13.5","Standard Packaging":"50 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Tee 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 124, '/images/apollo/apollo-tee-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tee-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CM02220V","Standard Packaging":"120 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Union 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 128, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02110W","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SDR-11 3/4" (20mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SDR-11
Length: 3mtr/5mtr
Price shown is per meter.', 131, '/images/apollo/apollo-cpvc-pipe-sdr-11.webp', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-11.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Pipe Type":"SDR-11","Standard Packaging":"50 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Coupler 1-1/4"x1" (32x25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 134, '/images/apollo/apollo-reducing-coupler-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"32x25","Size (inch)":"1-1/4\"x1\"","Item Code":"CMN02051U01","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 135, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CMN021001","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Tee 1"x3/4" (25x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 146, '/images/apollo/apollo-reducing-tee-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-tee-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25x20","Size (inch)":"1\"x3/4\"","Item Code":"CMN0207010W","Standard Packaging":"75 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Ball Valve 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 150, '/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CM23300V","Standard Packaging":"84 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Male Adaptor Brass Threaded 3/4"x1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 160, '/images/apollo/apollo-reducing-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"CMN02170W0V","Standard Packaging":"360 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Elbow 90° 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 165, '/images/apollo/apollo-elbow-90-degree-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-elbow-90-degree-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CMN020301","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Brass Threaded 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 180, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CM02180V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Tee 1-1/4"x3/4" (32x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 183, '/images/apollo/apollo-reducing-tee-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-tee-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"32x20","Size (inch)":"1-1/4\"x3/4\"","Item Code":"CMN02071U0W","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SDR-13.5 1" (25mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SDR-13.5
Length: 3mtr/5mtr
Price shown is per meter.', 188, '/images/apollo/apollo-cpvc-pipe-sdr-135.jpg', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-135.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Pipe Type":"SDR-13.5","Standard Packaging":"40 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Brass Threaded 1/2" (15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 192, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"CM02160V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Tee 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 203, '/images/apollo/apollo-tee-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tee-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CMN020401","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SDR-11 1" (25mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SDR-11
Length: 3mtr/5mtr
Price shown is per meter.', 207, '/images/apollo/apollo-cpvc-pipe-sdr-11.webp', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-11.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Pipe Type":"SDR-11","Standard Packaging":"40 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Cross Tee 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 210, '/images/apollo/apollo-cross-tee-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-cross-tee-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CMN021401","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Tank Connector 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 218, '/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CMN020901","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Coupler 1-1/4"x3/4" (32x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 225, '/images/apollo/apollo-reducing-coupler-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"32x20","Size (inch)":"1-1/4\"x3/4\"","Item Code":"CMN02051U0W","Standard Packaging":"225 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Brass Threaded 3/4"x1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 230, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"CM02320W0V","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 1"x1/2" (25x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 245, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25x15","Size (inch)":"1\"x1/2\"","Item Code":"CMN0221010W","Standard Packaging":"160 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Step Over Bend 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 275, '/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CMN022601","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Union 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 278, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CMN021101","Standard Packaging":"120 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SDR-13.5 1-1/4" (32mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SDR-13.5
Length: 3mtr/5mtr
Price shown is per meter.', 279, '/images/apollo/apollo-cpvc-pipe-sdr-135.jpg', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-135.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Pipe Type":"SDR-13.5","Standard Packaging":"25 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Male Adaptor Brass Threaded 1"x1/2" (25x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 286, '/images/apollo/apollo-reducing-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25x15","Size (inch)":"1\"x1/2\"","Item Code":"CMN0217010V","Standard Packaging":"280 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SDR-11 1-1/4" (32mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SDR-11
Length: 3mtr/5mtr
Price shown is per meter.', 300, '/images/apollo/apollo-cpvc-pipe-sdr-11.webp', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-11.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Pipe Type":"SDR-11","Standard Packaging":"25 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Brass Threaded 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 319, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02160W","Standard Packaging":"250 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Brass Threaded 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 333, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02180W","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Tee 1-1/2"x3/4" (40x20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 338, '/images/apollo/apollo-reducing-tee-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-tee-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"40x20","Size (inch)":"1-1/2\"x3/4\"","Item Code":"CCMN02071V0W","Standard Packaging":"18 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Bush 2-1/2"x2" (65x50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 338, '/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65x50","Size (inch)":"2-1/2\"x2\"","Item Code":"CMN02062V02","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Tee 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 352, '/images/apollo/apollo-tee-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tee-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02220W","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Tee 1-1/4"x1" (32x25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 360, '/images/apollo/apollo-reducing-tee-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-tee-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"32x25","Size (inch)":"1-1/4\"x1\"","Item Code":"CMN02071U01","Standard Packaging":"24 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Ball Valve 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 368, '/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CM23300W","Standard Packaging":"45 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X End Cap 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 375, '/images/apollo/apollo-end-cap-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-end-cap-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"CMN02022V","Standard Packaging":"45 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 3/4" (20mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 386, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"CMN02200W","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SDR-13.5 1-1/2" (40mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SDR-13.5
Length: 3mtr/5mtr
Price shown is per meter.', 390, '/images/apollo/apollo-cpvc-pipe-sdr-135.jpg', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-135.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Pipe Type":"SDR-13.5","Standard Packaging":"10 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Elbow 45° 1-1/4" (32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 405, '/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"CMN02281U","Standard Packaging":"120 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 3/4"x1/2" (20x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 450, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"CM02350W0V","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SDR-11 1-1/2" (40mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SDR-11
Length: 3mtr/5mtr
Price shown is per meter.', 450, '/images/apollo/apollo-cpvc-pipe-sdr-11.webp', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-11.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Pipe Type":"SDR-11","Standard Packaging":"10 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Brass Threaded 1"x1" (25x25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 510, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25x25","Size (inch)":"1\"x1\"","Item Code":"CM023101","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Brass Threaded 1"x1" (25x25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 510, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25x25","Size (inch)":"1\"x1\"","Item Code":"CM023301","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Coupler 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 522, '/images/apollo/apollo-coupler-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-coupler-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"CMN02012V","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 528, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"CMN02102V","Standard Packaging":"27 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Bush 3"x2-1/2" (80x65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 533, '/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"80x65","Size (inch)":"3\"x2-1/2\"","Item Code":"CMN0206032V","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 548, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"CM02082V","Standard Packaging":"45 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Bush 3"x2" (80x50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 608, '/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"80x50","Size (inch)":"3\"x2\"","Item Code":"CMN02060302","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SDR-13.5 2" (50mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SDR-13.5
Length: 3mtr/5mtr
Price shown is per meter.', 653, '/images/apollo/apollo-cpvc-pipe-sdr-135.jpg', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-135.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"50","Size (inch)":"2\"","Pipe Type":"SDR-13.5","Standard Packaging":"10 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 1"x1/2" (25x15mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 675, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25x15","Size (inch)":"1\"x1/2\"","Item Code":"CM0235010V","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SDR-11 2" (50mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SDR-11
Length: 3mtr/5mtr
Price shown is per meter.', 773, '/images/apollo/apollo-cpvc-pipe-sdr-11.webp', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-11.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"50","Size (inch)":"2\"","Pipe Type":"SDR-11","Standard Packaging":"10 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Brass Threaded 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 790, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CMN02181U","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Elbow 90° 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 818, '/images/apollo/apollo-elbow-90-degree-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-elbow-90-degree-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"CMN02032V","Standard Packaging":"12 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Brass Threaded 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 832, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CMN021601","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Bush 4"x3" (100x80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 863, '/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"100x80","Size (inch)":"4\"x3\"","Item Code":"CMN02060403","Standard Packaging":"21 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Brass Threaded 1-1/4"x1-1/4" (32x32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 866, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"32x32","Size (inch)":"1-1/4\"x1-1/4\"","Item Code":"CM02311U","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Elbow 45° 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1005, '/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"CMN02282V","Standard Packaging":"16 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Bush 4"x2-1/2" (100x65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1013, '/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"100x65","Size (inch)":"4\"x2-1/2\"","Item Code":"CMN0206042V","Standard Packaging":"21 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Ball Valve 1" (25mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1020, '/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"CM233001","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Reducing Bush 4"x2" (100x50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1035, '/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"100x50","Size (inch)":"4\"x2\"","Item Code":"CMN02060402","Standard Packaging":"21 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Coupler 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1065, '/images/apollo/apollo-coupler-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-coupler-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"CMN020103","Standard Packaging":"18 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Tee 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1128, '/images/apollo/apollo-tee-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tee-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"CMN02042V","Standard Packaging":"10 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SCH-40 2-1/2" (65mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SCH-40
Length: 3mtr/5mtr
Price shown is per meter.', 1230, '/images/apollo/apollo-cpvc-pipe-schedule-40.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-40.avif'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Pipe Type":"SCH-40","Standard Packaging":"7 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Brass Threaded 1-1/4"x1-1/4" (32x32mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1300, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"32x32","Size (inch)":"1-1/4\"x1-1/4\"","Item Code":"CM02331U","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Brass Threaded 1-1/2"x1-1/2" (40x40mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1350, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"40x40","Size (inch)":"1-1/2\"x1-1/2\"","Item Code":"CM02311V","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1440, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"CMN021003","Standard Packaging":"18 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1470, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"CMN020803","Standard Packaging":"24 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SCH-80 2-1/2" (65mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SCH-80
Length: 3mtr/5mtr
Price shown is per meter.', 1598, '/images/apollo/apollo-cpvc-pipe-schedule-80.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-80.avif'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Pipe Type":"SCH-80","Standard Packaging":"7 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Union 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1650, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"CMN02112V","Standard Packaging":"12 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SCH-40 3" (80mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SCH-40
Length: 3mtr/5mtr
Price shown is per meter.', 1658, '/images/apollo/apollo-cpvc-pipe-schedule-40.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-40.avif'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"80","Size (inch)":"3\"","Pipe Type":"SCH-40","Standard Packaging":"5 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1848, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"CM02332V","Standard Packaging":"16 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Elbow 90° 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1860, '/images/apollo/apollo-elbow-90-degree-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-elbow-90-degree-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"CMN020303","Standard Packaging":"8 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SCH-80 3" (80mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SCH-80
Length: 3mtr/5mtr
Price shown is per meter.', 2213, '/images/apollo/apollo-cpvc-pipe-schedule-80.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-80.avif'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"80","Size (inch)":"3\"","Pipe Type":"SCH-80","Standard Packaging":"5 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SCH-40 4" (100mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SCH-40
Length: 3mtr/5mtr
Price shown is per meter.', 2318, '/images/apollo/apollo-cpvc-pipe-schedule-40.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-40.avif'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"100","Size (inch)":"4\"","Pipe Type":"SCH-40","Standard Packaging":"3 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Brass Threaded 2" (50mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 2520, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"CM023102","Standard Packaging":"16 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Elbow 45° 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 2775, '/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"CMN022803","Standard Packaging":"12 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Ball Valve 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 2900, '/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"CM02312V","Standard Packaging":"16 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Tee 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 2925, '/images/apollo/apollo-tee-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tee-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"CMN020403","Standard Packaging":"6 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Male Adaptor Plastic Threaded 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 3192, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"CM023303","Standard Packaging":"6 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Pipe SCH-80 4" (100mm) — Per Meter', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards

Pipe Type: SCH-80
Length: 3mtr/5mtr
Price shown is per meter.', 3285, '/images/apollo/apollo-cpvc-pipe-schedule-80.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-80.avif'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"100","Size (inch)":"4\"","Pipe Type":"SCH-80","Standard Packaging":"3 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Ball Valve 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 5900, '/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"CM023103","Standard Packaging":"6 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Ball Valve 2-1/2" (65mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 7425, '/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"CTP02302V","Standard Packaging":"4 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC-X Ball Valve 3" (80mm)', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 16875, '/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"CTP023003","Standard Packaging":"2 pcs/box","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo uPVC Ball Valve 3/4" (20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 229, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"UMN01220W","Standard Packaging":"10 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 6" (160mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 307, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160","Size (inch)":"6\"","Item Code":"PMN032806","Standard Packaging":"24 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 3/4" (20mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 4, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"PM03310V","Standard Packaging":"1000 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 3/4" (20mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 4.75, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"PM03220V","Standard Packaging":"500 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Bush 3/4"x1/2" (20x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 5, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"UM01110W0V","Standard Packaging":"1000 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 1" (25mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 5, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"PM03310W","Standard Packaging":"1000 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3/4" (20mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 5.25, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"PM03300V","Standard Packaging":"1000 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 3/4" (20mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 6.75, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"PM03250V","Standard Packaging":"750 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC End Cap 1/2" (15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 7, '/images/apollo/apollo-end-cap-pn10-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-end-cap-pn10-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"UM01040V","Standard Packaging":"900 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 1-1/4" (32mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 7.5, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"PM033101","Standard Packaging":"750 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 3/4" (20mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 8, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"PM03730V","Standard Packaging":"500 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 1" (25mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 8, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"PM03220W","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 1-1/2" (40mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 8.25, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"PM03121U","Standard Packaging":"250 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 1" (25mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 8.25, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"PM03300W","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 1/2" (15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 9, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"UM01060V","Standard Packaging":"500 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Coupler 1/2" (15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 10, '/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"UM01020V","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Bush 1"x1/2" (25x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 10, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x15","Size (inch)":"1\"x1/2\"","Item Code":"UM0111010V","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 1/2" (15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 10, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"UM01070V","Standard Packaging":"500 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3/4" (20mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 10, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"PM03740V","Standard Packaging":"500 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 1-1/4" (32mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 10.5, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"PM032201","Standard Packaging":"500 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 1-1/4" (32mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 10.5, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"PM033001","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 10.5, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PM03462V","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC End Cap 3/4" (20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 11, '/images/apollo/apollo-end-cap-pn10-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-end-cap-pn10-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"UM01040W","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Bush 1"x3/4" (25x20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 11, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x20","Size (inch)":"1\"x3/4\"","Item Code":"UM0111010W","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 1" (25mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 11.5, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"PM03250W","Standard Packaging":"600 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 3/4" (20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 12, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"UM01060W","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 1" (25mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 12, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"PM03730W","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 1-1/4" (32mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 12.5, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"PM031101","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 12.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PM03920404","Standard Packaging":"","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 90° 1/2" (15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 12.75, '/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"UM01010V","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 45° 1/2" (15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 13, '/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"UM01190V","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 1-1/2" (40mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 13.5, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"PM03211U","Standard Packaging":"500 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Coupler 3/4" (20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 14, '/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"UM01020W","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 1-1/2" (40mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 15, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"PMN03011U","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Coupler 1/2" (15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 16, '/images/apollo/apollo-reducing-coupler-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"UM01090W0V","Standard Packaging":"450 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Bush 1-1/4"x1" (32x25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 16, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32x25","Size (inch)":"1-1/4\"x1\"","Item Code":"UM01111U01","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 1" (25mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 16, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"PM03740W","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 1-1/2" (40mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 16.5, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"PM03281U","Standard Packaging":"250 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 16.5, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PM034603","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 1/2" (15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 17, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"UM01030V","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 1-1/4" (32mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 17, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"PM037301","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 1-1/2" (40mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 17.5, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"PMN03111U","Standard Packaging":"500 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 45° 3/4" (20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 18, '/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"UM01190W","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 1-1/2" (40mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 19, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"PT01081U","Standard Packaging":"550 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 90° 3/4" (20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 20, '/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"UM01010W","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 2-1/2" (63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 21, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63","Size (inch)":"2-1/2\"","Item Code":"PMN31402","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Elbow 3/4"x1/2" (20x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 22, '/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"UM01100W0V","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 1-1/2" (40mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 22, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"PMN03041U","Standard Packaging":"250 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 2" (50mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 22.5, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"PM03211V","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 22.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03142V","Standard Packaging":"350 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Coupler 1"x1/2" (25x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 23, '/images/apollo/apollo-reducing-coupler-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x15","Size (inch)":"1\"x1/2\"","Item Code":"UM0109010V","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Coupler 1" (25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 23, '/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"UM010201","Standard Packaging":"250 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 1-1/4" (32mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 24, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"PM037401","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 2-1/2" (63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 24, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63","Size (inch)":"2-1/2\"","Item Code":"PMN32102","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 2" (50mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 25, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"PMN03011V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 2-1/2" (63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 25.5, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63","Size (inch)":"2-1/2\"","Item Code":"PMN32902","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 2" (50mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 25.5, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"PM03281V","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 3/4" (20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 26, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"UM01030W","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 1" (25mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 26, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"PM0379010W","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Tee 3/4"x1/2" (20x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 27, '/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"UM01120W0V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 27, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03122V","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 1-1/2" (40mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 28.5, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"PMN03031U","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 45° 1" (25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 29, '/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"UM011901","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 29, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN032304","Standard Packaging":"400 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tank Connector 1/2" (15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 30, '/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"UM01170V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 30, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PM03412V","Standard Packaging":"320 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 90° 1" (25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 31, '/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"UM010101","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 31, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN31303","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Elbow 1"x1/2" (25x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 32, '/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x15","Size (inch)":"1\"x1/2\"","Item Code":"UM0110010V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Union 1/2" (15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 32, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"UM01080V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 32, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03212V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 32, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN31403","Standard Packaging":"230 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 2-1/2" (63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 33, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63","Size (inch)":"2-1/2\"","Item Code":"PMN030102","Standard Packaging":"180 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 2" (50mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 33, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"PMN03041V","Standard Packaging":"125 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 2" (50mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 33, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"PMN03111V","Standard Packaging":"250 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Coupler 1-1/4" (32mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 34, '/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"UM01021U","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 34.5, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03292V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Male Adaptor Plastic Threaded 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 35, '/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03022V","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tank Connector 3/4" (20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 36, '/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"UM01170W","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 1-1/2"x3/4" (40X20mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 36, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40X20","Size (inch)":"1-1/2\"x3/4\"","Item Code":"PM03821U0V","Standard Packaging":"180 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 2-1/2" (63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 36, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63","Size (inch)":"2-1/2\"","Item Code":"PMN32802","Standard Packaging":"170 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 2" (50mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 36, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"PT01091V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 1-1/2" (40mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 37.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"PMN03061U","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 37.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN31404","Standard Packaging":"160 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 37.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN31304","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 39, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN32103","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 2-1/2" (63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 39, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63","Size (inch)":"2-1/2\"","Item Code":"PMN31202","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Tee 1"x1/2" (25x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 40, '/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x15","Size (inch)":"1\"x1/2\"","Item Code":"UM0112010V","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Bush 1-1/2"x1" (40x25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 40, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40x25","Size (inch)":"1-1/2\"x1\"","Item Code":"UM01111V01","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 40, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PMN0308042V","Standard Packaging":"80 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 6"x4" (160x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 40, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160x110","Size (inch)":"6\"x4\"","Item Code":"PMN03450604","Standard Packaging":"9 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 1" (25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 41, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"UM010301","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Tee 1"x3/4" (25x20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 41, '/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x20","Size (inch)":"1\"x3/4\"","Item Code":"UM0112010W","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Bush 2"x1-1/2" (50x40mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 41, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50x40","Size (inch)":"2\"x1-1/2\"","Item Code":"UM0111021V","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 41, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03012V","Standard Packaging":"120 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 2-1/2" (63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 41, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63","Size (inch)":"2-1/2\"","Item Code":"PMN030402","Standard Packaging":"120 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Elbow 1"x3/4" (25x20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 42, '/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x20","Size (inch)":"1\"x3/4\"","Item Code":"UM0110010W","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Union 3/4" (20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 42, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"UM01080W","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 2" (50mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 42, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"PMN03031V","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 2" (50mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 43, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"PT01081V","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Coupler 1-1/2" (40mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 45, '/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"UM01021V","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Step Over Bend 1/2" (15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 45, '/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"UM01230V","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Bush 2"x1" (50x25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 46, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50x25","Size (inch)":"2\"x1\"","Item Code":"UM01110201","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 46.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03052V","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 45° 1-1/4" (32mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 47, '/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"UM01191U","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tank Connector 1" (25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 48, '/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"UM011701","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 3"x2-1/2" (75x63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 48, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75x63","Size (inch)":"3\"x2-1/2\"","Item Code":"PMN03082V02","Standard Packaging":"175 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Male Adaptor Plastic Threaded 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 49, '/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PM039602","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 49, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PT01062V","Standard Packaging":"120 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Coupler 1"x3/4" (25x20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 50, '/images/apollo/apollo-reducing-coupler-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x20","Size (inch)":"1\"x3/4\"","Item Code":"UM0109010W","Standard Packaging":"250 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 90° 1-1/4" (32mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 50, '/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"UM01011U","Standard Packaging":"90 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 4"x3-1/2" (110x90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 50, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x90","Size (inch)":"4\"x3-1/2\"","Item Code":"PMN3080403","Standard Packaging":"80 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 50, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03612V","Standard Packaging":"120 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 52.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03042V","Standard Packaging":"80 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 2" (50mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 52.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"PMN03061V","Standard Packaging":"125 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 52.5, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN032104","Standard Packaging":"160 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 2-1/2" (63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 52.5, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63","Size (inch)":"2-1/2\"","Item Code":"PMN31102","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 54, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03282V","Standard Packaging":"120 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap Threaded 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 54, '/images/apollo/apollo-end-cap-threaded-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-end-cap-threaded-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03262V","Standard Packaging":"225 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 45° 1-1/2" (40mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 55, '/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"UM01191V","Standard Packaging":"80 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tank Connector 1/2" (15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 58, '/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"UM01240V","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 60, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PM034103","Standard Packaging":"220 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Male Adaptor Plastic Threaded 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 61, '/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN030203","Standard Packaging":"80 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 61.5, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03312V","Standard Packaging":"90 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Union 1" (25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 62, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"UM010801","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Coupler 1-1/4"x1" (32x25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 63, '/images/apollo/apollo-reducing-coupler-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32x25","Size (inch)":"1-1/4\"x1\"","Item Code":"UM01091U01","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Bush 2-1/2"x2" (65x50mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 63, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"65x50","Size (inch)":"2-1/2\"x2\"","Item Code":"UM01112V02","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 63, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03112V","Standard Packaging":"105 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 4" (140x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 63, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"140x110","Size (inch)":"4\"","Item Code":"PMN3080504","Standard Packaging":"36 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 64, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN030103","Standard Packaging":"70 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 1-1/4" (32mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 65, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"UM01031U","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 2-1/2" (63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 66, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63","Size (inch)":"2-1/2\"","Item Code":"PM030302","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 6"x4" (160x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 66, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160x110","Size (inch)":"6\"x4\"","Item Code":"PMN03700604","Standard Packaging":"10 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Coupler 2" (50mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 67, '/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"UM010202","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Step Over Bend 3/4" (20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 70, '/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"UM01230W","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 2-1/2" (63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 70, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63","Size (inch)":"2-1/2\"","Item Code":"PM038502","Standard Packaging":"64 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 90° 1-1/2" (40mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 71, '/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"UM01011V","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 1-1/2"x1" (40X25mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 73, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40X25","Size (inch)":"1-1/2\"x1\"","Item Code":"PM03821U0W","Standard Packaging":"180 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 73.5, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PT01092V","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tank Connector 1-1/4" (32mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 75, '/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"UM01171U","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Male Adaptor Plastic Threaded 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 75, '/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PM03962V","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 6"x4" (160x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 75, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160x110","Size (inch)":"6\"x4\"","Item Code":"PMN03080604","Standard Packaging":"36 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 75, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PT010603","Standard Packaging":"80 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 75, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03632V","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tank Connector 3/4" (20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 76, '/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Item Code":"UM01240W","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 1/2"x1/2" (15x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 76, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15x15","Size (inch)":"1/2\"x1/2\"","Item Code":"UMN01140V","Standard Packaging":"350 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Tee 1-1/2"x3/4" (40x20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 78, '/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40x20","Size (inch)":"1-1/2\"x3/4\"","Item Code":"UM01121V0W","Standard Packaging":"50 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 78, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN32803","Standard Packaging":"70 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 3/4"x1/2" (20x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 80, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"UMN01140W0V","Standard Packaging":"280 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Cross Tee 2-1/2"x3/4" (63X20mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 80, '/images/apollo/apollo-cross-tee-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-cross-tee-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63X20","Size (inch)":"2-1/2\"x3/4\"","Item Code":"PM0381020V","Standard Packaging":"96 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 81, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03322V","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 82, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN030403","Standard Packaging":"45 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 2-1/2" (63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 82.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63","Size (inch)":"2-1/2\"","Item Code":"PM030602","Standard Packaging":"68 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 3-1/2"x2-1/2" (90x63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 82.5, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90x63","Size (inch)":"3-1/2\"x2-1/2\"","Item Code":"PMN3080302","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 2-1/2" (63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 83, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63","Size (inch)":"2-1/2\"","Item Code":"PT010802","Standard Packaging":"130 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 85, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03032V","Standard Packaging":"50 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Cross Tee 2-1/2"x1" (63X25mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 85, '/images/apollo/apollo-cross-tee-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-cross-tee-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63X25","Size (inch)":"2-1/2\"x1\"","Item Code":"PM0381020W","Standard Packaging":"96 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 87, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN31203","Standard Packaging":"120 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 87, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN036103","Standard Packaging":"105 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC-X Pipe SCH-80 1/2" (15mm) — Per Meter', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards

Pipe Type: SCH-80
Length: 3mtr/5mtr
Price shown is per meter.', 87.75, '/images/apollo/apollo-cpvc-pipe-schedule-80.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-80.avif'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Pipe Type":"SCH-80","Standard Packaging":"50 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Tee 1-1/2"x1" (40x25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 88, '/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40x25","Size (inch)":"1-1/2\"x1\"","Item Code":"UM01121V01","Standard Packaging":"50 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 45° 2" (50mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 88, '/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"UM011902","Standard Packaging":"50 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC End Cap 2-1/2" (65mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 88, '/images/apollo/apollo-end-cap-pn10-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-end-cap-pn10-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"UM01042V","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Male Adaptor Plastic Threaded 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 89, '/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN030204","Standard Packaging":"40 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 89, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03642V","Standard Packaging":"40 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC-X Pipe SCH-40 1/2" (15mm) — Per Meter', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards

Pipe Type: SCH-40
Length: 3mtr/5mtr
Price shown is per meter.', 89.25, '/images/apollo/apollo-cpvc-pipe-schedule-40.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-40.avif'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Pipe Type":"SCH-40","Standard Packaging":"50 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 1/2"x1/2" (15x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 90, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15x15","Size (inch)":"1/2\"x1/2\"","Item Code":"UMN01160V","Standard Packaging":"240 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 90, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PM03852V","Standard Packaging":"45 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 3-1/2"x3" (90x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 90, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90x75","Size (inch)":"3-1/2\"x3\"","Item Code":"PMN0308032V","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 90, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN033403","Standard Packaging":"75 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Union 1-1/4" (32mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 92, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"UM01081U","Standard Packaging":"80 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap Threaded 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 93, '/images/apollo/apollo-end-cap-threaded-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-end-cap-threaded-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN32603","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 2-1/2"x3/4" (63X20mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 94, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63X20","Size (inch)":"2-1/2\"x3/4\"","Item Code":"PM0315020V","Standard Packaging":"39 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 94, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03332V","Standard Packaging":"40 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 1-1/2" (40mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 96, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"UM01031V","Standard Packaging":"40 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Ball Valve 1/2" (15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 97, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15","Size (inch)":"1/2\"","Item Code":"UMN01220V","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Step Over Bend 1" (25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 98, '/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"UM012301","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 2-1/2"x1" (63X25mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 98, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63X25","Size (inch)":"2-1/2\"x1\"","Item Code":"PM0315020W","Standard Packaging":"39 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 99, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN030104","Standard Packaging":"36 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 5" (125mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 99, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"125","Size (inch)":"5\"","Item Code":"PMN03214V","Standard Packaging":"50 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 3/4"x1/2" (20x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 100, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"UMN01160W0V","Standard Packaging":"180 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Elbow 3-1/2"x2-1/2" (90X63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 100, '/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90X63","Size (inch)":"3-1/2\"x2-1/2\"","Item Code":"PM03800302","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 100, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03682V","Standard Packaging":"70 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 1"x1/2" (25X15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 101, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25X15","Size (inch)":"1\"x1/2\"","Item Code":"UMN01141V","Standard Packaging":"72 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tank Connector 1-1/2" (40mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 102, '/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"UM01171V","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 2-1/2" (65mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 102, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"UM01062V","Standard Packaging":"48 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Bush 3"x2-1/2" (80x65mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 102, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"80x65","Size (inch)":"3\"x2-1/2\"","Item Code":"UM0111032V","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 103, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PMN0362042V","Standard Packaging":"90 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 90° 2" (50mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 105, '/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"UM010102","Standard Packaging":"40 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Male Adaptor Plastic Threaded 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 105, '/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PM039603","Standard Packaging":"56 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap (140mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 105, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"140","Size (inch)":"","Item Code":"PMN32105","Standard Packaging":"40 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 105, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN033103","Standard Packaging":"90 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 2-1/2" (65mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 106, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"UM01072V","Standard Packaging":"48 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tank Connector 1" (25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 108, '/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"UM012401","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 6" (160mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 108, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160","Size (inch)":"6\"","Item Code":"PMN031406","Standard Packaging":"72 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 108, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03762V","Standard Packaging":"55 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 1/2"x1/2" (15x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 109, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15x15","Size (inch)":"1/2\"x1/2\"","Item Code":"UMN01150V","Standard Packaging":"175 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 110, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN030503","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 110, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PMN0335042V","Standard Packaging":"90 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 111, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMNN03422V","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Coupler 2-1/2" (65mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 112, '/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"UM01022V","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 112, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03062V","Standard Packaging":"45 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 112, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN031103","Standard Packaging":"108 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4"x2-1/2" (110x63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 112.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x63","Size (inch)":"4\"x2-1/2\"","Item Code":"PMN03200402","Standard Packaging":"54 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 3/4"x1/2" (20x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 113, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"UMN01150W0V","Standard Packaging":"125 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC-X Pipe SCH-80 3/4" (20mm) — Per Meter', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards

Pipe Type: SCH-80
Length: 3mtr/5mtr
Price shown is per meter.', 114.75, '/images/apollo/apollo-cpvc-pipe-schedule-80.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-80.avif'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Pipe Type":"SCH-80","Standard Packaging":"40 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 3/4"x3/4" (20x20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 116, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20x20","Size (inch)":"3/4\"x3/4\"","Item Code":"UMN01140W","Standard Packaging":"240 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 2-1/2"x1-1/4" (63X32mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 117, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63X32","Size (inch)":"2-1/2\"x1-1/4\"","Item Code":"PM03150201","Standard Packaging":"39 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC-X Pipe SCH-40 3/4" (20mm) — Per Meter', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards

Pipe Type: SCH-40
Length: 3mtr/5mtr
Price shown is per meter.', 117, '/images/apollo/apollo-cpvc-pipe-schedule-40.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-40.avif'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20","Size (inch)":"3/4\"","Pipe Type":"SCH-40","Standard Packaging":"40 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 1"x1/2" (25x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 120, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x15","Size (inch)":"1\"x1/2\"","Item Code":"UMN0116010V","Standard Packaging":"125 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 120, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03492V","Standard Packaging":"45 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 120, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03692V","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 120, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PMN0320042V","Standard Packaging":"54 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 1/2"x1/2" (15x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 122, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"15x15","Size (inch)":"1/2\"x1/2\"","Item Code":"UMN01130V","Standard Packaging":"300 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 122, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN030303","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 3/4"x1/2" (20x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 123, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20x15","Size (inch)":"3/4\"x1/2\"","Item Code":"UMN01130W0V","Standard Packaging":"280 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap Threaded 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 123, '/images/apollo/apollo-end-cap-threaded-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-end-cap-threaded-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN32604","Standard Packaging":"90 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 124, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03662V","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Bush 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 125, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PT010703","Standard Packaging":"55 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 125, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PT010604","Standard Packaging":"50 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4"x2-1/2" (110x63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 125, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x63","Size (inch)":"4\"x2-1/2\"","Item Code":"PM03890402","Standard Packaging":"56 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Bush 3"x2" (80x50mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 127.5, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"80x50","Size (inch)":"3\"x2\"","Item Code":"UM01110302","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 129, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN32804","Standard Packaging":"36 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 130, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PM038503","Standard Packaging":"49 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 131, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN030404","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4"x3-1/2" (110x90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 131, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x90","Size (inch)":"4\"x3-1/2\"","Item Code":"PMN03200403","Standard Packaging":"48 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4"x3-1/2" (110x90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 131, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x90","Size (inch)":"4\"x3-1/2\"","Item Code":"PM03890403","Standard Packaging":"27 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 132, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMNN03432V","Standard Packaging":"50 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 3"x3/4" (75X20mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 133, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75X20","Size (inch)":"3\"x3/4\"","Item Code":"PM03152V0V","Standard Packaging":"26 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 135, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03372V","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 3/4"x3/4" (20x20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 137, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20x20","Size (inch)":"3/4\"x3/4\"","Item Code":"UMN01160W0W","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 3"x1" (75X25mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 137, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75X25","Size (inch)":"3\"x1\"","Item Code":"PM03152V0W","Standard Packaging":"26 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 138, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN036303","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Elbow 4"x2-1/2" (110X63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 140, '/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110X63","Size (inch)":"4\"x2-1/2\"","Item Code":"PM03800402","Standard Packaging":"32 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 140, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PM0389042V","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 141, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMNN033404","Standard Packaging":"40 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Bush 4"x3-1/2" (110x90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 142, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x90","Size (inch)":"4\"x3-1/2\"","Item Code":"PMN3270403","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Tee 2"x1" (50x25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 143, '/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50x25","Size (inch)":"2\"x1\"","Item Code":"UM01120201","Standard Packaging":"24 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tank Connector 2" (50mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 144, '/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"UM011702","Standard Packaging":"50 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 144, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03722V","Standard Packaging":"72 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 1"x1/2" (25x15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 147, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x15","Size (inch)":"1\"x1/2\"","Item Code":"UMN0115010V","Standard Packaging":"75 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC End Cap 3" (80mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 147, '/images/apollo/apollo-end-cap-pn10-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-end-cap-pn10-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"UM010403","Standard Packaging":"40 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Tee 2"x1-1/2" (50x40mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 149, '/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50x40","Size (inch)":"2\"x1-1/2\"","Item Code":"UM0112021V","Standard Packaging":"24 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Union 1-1/2" (40mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 149, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Item Code":"UM01081V","Standard Packaging":"50 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 150, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03472V","Standard Packaging":"42 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 151, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03672V","Standard Packaging":"25 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 3/4"x3/4" (20x20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 152, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20x20","Size (inch)":"3/4\"x3/4\"","Item Code":"UMN011501W0W","Standard Packaging":"100 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 153, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN030603","Standard Packaging":"45 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 153, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN031204","Standard Packaging":"72 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 1"x1/2" (25X15mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 155, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25X15","Size (inch)":"1\"x1/2\"","Item Code":"UM0113010V","Standard Packaging":"150 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Step Over Bend 1-1/4" (32mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 155, '/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Item Code":"UM01231U","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Elbow 4"x3-1/2" (110X90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 156, '/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110X90","Size (inch)":"4\"x3-1/2\"","Item Code":"PMN03100403","Standard Packaging":"40 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Coupler 3" (80mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 157, '/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"UM010203","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 2" (50mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 160, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"UM010302","Standard Packaging":"24 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 3/4"x3/4" (20x20mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 161, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"20x20","Size (inch)":"3/4\"x3/4\"","Item Code":"UMN01130W","Standard Packaging":"200 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 3" (80mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 162, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"UM010603","Standard Packaging":"36 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 162, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03382V","Standard Packaging":"25 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 3"x1-1/4" (75X32mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 164, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75X32","Size (inch)":"3\"x1-1/4\"","Item Code":"PM03152V01","Standard Packaging":"26 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 3" (80mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 165, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"UM010703","Standard Packaging":"36 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 165, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN031104","Standard Packaging":"72 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 165, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PT01102V","Standard Packaging":"25 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4"x4" (110x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 165, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x110","Size (inch)":"4\"x4\"","Item Code":"PMN03200404","Standard Packaging":"45 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4"x4" (110x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 165, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x110","Size (inch)":"4\"x4\"","Item Code":"PM03890404","Standard Packaging":"36 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC-X Pipe SCH-80 1" (25mm) — Per Meter', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards

Pipe Type: SCH-80
Length: 3mtr/5mtr
Price shown is per meter.', 171, '/images/apollo/apollo-cpvc-pipe-schedule-80.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-80.avif'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Pipe Type":"SCH-80","Standard Packaging":"25 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC-X Pipe SCH-40 1" (25mm) — Per Meter', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards

Pipe Type: SCH-40
Length: 3mtr/5mtr
Price shown is per meter.', 174, '/images/apollo/apollo-cpvc-pipe-schedule-40.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-40.avif'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Pipe Type":"SCH-40","Standard Packaging":"25 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 45° 2-1/2" (65mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 175, '/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"UM01192V","Standard Packaging":"32 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Bush 4"x3" (100x80mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 175, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"100x80","Size (inch)":"4\"x3\"","Item Code":"UM01110403","Standard Packaging":"24 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Bush 4"x2" (100x50mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 177, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"100x50","Size (inch)":"4\"x2\"","Item Code":"UM01110402","Standard Packaging":"24 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 179, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PMN0345042V","Standard Packaging":"24 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 179, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN036403","Standard Packaging":"48 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 90° 2-1/2" (65mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 180, '/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"UM01012V","Standard Packaging":"18 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 180, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PMN0370042V","Standard Packaging":"27 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 4"x2-1/2" (110x63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 186, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x63","Size (inch)":"4\"x2-1/2\"","Item Code":"PMN03090402","Standard Packaging":"38 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 187.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN032404","Standard Packaging":"36 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 188.25, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN033303","Standard Packaging":"48 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 189, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN036803","Standard Packaging":"36 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Reducing Bush 4"x2-1/2" (100x65mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 190, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"100x65","Size (inch)":"4\"x2-1/2\"","Item Code":"UM0111042V","Standard Packaging":"24 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 192, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PM038504","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 6" (160mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 192, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160","Size (inch)":"6\"","Item Code":"PMN32106","Standard Packaging":"25 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 195, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN030304","Standard Packaging":"35 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 195, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PT01202V","Standard Packaging":"20 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 202, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PMN0309042V","Standard Packaging":"37 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 208, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN034203","Standard Packaging":"34 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 210, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PM0377042V","Standard Packaging":"","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 1"x1" (25x25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 214, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x25","Size (inch)":"1\"x1\"","Item Code":"UMN011401","Standard Packaging":"120 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC End Cap 4" (100mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 217, '/images/apollo/apollo-end-cap-pn10-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-end-cap-pn10-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"100","Size (inch)":"4\"","Item Code":"UM010404","Standard Packaging":"32 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 218, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PMN0371042V","Standard Packaging":"21 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Union 2" (50mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 220, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Item Code":"UM010802","Standard Packaging":"28 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 6" (160mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 225, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160","Size (inch)":"6\"","Item Code":"PT010506","Standard Packaging":"20 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Bush 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 225, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PT010704","Standard Packaging":"25 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC-X Pipe SCH-80 1-1/4" (32mm) — Per Meter', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards

Pipe Type: SCH-80
Length: 3mtr/5mtr
Price shown is per meter.', 227.25, '/images/apollo/apollo-cpvc-pipe-schedule-80.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-80.avif'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Pipe Type":"SCH-80","Standard Packaging":"15 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC-X Pipe SCH-40 1-1/4" (32mm) — Per Meter', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards

Pipe Type: SCH-40
Length: 3mtr/5mtr
Price shown is per meter.', 231.75, '/images/apollo/apollo-cpvc-pipe-schedule-40.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-40.avif'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32","Size (inch)":"1-1/4\"","Pipe Type":"SCH-40","Standard Packaging":"15 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 233, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PMN036042V","Standard Packaging":"20 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 235, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN036903","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 4"x2-1/2" (110x63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 237, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x63","Size (inch)":"4\"x2-1/2\"","Item Code":"PMN3080402","Standard Packaging":"80 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 237, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PMN0373042V","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 2-1/2" (65mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 240, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"UM01032V","Standard Packaging":"16 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 1"x1" (25x25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 241, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x25","Size (inch)":"1\"x1\"","Item Code":"UMN011301","Standard Packaging":"120 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 6" (160mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 245, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160","Size (inch)":"6\"","Item Code":"PT010606","Standard Packaging":"25 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Coupler 4" (100mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 247, '/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"100","Size (inch)":"4\"","Item Code":"UM010204","Standard Packaging":"16 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 250, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN37303","Standard Packaging":"36 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 4"x2" (110X50mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 250, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110X50","Size (inch)":"4\"x2\"","Item Code":"PM0387041V","Standard Packaging":"40 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 250.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN030604","Standard Packaging":"20 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 252, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PT011603","Standard Packaging":"20 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 255, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PMN0348042V","Standard Packaging":"24 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 1"x1" (25x25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 256, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x25","Size (inch)":"1\"x1\"","Item Code":"UMN01160101","Standard Packaging":"75 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 45° 3" (80mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 262, '/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"UM011903","Standard Packaging":"20 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Male Adaptor Plastic Threaded (140mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 265, '/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"140","Size (inch)":"","Item Code":"PM031605","Standard Packaging":"16 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 265, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN037204","Standard Packaging":"","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 268, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN034303","Standard Packaging":"28 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 90° 3" (80mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 270, '/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"UM010103","Standard Packaging":"16 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap (180mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 270, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"180","Size (inch)":"","Item Code":"PM032107","Standard Packaging":"18 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 270, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PT011503","Standard Packaging":"20 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 270, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN037203","Standard Packaging":"40 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 270, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PM038604","Standard Packaging":"28 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 4" (100mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 273, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"100","Size (inch)":"4\"","Item Code":"UM010704","Standard Packaging":"12 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 4"x2-1/2" (110x63mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 275, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x63","Size (inch)":"4\"x2-1/2\"","Item Code":"PT01180402","Standard Packaging":"16 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Plastic Threaded 4" (100mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 277, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"100","Size (inch)":"4\"","Item Code":"UM010604","Standard Packaging":"18 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 280, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PM035104","Standard Packaging":"28 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC-X Pipe SCH-80 1-1/2" (40mm) — Per Meter', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards

Pipe Type: SCH-80
Length: 3mtr/5mtr
Price shown is per meter.', 281.25, '/images/apollo/apollo-cpvc-pipe-schedule-80.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-80.avif'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Pipe Type":"SCH-80","Standard Packaging":"10 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 285, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PM034703","Standard Packaging":"40 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4"x4" (110X110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 285, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110X110","Size (inch)":"4\"x4\"","Item Code":"PM03900404","Standard Packaging":"18 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC-X Pipe SCH-40 1-1/2" (40mm) — Per Meter', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards

Pipe Type: SCH-40
Length: 3mtr/5mtr
Price shown is per meter.', 286.5, '/images/apollo/apollo-cpvc-pipe-schedule-40.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-40.avif'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40","Size (inch)":"1-1/2\"","Pipe Type":"SCH-40","Standard Packaging":"10 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 1"x1" (25x25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 297, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25x25","Size (inch)":"1\"x1\"","Item Code":"UMN01150101","Standard Packaging":"60 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 310, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PT011703","Standard Packaging":"15 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 312, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PMN37403","Standard Packaging":"24 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 6"x4" (160x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 313, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160x110","Size (inch)":"6\"x4\"","Item Code":"PMN03620604","Standard Packaging":"20 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 4"x4" (110x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 313, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x110","Size (inch)":"4\"x4\"","Item Code":"PMN03170404","Standard Packaging":"13 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 4"x3" (110x75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 315, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x75","Size (inch)":"4\"x3\"","Item Code":"PM0350042V","Standard Packaging":"24 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 3-1/2" (90mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 322.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"90","Size (inch)":"3-1/2\"","Item Code":"PT011403","Standard Packaging":"18 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 6"x4" (160x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 331, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160x110","Size (inch)":"6\"x4\"","Item Code":"PMN03350604","Standard Packaging":"40 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 342, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN37304","Standard Packaging":"18 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Bush 6"x4" (160x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 345, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160x110","Size (inch)":"6\"x4\"","Item Code":"PMN3270604","Standard Packaging":"27 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 3" (75mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 348, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"75","Size (inch)":"3\"","Item Code":"PMN03652V","Standard Packaging":"140 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 1-1/4"x1-1/4" (32x32mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 350, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32x32","Size (inch)":"1-1/4\"x1-1/4\"","Item Code":"UMN01141U","Standard Packaging":"84 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 3" (80mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 372, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"UM010303","Standard Packaging":"10 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC-X Pipe SCH-80 2" (50mm) — Per Meter', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards

Pipe Type: SCH-80
Length: 3mtr/5mtr
Price shown is per meter.', 387, '/images/apollo/apollo-cpvc-pipe-schedule-80.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-80.avif'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Pipe Type":"SCH-80","Standard Packaging":"10 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 5"x4" (125x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 390, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"125x110","Size (inch)":"5\"x4\"","Item Code":"PMN03174V04","Standard Packaging":"12 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC-X Pipe SCH-40 2" (50mm) — Per Meter', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards

Pipe Type: SCH-40
Length: 3mtr/5mtr
Price shown is per meter.', 394.5, '/images/apollo/apollo-cpvc-pipe-schedule-40.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-40.avif'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50","Size (inch)":"2\"","Pipe Type":"SCH-40","Standard Packaging":"10 per bundle","Price Unit":"Per Meter","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 6" (160mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 397.5, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160","Size (inch)":"6\"","Item Code":"PMNN033406","Standard Packaging":"16 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Elbow 6"x4" (160X110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 400, '/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160X110","Size (inch)":"6\"x4\"","Item Code":"PM03800604","Standard Packaging":"17 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Male Adaptor Plastic Threaded 6" (160mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 405, '/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160","Size (inch)":"6\"","Item Code":"PM031606","Standard Packaging":"12 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 45° 4" (100mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 412, '/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"100","Size (inch)":"4\"","Item Code":"UM011904","Standard Packaging":"10 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee (140mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 435, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"140","Size (inch)":"","Item Code":"PMN030605","Standard Packaging":"10 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap 8" (200mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 465, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"200","Size (inch)":"8\"","Item Code":"PMN32108","Standard Packaging":"10 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Elbow 90° 4" (100mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 472, '/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"100","Size (inch)":"4\"","Item Code":"UM010104","Standard Packaging":"6 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 517.5, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMN37404","Standard Packaging":"12 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 1-1/2"x1-1/2" (40x40mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 520, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"40x40","Size (inch)":"1-1/2\"x1-1/2\"","Item Code":"UMN01131V","Standard Packaging":"48 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 4"x4" (110x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 525, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x110","Size (inch)":"4\"x4\"","Item Code":"PMN03180404","Standard Packaging":"13 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 5"x4" (125x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 532, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"125x110","Size (inch)":"5\"x4\"","Item Code":"PM03184V04","Standard Packaging":"10 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 1-1/4"x1-1/4" (32x32mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 540, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"32x32","Size (inch)":"1-1/4\"x1-1/4\"","Item Code":"UMN01131U","Standard Packaging":"72 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 6"x4" (160X110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 550, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160X110","Size (inch)":"6\"x4\"","Item Code":"PM03880604","Standard Packaging":"7 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Union 2-1/2" (65mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 577, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"UM01082V","Standard Packaging":"20 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 4"x4" (110x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 607, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110x110","Size (inch)":"4\"x4\"","Item Code":"PMN03190404","Standard Packaging":"10 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 5"x4" (125x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 622, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"125x110","Size (inch)":"5\"x4\"","Item Code":"PMN03194V04","Standard Packaging":"10 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 10"x6" (250x160mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 625, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"250x160","Size (inch)":"10\"x6\"","Item Code":"PM03831006","Standard Packaging":"10 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 6" (160mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 654, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160","Size (inch)":"6\"","Item Code":"PMN030606","Standard Packaging":"8 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 4" (100mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 675, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"100","Size (inch)":"4\"","Item Code":"UM010304","Standard Packaging":"6 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR End Cap (225mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 675, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"225","Size (inch)":"","Item Code":"PMN32109","Standard Packaging":"8 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 2"x2" (50x50mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 680, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50x50","Size (inch)":"2\"x2\"","Item Code":"UM011402","Standard Packaging":"30 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 6"x4" (160x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 697, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160x110","Size (inch)":"6\"x4\"","Item Code":"PMN03710604","Standard Packaging":"8 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Union 3" (80mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 787, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"UM010803","Standard Packaging":"12 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Coupler 10" (250mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 800, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"250","Size (inch)":"10\"","Item Code":"PT010610","Standard Packaging":"6 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Ball Valve 1" (25mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 817, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"25","Size (inch)":"1\"","Item Code":"UMN012201","Standard Packaging":"","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Male Adaptor Brass Threaded 2"x2" (50x50mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 840, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"50x50","Size (inch)":"2\"x2\"","Item Code":"UMN011302","Standard Packaging":"36 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 6"x4" (160x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 847, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"160x110","Size (inch)":"6\"x4\"","Item Code":"PMN03360604","Standard Packaging":"8 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Male Adaptor Plastic Threaded 8" (200mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 990, '/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"200","Size (inch)":"8\"","Item Code":"PMN031608","Standard Packaging":"5 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Coupler 4" (110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 1011, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"110","Size (inch)":"4\"","Item Code":"PMNN033804","Standard Packaging":"16 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve (180mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 1110, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"180","Size (inch)":"","Item Code":"PM030307","Standard Packaging":"5 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 2-1/2" (65mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 1220, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"UM01202V","Standard Packaging":"16 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Tee 3" (80mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 1400, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"UM012004","Standard Packaging":"12 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 8"x4" (200x110mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 1500, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"200x110","Size (inch)":"8\"x4\"","Item Code":"PT01030804","Standard Packaging":"3 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 8" (200mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 1560, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"200","Size (inch)":"8\"","Item Code":"PMN030608","Standard Packaging":"3 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 8"x6" (200x160mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 1600, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"200x160","Size (inch)":"8\"x6\"","Item Code":"PT01030806","Standard Packaging":"3 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 8" (200mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 1630, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"200","Size (inch)":"8\"","Item Code":"PT010208","Standard Packaging":"4 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Union 4" (100mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 1862, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"100","Size (inch)":"4\"","Item Code":"UM010804","Standard Packaging":"8 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Coupler 2-1/2" (65mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 2150, '/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"UM01182V","Standard Packaging":"16 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 8" (200x140mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 2400, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"200x140","Size (inch)":"8\"","Item Code":"PM03830805","Standard Packaging":"2 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Ball Valve 10" (250mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 2460, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"250","Size (inch)":"10\"","Item Code":"PM030310","Standard Packaging":"3 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Tee 2-1/2"x1-1/4" (63X32mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 2460, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"63X32","Size (inch)":"2-1/2\"x1-1/4\"","Item Code":"PM03820201","Standard Packaging":"","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Coupler 3" (80mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 2800, '/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"UM011804","Standard Packaging":"12 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee 10" (250mm)', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 3180, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"250","Size (inch)":"10\"","Item Code":"PM030610","Standard Packaging":"1 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Ball Valve 2-1/2" (65mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 4125, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"65","Size (inch)":"2-1/2\"","Item Code":"UTP01222V","Standard Packaging":"4 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Ball Valve 3" (80mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 6075, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"80","Size (inch)":"3\"","Item Code":"UTP012203","Standard Packaging":"2 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo uPVC Ball Valve 4" (100mm)', 'APL Apollo uPVC plumbing products are designed for residential and commercial water distribution, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy to install with solvent-weld joints
- Conforms to IS:4985 standards', 10275, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Size (mm)":"100","Size (inch)":"4\"","Item Code":"UTP012204","Standard Packaging":"2 pcs/box","GST":"18%"}'::jsonb, v_sub1, 100, true);

END $$;
