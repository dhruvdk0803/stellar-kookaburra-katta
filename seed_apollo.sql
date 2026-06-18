-- APL Apollo building-material products scraped from makankidukan.com
-- Creates an "Apollo" parent category with subcategories, then inserts all products.
-- Safe to re-run: categories are guarded; delete existing Apollo products first if re-seeding.

DO $$
DECLARE
  v_parent UUID;
  v_sub0 UUID;
  v_sub1 UUID;
  v_sub2 UUID;
  v_sub3 UUID;
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

  INSERT INTO products (name, description, price, image_url, images, specs, category_id, stock, is_active) VALUES
  ('Apollo Ball Valve SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 150, '/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-ball-valve-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Bend 45 Degree SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 66, '/images/apollo/apollo-bend-45-degree-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-bend-45-degree-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Bend 45 Degree SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 73.5, '/images/apollo/apollo-bend-45-degree-swr-fitting-with-ring-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-bend-45-degree-swr-fitting-with-ring-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Bend 45 Degree SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 66, '/images/apollo/apollo-bend-45-degree-swr-fitting-with-rings-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-bend-45-degree-swr-fitting-with-rings-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Bend 87.5 Degree SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 75, '/images/apollo/apollo-bend-875-degree-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-bend-875-degree-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Bend 87.5 Degree SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 75, '/images/apollo/apollo-bend-875-degree-swr-fitting-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-bend-875-degree-swr-fitting-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Bend 87.5 Degree SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 81, '/images/apollo/apollo-bend-875-degree-swr-fitting-with-ring-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-bend-875-degree-swr-fitting-with-ring-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Bend 87.5 Degree SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 81, '/images/apollo/apollo-bend-875-degree-swr-fitting-with-rings-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-bend-875-degree-swr-fitting-with-rings-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Bend 87.5 Degree With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 89, '/images/apollo/apollo-bend-875-degree-with-door-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-bend-875-degree-with-door-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Bend 87.5 Degree With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 89, '/images/apollo/apollo-bend-875-degree-with-door-swr-fitting-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-bend-875-degree-with-door-swr-fitting-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Bend 87.5 Degree With Door SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 94, '/images/apollo/apollo-bend-875-degree-with-door-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-bend-875-degree-with-door-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Bend 87.5 Degree Wiyh Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 94, '/images/apollo/apollo-bend-875-degree-with-door-swr-fitting-with-rings-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-bend-875-degree-with-door-swr-fitting-with-rings-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Cleaning Pipe With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 108, '/images/apollo/apollo-cleaning-pipe-with-door-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-cleaning-pipe-with-door-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Cleaning Pipe (With Door) SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 120, '/images/apollo/apollo-cleaning-pipe-with-door-swr-fitting-with-ring-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-cleaning-pipe-with-door-swr-fitting-with-ring-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Cleaning Pipe With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 120, '/images/apollo/apollo-cleaning-pipe-with-door-swr-fitting-with-rings-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-cleaning-pipe-with-door-swr-fitting-with-rings-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Compact Long Handle Ball Valve Plain uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 108, '/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-plain-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Solvent Weld","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Compact Long Handle Ball Valve Threaded uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 108, '/images/apollo/apollo-compact-long-handle-ball-valve-threaded-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-compact-long-handle-ball-valve-threaded-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Connection":"Threaded","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Concealed Valve Swept SDR CPVC Fitting Sch 40 &Amp; 80', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1800, '/images/apollo/apollo-concealed-valve-swept-sdr-cpvc-fitting-sch-40-80.jpg', ARRAY['/images/apollo/apollo-concealed-valve-swept-sdr-cpvc-fitting-sch-40-80.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Schedule":"SCH 40","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Coupler 6kg uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 16.5, '/images/apollo/apollo-coupler-6kg-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-6kg-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Coupler SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 13, '/images/apollo/apollo-coupler-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-coupler-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Coupler SDR CPVC Fitting Sch 40 &Amp; 80', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 522, '/images/apollo/apollo-coupler-sdr-cpvc-fitting-sch-40-80.webp', ARRAY['/images/apollo/apollo-coupler-sdr-cpvc-fitting-sch-40-80.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Schedule":"SCH 40","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Coupler SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 50, '/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Coupler SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 61.5, '/images/apollo/apollo-coupler-swr-fitting-with-ring-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-coupler-swr-fitting-with-ring-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Couplre Pn10 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 5.25, '/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-couplre-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Couplre Pn4 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 440, '/images/apollo/apollo-couplre-pn4-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-couplre-pn4-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC Pipe Schedule 40', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 3690, '/images/apollo/apollo-cpvc-pipe-schedule-40.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-40.avif'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC Pipe Schedule 80', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 4794, '/images/apollo/apollo-cpvc-pipe-schedule-80.avif', ARRAY['/images/apollo/apollo-cpvc-pipe-schedule-80.avif'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC Pipe SDR 11', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 279, '/images/apollo/apollo-cpvc-pipe-sdr-11.webp', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-11.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC Pipe SDR 13.5', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 243, '/images/apollo/apollo-cpvc-pipe-sdr-135.jpg', ARRAY['/images/apollo/apollo-cpvc-pipe-sdr-135.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo CPVC Solvent Cement Tin', 'APL Apollo PVC solvent cement provides strong, leak-proof solvent-welded joints for CPVC/uPVC pipes and fittings. Fast-setting and high-strength for reliable plumbing connections.', 165, '/images/apollo/apollo-cpvc-solvent-cement-tin.jpg', ARRAY['/images/apollo/apollo-cpvc-solvent-cement-tin.jpg'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Joint Type":"Solvent Weld","GST":"18%"}'::jsonb, v_sub2, 100, true),
  ('Apollo CPVC Solvent Cement Tube', 'APL Apollo PVC solvent cement provides strong, leak-proof solvent-welded joints for CPVC/uPVC pipes and fittings. Fast-setting and high-strength for reliable plumbing connections.', 48, '/images/apollo/apollo-cpvc-solvent-cement-tube.jpg', ARRAY['/images/apollo/apollo-cpvc-solvent-cement-tube.jpg'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Joint Type":"Solvent Weld","GST":"18%"}'::jsonb, v_sub2, 100, true),
  ('Apollo Cross Tee SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 60, '/images/apollo/apollo-cross-tee-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-cross-tee-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Cross Tee uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 80, '/images/apollo/apollo-cross-tee-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-cross-tee-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Door Cap SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 30, '/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Door Cap SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 30, '/images/apollo/apollo-door-cap-swr-fitting-with-rings-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-door-cap-swr-fitting-with-rings-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Double Tee Self Fit With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 285, '/images/apollo/apollo-double-tee-self-fit-with-door-swr-fitting-self-fit-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-double-tee-self-fit-with-door-swr-fitting-self-fit-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Double Tee SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 322.5, '/images/apollo/apollo-double-tee-swr-fitting-with-ring-upvc-pipe-fittings.png', ARRAY['/images/apollo/apollo-double-tee-swr-fitting-with-ring-upvc-pipe-fittings.png'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Double Tee SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 322.5, '/images/apollo/apollo-double-tee-swr-fitting-with-rings-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-double-tee-swr-fitting-with-rings-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Echo Water Tank 3 Layer', 'APL Apollo water storage tanks provide safe, hygienic storage of drinking water with multi-layer construction that protects water from sunlight and algae growth.

Key features:
- Multi-layer rotational moulded construction
- UV stabilised — protects against sunlight
- Food-grade, non-toxic inner layer
- Leak-proof and rust-free
- Long service life', 5100, '/images/apollo/apollo-echo-water-tank-3-layer.jpg', ARRAY['/images/apollo/apollo-echo-water-tank-3-layer.jpg'], '{"Brand":"APL Apollo","Category":"Water Tanks","GST":"18%"}'::jsonb, v_sub3, 100, true),
  ('Apollo Elbow 45 Degree SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 27, '/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Elbow 45 Degree SDR CPVC Fitting Sch 40 &Amp; 80', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1005, '/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting-sch-40-80.webp', ARRAY['/images/apollo/apollo-elbow-45-degree-sdr-cpvc-fitting-sch-40-80.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Schedule":"SCH 40","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Elbow 90 Degree SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 18, '/images/apollo/apollo-elbow-90-degree-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-elbow-90-degree-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Elbow Pn10 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 8, '/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Elbow Pn6 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 28.5, '/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo End Cap Pn10 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 4, '/images/apollo/apollo-end-cap-pn10-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-end-cap-pn10-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo End Cap Pn4 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 24, '/images/apollo/apollo-end-cap-pn4-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-end-cap-pn4-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo End Cap Pn6 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 13.5, '/images/apollo/apollo-end-cap-pn6-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-end-cap-pn6-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo End Cap SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 9, '/images/apollo/apollo-end-cap-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-end-cap-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo End Cap Threaded uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 54, '/images/apollo/apollo-end-cap-threaded-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-end-cap-threaded-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Connection":"Threaded","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo End Plug Threaded SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 20, '/images/apollo/apollo-end-plug-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-end-plug-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Connection":"Threaded","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Female Adaptor Brass Threaded SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 161, '/images/apollo/apollo-female-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-female-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Connection":"Threaded","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Female Adaptor Plastic Threaded SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 21, '/images/apollo/apollo-female-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-female-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Connection":"Threaded","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Female Adaptor Plastic Threaded SDR CPVC Fitting Sch 40 &Amp; 80', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 528, '/images/apollo/apollo-female-adaptor-plastic-threaded-sdr-cpvc-fitting-sch-40-80.jpg', ARRAY['/images/apollo/apollo-female-adaptor-plastic-threaded-sdr-cpvc-fitting-sch-40-80.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Schedule":"SCH 40","Connection":"Threaded","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Female Adaptor With Hexaganol Brass Inserts SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 368, '/images/apollo/apollo-female-adaptor-with-hexaganol-brass-inserts-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-female-adaptor-with-hexaganol-brass-inserts-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Female Adaptor With Hexaganol Brass Inserts SDR CPVC Fitting Sch 40 &Amp; 80', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1650, '/images/apollo/apollo-female-adaptor-with-hexaganol-brass-inserts-sdr-cpvc-fitting-sch-40-80.jpg', ARRAY['/images/apollo/apollo-female-adaptor-with-hexaganol-brass-inserts-sdr-cpvc-fitting-sch-40-80.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Schedule":"SCH 40","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Female Elbow Brass Threaded SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 78, '/images/apollo/apollo-female-elbow-brass-threaded-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-female-elbow-brass-threaded-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Connection":"Threaded","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Female Tee Brass Threaded SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 111, '/images/apollo/apollo-female-tee-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-female-tee-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Connection":"Threaded","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Female Threaded Adaptor (Mta) Pn6 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 12.5, '/images/apollo/apollo-female-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-female-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Connection":"Threaded","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Female Threaded Adaptor Pn10 Brass uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 66, '/images/apollo/apollo-female-threaded-adaptor-pn10-brass-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-female-threaded-adaptor-pn10-brass-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Connection":"Threaded","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Female Threaded Adptor Pn10 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 6.75, '/images/apollo/apollo-female-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-female-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Connection":"Threaded","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Female Threaded Elbow Pn10 Brass uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 69, '/images/apollo/apollo-female-threaded-elbow-pn10-brass-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-female-threaded-elbow-pn10-brass-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Connection":"Threaded","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Female Threaded Tee Pn10 Brass uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 77, '/images/apollo/apollo-female-threaded-tee-pn10-brass-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-female-threaded-tee-pn10-brass-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Connection":"Threaded","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Gully Trap SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 550, '/images/apollo/apollo-gully-trap-swr-fitting-self-fit-upvc-pipe-fittings.png', ARRAY['/images/apollo/apollo-gully-trap-swr-fitting-self-fit-upvc-pipe-fittings.png'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Height Raiser SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 250, '/images/apollo/apollo-height-raiser-swr-fitting-self-fit-upvc-pipe-fittings.png', ARRAY['/images/apollo/apollo-height-raiser-swr-fitting-self-fit-upvc-pipe-fittings.png'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Horn Shoe With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 270, '/images/apollo/apollo-horn-shoe-with-door-swr-fitting-self-fit-upvc-pipe-fittings.png', ARRAY['/images/apollo/apollo-horn-shoe-with-door-swr-fitting-self-fit-upvc-pipe-fittings.png'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Horn Shoe (With Door) SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 280, '/images/apollo/apollo-horn-shoe-with-door-swr-fitting-with-ring-upvc-pipe-fittings.png', ARRAY['/images/apollo/apollo-horn-shoe-with-door-swr-fitting-with-ring-upvc-pipe-fittings.png'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Horn Shoe With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 280, '/images/apollo/apollo-horn-shoe-with-door-swr-fitting-with-rings-upvc-pipe-fittings.png', ARRAY['/images/apollo/apollo-horn-shoe-with-door-swr-fitting-with-rings-upvc-pipe-fittings.png'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Jali Round SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 29, '/images/apollo/apollo-jali-round-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-jali-round-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Life Water Tank 3 Layer', 'APL Apollo water storage tanks provide safe, hygienic storage of drinking water with multi-layer construction that protects water from sunlight and algae growth.

Key features:
- Multi-layer rotational moulded construction
- UV stabilised — protects against sunlight
- Food-grade, non-toxic inner layer
- Leak-proof and rust-free
- Long service life', 19000, '/images/apollo/apollo-life-water-tank-3-layer.jpg', ARRAY['/images/apollo/apollo-life-water-tank-3-layer.jpg'], '{"Brand":"APL Apollo","Category":"Water Tanks","GST":"18%"}'::jsonb, v_sub3, 100, true),
  ('Apollo Male Adaptor Brass Threaded SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 171, '/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Connection":"Threaded","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Male Adaptor Plastic Threaded SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 15, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Connection":"Threaded","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Male Adaptor Plastic Threaded SDR CPVC Fitting Sch 40 &Amp; 80', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 548, '/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting-sch-40-80.jpg', ARRAY['/images/apollo/apollo-male-adaptor-plastic-threaded-sdr-cpvc-fitting-sch-40-80.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Schedule":"SCH 40","Connection":"Threaded","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Male Adaptor With Hexaganol Brass Inserts SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 368, '/images/apollo/apollo-male-adaptor-with-hexaganol-brass-inserts-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-male-adaptor-with-hexaganol-brass-inserts-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Male Adaptor With Hexaganol Brass Inserts SDR CPVC Fitting Sch 40 &Amp; 80', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 2400, '/images/apollo/apollo-male-adaptor-with-hexaganol-brass-inserts-sdr-cpvc-fitting-sch-40-80.jpg', ARRAY['/images/apollo/apollo-male-adaptor-with-hexaganol-brass-inserts-sdr-cpvc-fitting-sch-40-80.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Schedule":"SCH 40","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Male Threaded Adaptor (Mta) Pn6 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 22.5, '/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-male-threaded-adaptor-mta-pn6-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Connection":"Threaded","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Male Threaded Adptor Pn10 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 4.75, '/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-male-threaded-adptor-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Connection":"Threaded","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Mixer Adaptor SDR CPVC Fitting Sch 40 &Amp; 80', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 450, '/images/apollo/apollo-mixer-adaptor-sdr-cpvc-fitting-sch-40-80.jpg', ARRAY['/images/apollo/apollo-mixer-adaptor-sdr-cpvc-fitting-sch-40-80.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Schedule":"SCH 40","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Multi Floor Trap (Without Jali) SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 187.5, '/images/apollo/apollo-multi-floor-trap-without-jali-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-multi-floor-trap-without-jali-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Nahani Trap (Without Jali) SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 112.5, '/images/apollo/apollo-nahani-trap-without-jali-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-nahani-trap-without-jali-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Nahani Trap W/S (One Pc) SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 125, '/images/apollo/apollo-nahani-trap-ws-one-pc-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-nahani-trap-ws-one-pc-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo NRV (Non Returnable Valve) SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 452, '/images/apollo/apollo-nrv-non-returnable-valve-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-nrv-non-returnable-valve-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Off Set Bend SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 144, '/images/apollo/apollo-off-set-bend-swr-fitting-self-fit-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-off-set-bend-swr-fitting-self-fit-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Offset Bend SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 150, '/images/apollo/apollo-offset-bend-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-offset-bend-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Offset Bend SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 150, '/images/apollo/apollo-offset-bend-swr-fitting-with-rings-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-offset-bend-swr-fitting-with-rings-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo P-Trap SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 313, '/images/apollo/apollo-p-trap-swr-fitting-self-fit-upvc-pipe-fittings.avif', ARRAY['/images/apollo/apollo-p-trap-swr-fitting-self-fit-upvc-pipe-fittings.avif'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe 2.5kg/Cm2 With Rubber Ring 3 Mtrs uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 456, '/images/apollo/apollo-pipe-25kgcm2-with-rubber-ring-3-mtrs-upvc-pipe.webp', ARRAY['/images/apollo/apollo-pipe-25kgcm2-with-rubber-ring-3-mtrs-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Pressure Rating":"5 kg/cm²","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe Clamp SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 27, '/images/apollo/apollo-pipe-clamp-swr-fitting-self-fit-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-pipe-clamp-swr-fitting-self-fit-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe Double Socket Type A uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 188, '/images/apollo/apollo-pipe-double-socket-type-a-upvc-pipe.webp', ARRAY['/images/apollo/apollo-pipe-double-socket-type-a-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe Double Socket Type B uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 297, '/images/apollo/apollo-pipe-double-socket-type-b-upvc-pipe.webp', ARRAY['/images/apollo/apollo-pipe-double-socket-type-b-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe Type A With Rubber Ring 3 Mtrs uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 564, '/images/apollo/apollo-pipe-type-a-with-rubber-ring-3-mtrs-upvc-pipe.webp', ARRAY['/images/apollo/apollo-pipe-type-a-with-rubber-ring-3-mtrs-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe Type B With Rubber Ring 3 Mtrs uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 925, '/images/apollo/apollo-pipe-type-b-with-rubber-ring-3-mtrs-upvc-pipe.webp', ARRAY['/images/apollo/apollo-pipe-type-b-with-rubber-ring-3-mtrs-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe With Rubber Ring 3 Mtr. Length Type A uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 659, '/images/apollo/apollo-pipe-with-rubber-ring-3-mtr-length-type-a-upvc-pipe.jpg', ARRAY['/images/apollo/apollo-pipe-with-rubber-ring-3-mtr-length-type-a-upvc-pipe.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe With Rubber Ring 3 Mtr. Length Type B uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 1129, '/images/apollo/apollo-pipe-with-rubber-ring-3-mtr-length-type-b-upvc-pipe.webp', ARRAY['/images/apollo/apollo-pipe-with-rubber-ring-3-mtr-length-type-b-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo PVC Solvent Cement Plastic Bottle', 'APL Apollo PVC solvent cement provides strong, leak-proof solvent-welded joints for CPVC/uPVC pipes and fittings. Fast-setting and high-strength for reliable plumbing connections.', 56, '/images/apollo/apollo-pvc-solvent-cement-plastic-bottle.webp', ARRAY['/images/apollo/apollo-pvc-solvent-cement-plastic-bottle.webp'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Joint Type":"Solvent Weld","GST":"18%"}'::jsonb, v_sub2, 100, true),
  ('Apollo PVC Solvent Cement Tin', 'APL Apollo PVC solvent cement provides strong, leak-proof solvent-welded joints for CPVC/uPVC pipes and fittings. Fast-setting and high-strength for reliable plumbing connections.', 90, '/images/apollo/apollo-pvc-solvent-cement-tin.jpg', ARRAY['/images/apollo/apollo-pvc-solvent-cement-tin.jpg'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Joint Type":"Solvent Weld","GST":"18%"}'::jsonb, v_sub2, 100, true),
  ('Apollo PVC Solvent Cement Tube', 'APL Apollo PVC solvent cement provides strong, leak-proof solvent-welded joints for CPVC/uPVC pipes and fittings. Fast-setting and high-strength for reliable plumbing connections.', 29, '/images/apollo/apollo-pvc-solvent-cement-tube.webp', ARRAY['/images/apollo/apollo-pvc-solvent-cement-tube.webp'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Joint Type":"Solvent Weld","GST":"18%"}'::jsonb, v_sub2, 100, true),
  ('Apollo Q-Trap SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 525, '/images/apollo/apollo-q-trap-swr-fitting-self-fit-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-q-trap-swr-fitting-self-fit-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Bush SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 17, '/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-bush-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Reducing Bush uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 142, '/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-bush-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Coupler 6kg uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 48, '/images/apollo/apollo-reducing-coupler-6kg-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-6kg-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Coupler Pn6 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 110, '/images/apollo/apollo-reducing-coupler-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Coupler SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 20, '/images/apollo/apollo-reducing-coupler-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Reducing Coupler SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 103, '/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Coupler SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 110, '/images/apollo/apollo-reducing-coupler-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Coupler SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 110, '/images/apollo/apollo-reducing-coupler-swr-fitting-with-rings-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-coupler-swr-fitting-with-rings-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Elbow SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 27, '/images/apollo/apollo-reducing-elbow-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-reducing-elbow-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Reducing Female Adaptor Brass Threaded SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 90, '/images/apollo/apollo-reducing-female-adaptor-brass-threaded-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-reducing-female-adaptor-brass-threaded-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Connection":"Threaded","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Reducing Female Adaptor Plastic Threaded SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 35, '/images/apollo/apollo-reducing-female-adaptor-plastic-threaded-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-reducing-female-adaptor-plastic-threaded-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Connection":"Threaded","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Reducing Female Elbow Brass Threaded SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 76, '/images/apollo/apollo-reducing-female-elbow-brass-threaded-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-reducing-female-elbow-brass-threaded-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Connection":"Threaded","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Reducing Female Tee Brass Threaded SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 92, '/images/apollo/apollo-reducing-female-tee-brass-threaded-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-reducing-female-tee-brass-threaded-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Connection":"Threaded","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Reducing Male Adaptor Brass Threaded SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 120, '/images/apollo/apollo-reducing-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-male-adaptor-brass-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Connection":"Threaded","Material":"uPVC with Brass Insert","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Reducing Male Adaptor Plastic Threaded SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 26, '/images/apollo/apollo-reducing-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-male-adaptor-plastic-threaded-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Connection":"Threaded","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Reducing Tee Pn10 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 26, '/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Tee Pn4 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 186, '/images/apollo/apollo-reducing-tee-pn4-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-pn4-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Tee Pn6 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 625, '/images/apollo/apollo-reducing-tee-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Tee SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 54, '/images/apollo/apollo-reducing-tee-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-reducing-tee-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Reducing Tee SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 180, '/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Tee SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 179, '/images/apollo/apollo-reducing-tee-swr-fitting-with-ring-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-with-ring-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Tee SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 179, '/images/apollo/apollo-reducing-tee-swr-fitting-with-rings-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-swr-fitting-with-rings-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Tee With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 218, '/images/apollo/apollo-reducing-tee-with-door-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-with-door-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Tee (With Door) SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 233, '/images/apollo/apollo-reducing-tee-with-door-swr-fitting-with-ring-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-with-door-swr-fitting-with-ring-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Tee With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 233, '/images/apollo/apollo-reducing-tee-with-door-swr-fitting-with-rings-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-tee-with-door-swr-fitting-with-rings-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Y SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 237, '/images/apollo/apollo-reducing-y-swr-fitting-self-fit-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-reducing-y-swr-fitting-self-fit-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Y SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 255, '/images/apollo/apollo-reducing-y-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-reducing-y-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Y SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 255, '/images/apollo/apollo-reducing-y-swr-fitting-with-rings-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-y-swr-fitting-with-rings-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Y With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 297, '/images/apollo/apollo-reducing-y-with-door-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-y-with-door-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Reducing Y With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 315, '/images/apollo/apollo-reducing-y-with-door-swr-fitting-with-rings-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-reducing-y-with-door-swr-fitting-with-rings-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Rubber Ring (Yellow) Extra SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 10.5, '/images/apollo/apollo-rubber-ring-yellow-extra-swr-fitting-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-rubber-ring-yellow-extra-swr-fitting-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Rubber Ring (Yellow) Extra SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 10.5, '/images/apollo/apollo-rubber-ring-yellow-extra-swr-fitting-with-ring-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-rubber-ring-yellow-extra-swr-fitting-with-ring-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo S-Trap SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 607, '/images/apollo/apollo-s-trap-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-s-trap-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Self Fit Pipe 2.5kg/Cm2 3 Mtrs uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 450, '/images/apollo/apollo-self-fit-pipe-25kgcm2-3-mtrs-upvc-pipe.webp', ARRAY['/images/apollo/apollo-self-fit-pipe-25kgcm2-3-mtrs-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","Pressure Rating":"5 kg/cm²","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Self Fit Pipe 3 Mtr Length Type A uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 653, '/images/apollo/apollo-self-fit-pipe-3-mtr-length-type-a-upvc-pipe.webp', ARRAY['/images/apollo/apollo-self-fit-pipe-3-mtr-length-type-a-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Self Fit Pipe 3 Mtr Length Type B uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 1119, '/images/apollo/apollo-self-fit-pipe-3-mtr-length-type-b-upvc-pipe.webp', ARRAY['/images/apollo/apollo-self-fit-pipe-3-mtr-length-type-b-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Self Fit Pipe Single Socket With Rubber Ring 12 Ft uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 690, '/images/apollo/apollo-self-fit-pipe-single-socket-with-rubber-ring-12-ft-upvc-pipe.webp', ARRAY['/images/apollo/apollo-self-fit-pipe-single-socket-with-rubber-ring-12-ft-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Self Fit Pipe Type A 3 Mtrs uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 547.5, '/images/apollo/apollo-self-fit-pipe-type-a-3-mtrs-upvc-pipe.webp', ARRAY['/images/apollo/apollo-self-fit-pipe-type-a-3-mtrs-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Self Fit Pipe Type B 3 Mtrs uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 910, '/images/apollo/apollo-self-fit-pipe-type-b-3-mtrs-upvc-pipe.webp', ARRAY['/images/apollo/apollo-self-fit-pipe-type-b-3-mtrs-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Service Saddle uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 94, '/images/apollo/apollo-service-saddle-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-service-saddle-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Single Tee SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 100, '/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Single Tee SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 111, '/images/apollo/apollo-single-tee-swr-fitting-with-ring-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-with-ring-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Single Tee SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 111, '/images/apollo/apollo-single-tee-swr-fitting-with-rings-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-tee-swr-fitting-with-rings-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Single Tee With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 120, '/images/apollo/apollo-single-tee-with-door-swr-fitting-self-fit-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-single-tee-with-door-swr-fitting-self-fit-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Single Tee (With Door) SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 132, '/images/apollo/apollo-single-tee-with-door-swr-fitting-with-ring-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-single-tee-with-door-swr-fitting-with-ring-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Single Tee (With Door) SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 132, '/images/apollo/apollo-single-tee-with-door-swr-fitting-with-rings-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-single-tee-with-door-swr-fitting-with-rings-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Single Y SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 124, '/images/apollo/apollo-single-y-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-y-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Single Y SWR Fitting With Ring uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 162, '/images/apollo/apollo-single-y-swr-fitting-with-ring-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-y-swr-fitting-with-ring-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Ringfit","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Single Y SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 124, '/images/apollo/apollo-single-y-swr-fitting-with-rings-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-y-swr-fitting-with-rings-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Single Y With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 151, '/images/apollo/apollo-single-y-with-door-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-y-with-door-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Single Y With Door SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 162, '/images/apollo/apollo-single-y-with-door-swr-fitting-with-rings-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-single-y-with-door-swr-fitting-with-rings-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Step Over Bend SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 115, '/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg', ARRAY['/images/apollo/apollo-step-over-bend-sdr-cpvc-fitting.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo SWR Drainage 4kg/Cm2 3mtr Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 434.25, '/images/apollo/apollo-swr-drainage-4kgcm2-3mtr-upvc-pipe.webp', ARRAY['/images/apollo/apollo-swr-drainage-4kgcm2-3mtr-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Pressure Rating":"4 kg/cm²","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Drainage 6kg/Cm2 3mtr uPVC Pipe', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 257, '/images/apollo/apollo-swr-drainage-6kgcm2-3mtr-upvc-pipe.webp', ARRAY['/images/apollo/apollo-swr-drainage-6kgcm2-3mtr-upvc-pipe.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Pressure Rating":"6 kg/cm²","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Elbow 4kg/Cm2 W/O Collar Extra Strong uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 49, '/images/apollo/apollo-swr-elbow-4kgcm2-wo-collar-extra-strong-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-swr-elbow-4kgcm2-wo-collar-extra-strong-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Pressure Rating":"4 kg/cm²","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Elbow Pn4 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 15, '/images/apollo/apollo-swr-elbow-pn4-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-swr-elbow-pn4-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Elbow Regular uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 35, '/images/apollo/apollo-swr-elbow-regular-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-swr-elbow-regular-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Elbow uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 265, '/images/apollo/apollo-swr-elbow-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-swr-elbow-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Reducing Elbow Pn6 uPVC Pipe Fitting', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 100, '/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-swr-reducing-elbow-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Tee Regular uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 46.5, '/images/apollo/apollo-swr-tee-regular-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-swr-tee-regular-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Tank Connector-Pipe-Fitment SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 75, '/images/apollo/apollo-tank-connector-pipe-fitment-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-pipe-fitment-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Tank Connector SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 66, '/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tank-connector-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Tee 4kg/Cm2 W/O Collar Extra Strong uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 70, '/images/apollo/apollo-tee-4kgcm2-wo-collar-extra-strong-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-4kgcm2-wo-collar-extra-strong-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","Pressure Rating":"4 kg/cm²","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Tee Pn10 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 10, '/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn10-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Tee Pn4 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 22, '/images/apollo/apollo-tee-pn4-upvc-pipe-fittings.webp', ARRAY['/images/apollo/apollo-tee-pn4-upvc-pipe-fittings.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Tee Pn6 uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 37.5, '/images/apollo/apollo-tee-pn6-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-pn6-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Tee SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 23, '/images/apollo/apollo-tee-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-tee-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Tee uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 435, '/images/apollo/apollo-tee-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-tee-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Threaded Elbow Without Collar uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 230, '/images/apollo/apollo-threaded-elbow-without-collar-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-threaded-elbow-without-collar-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Connection":"Threaded","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true),
  ('Apollo Transition Bush SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 9, '/images/apollo/apollo-transition-bush-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-transition-bush-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Union SDR CPVC Fitting', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 63, '/images/apollo/apollo-union-sdr-cpvc-fitting.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo Union SDR CPVC Fitting Sch 40 &Amp; 80', 'APL Apollo CPVC-X Extra Strong plumbing products are manufactured with TEMPRITE® CPVC compound from Lubrizol, engineered for hot & cold water distribution.

Why choose APL Apollo CPVC-X:
- Manufactured with TEMPRITE® CPVC Resin from Lubrizol
- Smooth flow hydraulics with reduced friction loss
- ISI certified, extra strong and highly durable
- Leak-proof solvent-welded joints
- Superior heat resistance and excellent chlorine/chemical resistance
- Conforms to ASTM D2846 / IS:15778 standards', 1650, '/images/apollo/apollo-union-sdr-cpvc-fitting-sch-40-80.webp', ARRAY['/images/apollo/apollo-union-sdr-cpvc-fitting-sch-40-80.webp'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Schedule":"SCH 40","Material":"CPVC","GST":"18%"}'::jsonb, v_sub0, 100, true),
  ('Apollo uPVC Solvent Cement Tin', 'APL Apollo PVC solvent cement provides strong, leak-proof solvent-welded joints for CPVC/uPVC pipes and fittings. Fast-setting and high-strength for reliable plumbing connections.', 123, '/images/apollo/apollo-upvc-solvent-cement-tin.webp', ARRAY['/images/apollo/apollo-upvc-solvent-cement-tin.webp'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Joint Type":"Solvent Weld","GST":"18%"}'::jsonb, v_sub2, 100, true),
  ('Apollo uPVC Solvent Cement Tube', 'APL Apollo PVC solvent cement provides strong, leak-proof solvent-welded joints for CPVC/uPVC pipes and fittings. Fast-setting and high-strength for reliable plumbing connections.', 56, '/images/apollo/apollo-upvc-solvent-cement-tube.webp', ARRAY['/images/apollo/apollo-upvc-solvent-cement-tube.webp'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Joint Type":"Solvent Weld","GST":"18%"}'::jsonb, v_sub2, 100, true),
  ('Apollo Vent Cowl SWR Fitting Self Fit uPVC Pipe Fittings', 'APL Apollo SWR (Soil, Waste & Rain) uPVC drainage products are designed for residential and commercial drainage systems, offering long-lasting, leak-proof performance.

Key features:
- High-impact, extra-strong uPVC construction
- Corrosion, chemical and weather resistant
- Smooth bore for efficient, silent flow
- Easy to install — Self-Fit (push-fit) and Ringfit options
- Conforms to IS:13592 standards', 21, '/images/apollo/apollo-vent-cowl-swr-fitting-self-fit-upvc-pipe-fittings.jpg', ARRAY['/images/apollo/apollo-vent-cowl-swr-fitting-self-fit-upvc-pipe-fittings.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Joint Type":"Self-Fit (Push Fit)","Material":"uPVC","GST":"18%"}'::jsonb, v_sub1, 100, true);

END $$;
