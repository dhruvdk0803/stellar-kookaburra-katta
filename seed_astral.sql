-- Astral products scraped from makankidukan.com (building-materials section), July 2026.
-- Creates Astral parent category + subcategories and inserts 202 products.
-- Safe to re-run: deletes existing Astral products in these subcategories first.

DO $$
DECLARE
  v_parent UUID;
  v_sub0 UUID;  -- CPVC Pipes & Fittings
  v_sub1 UUID;  -- SWR / DrainPro Pipes & Fittings
  v_sub2 UUID;  -- Solvent Cement & Adhesives
  v_sub3 UUID;  -- Water Tanks
  v_sub4 UUID;  -- Sanitary & Other
BEGIN
  SELECT id INTO v_parent FROM categories WHERE slug='astral' OR lower(name)='astral' LIMIT 1;
  IF v_parent IS NULL THEN
    INSERT INTO categories (name, slug) VALUES ('Astral','astral') RETURNING id INTO v_parent;
  END IF;

  SELECT id INTO v_sub0 FROM categories WHERE parent_id=v_parent AND name='CPVC Pipes & Fittings' LIMIT 1;
  IF v_sub0 IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('CPVC Pipes & Fittings', 'astral-cpvc-pipes-fittings', v_parent) RETURNING id INTO v_sub0;
  END IF;

  SELECT id INTO v_sub1 FROM categories WHERE parent_id=v_parent AND name='SWR / DrainPro Pipes & Fittings' LIMIT 1;
  IF v_sub1 IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('SWR / DrainPro Pipes & Fittings', 'astral-swr-drainpro-pipes-fittings', v_parent) RETURNING id INTO v_sub1;
  END IF;

  SELECT id INTO v_sub2 FROM categories WHERE parent_id=v_parent AND name='Solvent Cement & Adhesives' LIMIT 1;
  IF v_sub2 IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('Solvent Cement & Adhesives', 'astral-solvent-cement-adhesives', v_parent) RETURNING id INTO v_sub2;
  END IF;

  SELECT id INTO v_sub3 FROM categories WHERE parent_id=v_parent AND name='Water Tanks' LIMIT 1;
  IF v_sub3 IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('Water Tanks', 'astral-water-tanks', v_parent) RETURNING id INTO v_sub3;
  END IF;

  SELECT id INTO v_sub4 FROM categories WHERE parent_id=v_parent AND name='Sanitary & Other' LIMIT 1;
  IF v_sub4 IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('Sanitary & Other', 'astral-sanitary-other', v_parent) RETURNING id INTO v_sub4;
  END IF;

  DELETE FROM products WHERE category_id IN (v_sub0, v_sub1, v_sub2, v_sub3, v_sub4);

  INSERT INTO products (name, description, price, image_url, images, specs, category_id, stock, is_active) VALUES
  ('Astral Pipe SDR - 11 CPVC Pipes', 'High-quality piping solutions manufactured from Chlorinated Polyvinyl Chloride (CPVC) per ASTM D2846 standards for hot and cold water plumbing applications. The pipes feature exceptional temperature resistance (up to 93°C/200°F), pressure endurance for residential/commercial/industrial use, corrosion resistance, and fire-retardant properties with minimal maintenance requirements.

Available sizes/variants: Length: 3 Mtr, 5 Mtr; Thickness: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 312, 'https://www.makankidukan.com/uploads/products/1748843346_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748843346_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Standard":"ASTM D2846 (SDR-11 hot & cold water plumbing systems)","Temperature Rating":"Up to 93°C (200°F)","Color":"Light cream or off-white","Key Features":"High temperature resistance, corrosion resistance, smooth inner surface, lightweight, fire resistance, low thermal conductivity, extended service life","GST Inclusive Price":"Rs. 198.81","Available Sizes":"Length: 3 Mtr, 5 Mtr; Thickness: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 312","Source":"https://www.makankidukan.com/building-product/astral-pipe-sdr-11-cpvc-pipes"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe SDR - 13.5 CPVC Pipes', 'High-quality CPVC piping made from Chlorinated Polyvinyl Chloride, manufactured to ASTM D2846 standards for hot and cold water plumbing systems. The pipes feature lightweight construction with easier installation compared to metal alternatives, offering extended durability with minimal maintenance requirements.

Available sizes/variants: Size: 3 Mtr, 5 Mtr; Thickness: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 273, 'https://www.makankidukan.com/uploads/products/1748844526_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748844526_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Standard":"ASTM D2846 (SDR-11)","Temperature Resistance":"Up to 93°C (200°F)","Pressure Rating":"Suitable for higher pressure applications","Color":"Light cream or off-white","Inner Surface":"Smooth finish for minimal friction loss","Fire Resistance":"Inherently fire-retardant","Thermal Conductivity":"Low, reducing heat loss and condensation","GST Inclusive Price":"Rs. 173.96","Stock Status":"In Stock","Available Sizes":"Size: 3 Mtr, 5 Mtr; Thickness: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 273","Source":"https://www.makankidukan.com/building-product/astral-pipe-sdr-135-cpvc-pipes"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Schedule 40 CPVC Pipes', 'Engineered to resist high temperatures and pressures while conforming to Schedule 40 standards. The pipes offer corrosion resistance and a smooth inner surface for reduced friction and pressure drops, making them suitable for potable water applications with lightweight installation benefits.

Available sizes/variants: Sizes: 3 Mtr, 5 Mtr; Thickness: 2.5 inch, 3 inch, 4 inch, 6 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 4515, 'https://www.makankidukan.com/uploads/products/1748845187_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748845187_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Standards":"ASTM D1785, ASTM F441","Temperature Rating":"Up to 93°C (200°F)","Certifications":"NSF certified for potable water, UPC compliant","Color":"Light beige or off-white","Key Features":"High temperature/pressure resistance, corrosion resistant, smooth inner surface, fire resistant, UV resistant, low thermal conductivity","GST Inclusive Price":"Rs. 2,876.96","Available Sizes":"Sizes: 3 Mtr, 5 Mtr; Thickness: 2.5 inch, 3 inch, 4 inch, 6 inch","MRP":"Rs. 4515","Source":"https://www.makankidukan.com/building-product/astral-pipe-schedule-40-cpvc-pipes"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Schedule 80 CPVC Pipes', 'Industrial-grade thermoplastic pipes made from Chlorinated Polyvinyl Chloride designed for high-pressure and high-temperature fluid systems. These pipes feature thicker walls than standard alternatives and are noted for durability with minimal maintenance needs.

Available sizes/variants: Thickness: 2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch; Length: 3 Mtr, 5 Mtr

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 6171, 'https://www.makankidukan.com/uploads/products/1748845814_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748845814_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Standard":"ASTM F441/F441M","Temperature Rating":"Up to 93°C (200°F)","Schedule":"80 (higher pressure rating)","Notable Features":"Corrosion resistant with smooth interior surface; self-extinguishing property, does not sustain flame; low thermal conductivity and UV resistant options available; lightweight for easier installation compared to metal alternatives","GST Inclusive Price":"Rs. 3,932.17","Available Sizes":"Thickness: 2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch; Length: 3 Mtr, 5 Mtr","MRP":"Rs. 6171","Source":"https://www.makankidukan.com/building-product/astral-pipe-schedule-80-cpvc-pipes"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Coupler - Soc CPVC Pipes Fittings', 'Chlorinated Polyvinyl Chloride (CPVC) fittings designed for residential, commercial, and industrial applications with solvent-cement joining installation methods. Corrosion resistant, high impact strength, UV stabilized, lightweight with smooth inner surface reducing friction and pressure drops.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 18, 'https://www.makankidukan.com/uploads/products/1748846428_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748846428_0.png','https://www.makankidukan.com/uploads/products/1748846428_1.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Resistance":"Up to 93°C (200°F) continuous operation","Corrosion Resistance":"Resistant to acids, bases, salts, and oxidants","Standards":"ASTM D2846, ASTM F441, IS 15778","Inner Surface":"Smooth - reduces friction and pressure drops","Price with GST":"Rs. 11.26","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 18","Source":"https://www.makankidukan.com/building-product/astral-pipe-coupler-soc-cpvc-pipes-fittings"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Elbow 90 Degree - Soc CPVC Pipes Fittings', 'Manufactured from Chlorinated Polyvinyl Chloride (CPVC) material, suited for residential, commercial, and industrial uses. Handles temperatures up to 93°C continuously and resists corrosion from acids, bases, and salts.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 22, 'https://www.makankidukan.com/uploads/products/1748846897_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748846897_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC","Type":"Socket Outlet Connection (SOC)","Angle":"90 degrees","Standards":"ASTM D2846, ASTM F441, IS 15778","Temperature Resistance":"Up to 93°C (200°F)","Key Properties":"High impact strength, UV stabilized, smooth inner surface, fire resistant","Price with GST":"Rs. 13.76","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 22","Source":"https://www.makankidukan.com/building-product/astral-pipe-elbow-90-degree-soc-cpvc-pipes-fittings"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe End Cap - Soc CPVC Pipes Fittings', 'Chlorinated Polyvinyl Chloride (CPVC) end cap fitting with high-temperature resistance, handling water up to 93°C (200°F) continuously. Corrosion-resistant to acids, bases, salts, and oxidants; smooth interior reduces friction and pressure loss; high impact strength; UV stabilized for indoor and limited outdoor use; lightweight with simple solvent-cement joining.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 14.5, 'https://www.makankidukan.com/uploads/products/1748847197_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748847197_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Standards":"ASTM D2846, ASTM F441, IS 15778","Price with GST":"Rs. 9.07","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 14.5","Source":"https://www.makankidukan.com/building-product/astral-pipe-end-cap-soc-cpvc-pipes-fittings"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Elbow 45 Degree - Soc CPVC Pipes Fittings', 'Chlorinated Polyvinyl Chloride (CPVC) 45-degree elbow fitting handling water up to 93°C (200°F) continuously. Corrosion resistant, high impact strength, UV stabilized, smooth inner surface, easy solvent-cement joining. Offers high temperature resistance, pressure endurance, corrosion resistance, fire resistance, and extended service life for residential, commercial, and industrial plumbing applications.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 25, 'https://www.makankidukan.com/uploads/products/1748849174_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748849174_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Standards":"ASTM D2846, ASTM F441, IS 15778","Price with GST":"Rs. 15.64","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 25","Source":"https://www.makankidukan.com/building-product/astral-pipe-elbow-45-degree-soc-cpvc-pipes-fittings"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Tee - Soc CPVC Pipes Fittings', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. High temperature and pressure resistance, corrosion resistant to acids, bases, salts, and oxidants, smooth inner surface reducing friction, high impact strength, UV stabilized, lightweight with easy solvent-cement joining, precise manufacturing tolerances.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 30, 'https://www.makankidukan.com/uploads/products/1748849432_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748849432_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Standards":"ASTM D2846, ASTM F441, IS 15778","Temperature Rating":"Up to 93°C (200°F) continuously","Price with GST":"Rs. 18.76","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 30","Source":"https://www.makankidukan.com/building-product/astral-pipe-tee-soc-cpvc-pipes-fittings"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Cross - Soc CPVC Pipes Fittings', 'Chlorinated Polyvinyl Chloride (CPVC) cross fitting with UV stabilizers, impact modifiers, and specialty chemicals. Handles water up to 93°C (200°F) continuously, corrosion resistant to acids, bases, salts, and oxidants, high impact strength suitable for high-pressure conditions, smooth inner surface reducing friction and pressure drops, UV stabilized for indoor and limited outdoor use, precise dimensional tolerances.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 41, 'https://www.makankidukan.com/uploads/products/1748849713_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748849713_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC with UV stabilizers, impact modifiers, and specialty chemicals","Standards":"ASTM D2846, ASTM F441, IS 15778","Price with GST":"Rs. 25.64","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 41","Source":"https://www.makankidukan.com/building-product/astral-pipe-cross-soc-cpvc-pipes-fittings"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Male Adapter CPVC (thd*soc)', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, suitable for residential, commercial, and industrial plumbing applications. Threaded x Socket (THD*SOC) connection type. Handles water up to 93°C (200°F) continuously. Corrosion resistant, smooth inner surface, high impact strength, UV stabilized, lightweight.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 21, 'https://www.makankidukan.com/uploads/products/1748849999_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748849999_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Connection Type":"Threaded x Socket (THD*SOC)","Standards":"ASTM D2846, ASTM F441, IS 15778","Price with GST":"Rs. 13.13","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 21","Source":"https://www.makankidukan.com/building-product/astral-pipe-male-adapter-cpvc-thdsoc-cpvc-pipes-fittings"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Reducer Male Adapter CPVC (thd*soc)', 'Chlorinated Polyvinyl Chloride (CPVC) reducer male adapter, includes UV stabilizers, impact modifiers, and specialty chemicals. Handles water up to 93°C (200°F), immune to most acids, bases, salts, and oxidants, reduced friction from smooth inner surface, high impact strength under pressure, UV stabilized for indoor and limited outdoor use, lightweight with simple solvent-cement joining.

Available sizes/variants: 0.75 x 0.5 inch, 1 x 0.75 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 42, 'https://www.makankidukan.com/uploads/products/1748850288_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748850288_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC with UV stabilizers, impact modifiers, and specialty chemicals","Connection Type":"Threaded x Socket (THD*SOC), reducing","Standards":"ASTM D2846, ASTM F441, IS 15778","Price with GST":"Rs. 26.27","Available Sizes":"0.75 x 0.5 inch, 1 x 0.75 inch","MRP":"Rs. 42","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-male-adapter-cpvc-thdsoc-cpvc-pipes-fittings"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Female Adapter CPVC (thd*soc)', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The adapter features a threaded-socket (THD*SOC) configuration designed for water piping systems with high-temperature resistance, handling water up to 93°C (200°F) continuously. Corrosion resistant to most acids, bases, salts, and oxidants, with a smooth inner surface reducing friction for better flow and lesser pressure drops. High impact strength for durability under high-pressure conditions, UV stabilized for indoor and limited outdoor use, and easy installation via lightweight solvent-cement joining.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 27, 'https://www.makankidukan.com/uploads/products/1748850829_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748850829_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Fitting Type":"Female Adapter (Threaded x Socket)","Standards":"ASTM D2846, ASTM F441, IS 15778","Temperature Rating":"93°C continuous","Additives":"UV stabilizers and impact modifiers","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 27","Source":"https://www.makankidukan.com/building-product/astral-pipe-female-adapter-cpvc-thdsoc-cpvc-pipes-fittings"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Reducer Female Adapter CPVC (thd*soc)', 'This CPVC fitting is manufactured from Chlorinated Polyvinyl Chloride and designed for residential, commercial, and industrial piping applications. Handles water up to 93°C (200°F) continuously, offers corrosion immunity to acids, bases, salts, and oxidants. Installation involves lightweight solvent-cement joining methods.

Available sizes/variants: 0.75 x 0.5 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 50, 'https://www.makankidukan.com/uploads/products/1748851144_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748851144_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Reducer Female Adapter (THD × SOC)","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"UV stabilized, high impact strength, smooth inner surface, tight dimensional tolerances","Temperature Rating":"Up to 93°C (200°F) continuous","Available Sizes":"0.75 x 0.5 inch","MRP":"Rs. 50","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-female-adapter-cpvc-thdsoc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Union - Soc CPVC Pipes Fitting', 'This CPVC fitting is designed for residential, commercial, and industrial applications. It features high-temperature resistance handling water up to 93°C continuously, corrosion resistance to acids and bases, and a smooth inner surface that reduces friction. Offers high impact strength and is UV stabilized for indoor and limited outdoor use. Installation involves lightweight and simple solvent-cement joining.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 74, 'https://www.makankidukan.com/uploads/products/1748859883_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748859883_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Features":"UV stabilized, high impact strength, precise manufacturing with tight tolerances","Additives":"UV stabilizers, impact modifiers, specialty chemicals","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 74","Source":"https://www.makankidukan.com/building-product/astral-pipe-union-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Reducer Elbow 90 Degree - Soc', 'Made from Chlorinated Polyvinyl Chloride (CPVC), this fitting suits residential, commercial, and industrial piping systems. Can handle water up to 93°C (200°F) continuously and resists most acids, bases, salts, and oxidants. The smooth inner surface reduces friction for improved flow and lower pressure drops, while high impact strength provides durability under demanding conditions. UV stabilized for indoor and limited outdoor use, with lightweight solvent-cement joining for straightforward installation.

Available sizes/variants: 0.75 x 0.5 inch, 1 x 0.5 inch, 1 x 0.75 inch, 1.25 x 0.5 inch, 1.25 x 0.75 inch, 1.25 x 1 inch, 2 x 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 37, 'https://www.makankidukan.com/uploads/products/1748860670_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748860670_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Type":"Reducer Elbow, 90-degree angle","Connection":"Socket (SOC)","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Features":"UV stabilized, corrosion resistant, fire resistant, high impact strength","Available Sizes":"0.75 x 0.5 inch, 1 x 0.5 inch, 1 x 0.75 inch, 1.25 x 0.5 inch, 1.25 x 0.75 inch, 1.25 x 1 inch, 2 x 1 inch","MRP":"Rs. 37","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-elbow-90-degree-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Reducer Tee - Soc', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The fitting handles water temperatures up to 93°C continuously and resists corrosion from acids, bases, salts, and oxidants. It features a smooth inner surface to reduce friction and pressure drops, high impact strength, UV stabilization, and easy installation via lightweight solvent-cement joining.

Available sizes/variants: 0.5x0.5x0.75, 0.75x0.5x0.5 through 0.75x0.75x0.5, 1x1x0.5, 1x1x0.75, 1.25x1.25 series (0.5,0.75,1), 1.5x1.5 series (0.5 to 1.25), 2x2 series (0.5 to 1.5) inch - 19 configurations

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 64, 'https://www.makankidukan.com/uploads/products/1748863883_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748863883_0.png','https://www.makankidukan.com/uploads/products/1748863883_1.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"Corrosion resistant, UV stabilized, high impact strength, smooth inner surface, fire resistant, long service life","Available Sizes":"0.5x0.5x0.75, 0.75x0.5x0.5 through 0.75x0.75x0.5, 1x1x0.5, 1x1x0.75, 1.25x1.25 series (0.5,0.75,1), 1.5x1.5 series (0.5 to 1.25), 2x2 series (0.5 to 1.5) inch - 19 configurations","MRP":"Rs. 64","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-tee-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Reducer Tee -soc(ips*cts)', 'Made from Chlorinated Polyvinyl Chloride (CPVC), this fitting suits residential, commercial, and industrial applications. Can handle water up to 93°C (200°F) continuously and resists acids, bases, salts, and oxidants. The smooth inner surface minimizes friction and pressure loss, while high impact strength ensures durability under pressure. It''s UV stabilized and features lightweight, solvent-cement joining installation.

Available sizes/variants: 2.5x1, 2.5x1.5, 2.5x2, 3x1, 3x1.5, 3x2, 4x1.5, 4x2, 6x2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 785, 'https://www.makankidukan.com/uploads/products/1748865495_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748865495_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Standards":"ASTM D2846, ASTM F441, IS 15778","Temperature Rating":"Up to 93°C (200°F)","Features":"Corrosion resistance, UV stabilized, high impact strength, smooth inner surface","Available Sizes":"2.5x1, 2.5x1.5, 2.5x2, 3x1, 3x1.5, 3x2, 4x1.5, 4x2, 6x2 inch","MRP":"Rs. 785","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-tee-socipscts-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Reducer Bushing (spg*soc)', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material for residential, commercial, and industrial applications. Accommodates water temperatures up to 93°C continuously and resists most acids, bases, salts, and oxidants. The smooth inner surface minimizes friction for improved flow characteristics. Emphasizes high temperature and pressure resistance, corrosion immunity, fire resistance, extended service life, and straightforward installation.

Available sizes/variants: Fifteen size options ranging from 0.75 x 0.5 inch through 2 x 1.5 inch combinations

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 18, 'https://www.makankidukan.com/uploads/products/1748866287_0.avif', ARRAY['https://www.makankidukan.com/uploads/products/1748866287_0.avif'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Features":"UV stabilized, high impact strength, lightweight construction with solvent-cement joining","Available Sizes":"Fifteen size options ranging from 0.75 x 0.5 inch through 2 x 1.5 inch combinations","MRP":"Rs. 18","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-bushing-spgsoc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Transition Bushing- Spg*soc(ips*cts)', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The product features high-temperature capability, corrosion resistance, and smooth internal surfaces that minimize friction and pressure drops. Installation is simplified through lightweight solvent-cement joining methods.

Available sizes/variants: 0.5 x 0.5", 0.75 x 0.75", 1 x 1", 1.25 x 1.25", 1.5 x 1.5", 2 x 2", 2.5 x 1", 2.5 x 1.5", 2.5 x 2", 3 x 1.5", 3 x 2", 4 x 1.5", 4 x 2"

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 16.5, 'https://www.makankidukan.com/uploads/products/1748866791_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748866791_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Impact Strength":"High-pressure resistant and durable","UV Protection":"Stabilized for indoor and limited outdoor use","Key Features":"Corrosion resistant, smooth inner surface, fire resistant, long service life, easy installation","Available Sizes":"0.5 x 0.5\", 0.75 x 0.75\", 1 x 1\", 1.25 x 1.25\", 1.5 x 1.5\", 2 x 2\", 2.5 x 1\", 2.5 x 1.5\", 2.5 x 2\", 3 x 1.5\", 3 x 2\", 4 x 1.5\", 4 x 2\"","MRP":"Rs. 16.5","Source":"https://www.makankidukan.com/building-product/astral-pipe-transition-bushing-spgsocipscts-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Reducer Coupler - Soc', 'Made from Chlorinated Polyvinyl Chloride (CPVC) material suitable for residential, commercial, and industrial applications. The fitting features high-temperature resistance up to 93°C (200°F), corrosion resistance to acids/bases/salts, smooth inner surface for optimal flow, and high impact strength under pressure conditions. UV stabilized for indoor and limited outdoor use with lightweight, solvent-cement joining installation.

Available sizes/variants: 0.75x0.5", 1x0.5", 1x0.75", 1.25x0.5/0.75/1", 1.5x0.5/0.75/1/1.25", 2x0.5/0.75/1/1.25/1.5"

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 30, 'https://www.makankidukan.com/uploads/products/1748868202_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748868202_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Max Temperature":"93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Features":"High impact strength, UV stabilized, tight dimensional tolerances","Installation":"Solvent-cement joining","Available Sizes":"0.75x0.5\", 1x0.5\", 1x0.75\", 1.25x0.5/0.75/1\", 1.5x0.5/0.75/1/1.25\", 2x0.5/0.75/1/1.25/1.5\"","MRP":"Rs. 30","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-coupler-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Transition Reducer Coupler - Soc (ips X Cts)', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The fitting features high-temperature resistance up to 93°C continuously, corrosion resistance to acids/bases/salts, smooth inner surface reducing friction, high impact strength, UV stabilization, precise manufacturing with tight tolerances, and easy solvent-cement joining installation.

Available sizes/variants: 2.5x1.25", 2.5x2", 3x1.5", 3x2", 4x1.5", 4x2"

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 511, 'https://www.makankidukan.com/uploads/products/1748869018_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748869018_0.webp','https://www.makankidukan.com/uploads/products/1748869018_1.webp'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Fitting Type":"Transition Reducer Coupler","Connection Type":"SOC (IPS X CTS)","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"UV stabilized, corrosion resistant, smooth inner surface, high impact strength","Available Sizes":"2.5x1.25\", 2.5x2\", 3x1.5\", 3x2\", 4x1.5\", 4x2\"","MRP":"Rs. 511","Source":"https://www.makankidukan.com/building-product/astral-pipe-transition-reducer-coupler-soc-ips-x-cts-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Transition Coupler - Soc (ips X Cts)', 'The product is a CPVC pipes fitting manufactured from Chlorinated Polyvinyl Chloride material, suitable for residential, commercial, and industrial applications. It features high-temperature resistance up to 93°C (200°F) continuously, corrosion resistance to acids/bases/salts/oxidants, smooth inner surface reducing friction, high impact strength under pressure, UV stabilization, precise manufacturing with tight tolerances, and lightweight design enabling easy solvent-cement joining.

Available sizes/variants: 0.75 x 0.75 inch, 1 x 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 80, 'https://www.makankidukan.com/uploads/products/1748927322_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748927322_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Transition Coupler - SOC (IPS x CTS)","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Surface":"Smooth inner surface","Impact Strength":"High","UV Protection":"Stabilized for indoor/limited outdoor use","Installation Method":"Solvent-cement joining","Available Sizes":"0.75 x 0.75 inch, 1 x 1 inch","MRP":"Rs. 80","Source":"https://www.makankidukan.com/building-product/astral-pipe-transition-coupler-soc-ips-x-cts-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Elbow 90 Degree 3-way - Soc', 'Made from Chlorinated Polyvinyl Chloride (CPVC), this fitting works for residential, commercial, and industrial applications. It handles water temperatures up to 93°C continuously and resists most acids, bases, salts, and oxidants. The smooth inner surface reduces friction for better flow and lower pressure drops. It features high impact strength for demanding conditions, UV stabilization for indoor and limited outdoor use, tight manufacturing tolerances, lightweight construction with simple solvent-cement joining, and follows ASTM D2846, ASTM F441, and IS 15778 standards.

Available sizes/variants: 0.75 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 67, 'https://www.makankidukan.com/uploads/products/1748927528_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748927528_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Size/Thickness":"0.75 inch","Product Type":"Elbow 90 Degree 3-Way Fitting","Connection Type":"SOC (Socket)","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"High temperature resistance, pressure endurance, corrosion resistance, smooth inner surface, fire resistance, long service life, easy installation","Available Sizes":"0.75 inch","MRP":"Rs. 67","Source":"https://www.makankidukan.com/building-product/astral-pipe-elbow-90-degree-3-way-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Vanstone Flange - Soc', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, suitable for residential, commercial, and industrial applications. Can handle water up to 93°C (200°F) continuously, and is immune to most acids, bases, salts, and oxidants. The product features a smooth inner surface for better flow, high impact strength, UV stabilization, and employs solvent-cement joining for installation.

Available sizes/variants: 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 449, 'https://www.makankidukan.com/uploads/products/1748927861_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748927861_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Available Sizes":"1 inch, 1.25 inch, 1.5 inch, 2 inch","Temperature Rating":"Up to 93°C (200°F)","Standards":"ASTM D2846, ASTM F441, IS 15778","Surface Type":"Smooth inner surface","Installation Method":"Solvent-cement joining","Key Features":"High temperature resistance, pressure endurance, corrosion resistance, fire resistance, long service life, easy installation","MRP":"Rs. 449","Source":"https://www.makankidukan.com/building-product/astral-pipe-vanstone-flange-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Elbow 90 Degree 4-way - Soc', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The fitting handles continuous water temperatures up to 93°C (200°F) and resists most chemical corrosives. Features include smooth inner surfaces for improved flow, high impact strength for pressure conditions, UV stabilization, and lightweight solvent-cement installation.

Available sizes/variants: 0.75 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 76, 'https://www.makankidukan.com/uploads/products/1748928092_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748928092_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Fitting Type":"Elbow 90 Degree 4-Way","Connection Type":"SOC (Socket)","Thickness":"0.75 inch","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Available Sizes":"0.75 inch","MRP":"Rs. 76","Source":"https://www.makankidukan.com/building-product/astral-pipe-elbow-90-degree-4-way-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Brass Fpt X Soc Elbow 90 Degree', 'This CPVC pipe fitting is engineered for plumbing applications across residential, commercial, and industrial settings. It features high-temperature resistance handling water up to 93°C (200°F) continuously, and a smooth inner surface that reduces friction, ensuring better flow and lesser pressure drops. It offers corrosion resistance, UV stabilization, and utilizes solvent-cement joining for installation.

Available sizes/variants: 0.5x0.5", 0.75x0.5", 0.75x0.75", 1x0.5", 1x0.75", 1x1", 1.25x0.5", 1.25x0.75", 1.25x1.25"

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 90, 'https://www.makankidukan.com/uploads/products/1748928582_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748928582_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Product Type":"90-Degree Elbow Fitting (FPT x SOC)","Temperature Rating":"Up to 93°C (200°F) continuous","Manufacturing Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"UV stabilized, high impact strength, lightweight","Installation Method":"Solvent-cement joining","Available Sizes":"0.5x0.5\", 0.75x0.5\", 0.75x0.75\", 1x0.5\", 1x0.75\", 1x1\", 1.25x0.5\", 1.25x0.75\", 1.25x1.25\"","MRP":"Rs. 90","Source":"https://www.makankidukan.com/building-product/astral-pipe-brass-fpt-x-soc-elbow-90-degree-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Female Ext. Brass- Thd X Soc Elbow 90 Degree', 'CPVC fitting with high-temperature resistance and a smooth inner surface that reduces friction and pressure loss. Offers corrosion resistance to acids, bases, salts, and oxidants, with easy installation via solvent-cement joining. UV stabilized for indoor/limited outdoor use, with high impact strength durable under pressure.

Available sizes/variants: 0.75 x 0.5 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 235, 'https://www.makankidukan.com/uploads/products/1748928828_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748928828_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Size/Capacity":"0.75 x 0.5 inch","Temperature Resistance":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Impact Strength":"High—durable under pressure","UV Stabilization":"Yes, for indoor/limited outdoor use","Available Sizes":"0.75 x 0.5 inch","MRP":"Rs. 235","Source":"https://www.makankidukan.com/building-product/astral-pipe-female-ext-brass-thd-x-soc-elbow-90-degree-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Male Ext. Brass- Thd X Soc Elbow 90 Degree', 'CPVC fitting with smooth inner surface that reduces friction and ensures better flow with lesser pressure drops. Fire resistant with easy solvent-cement installation, lightweight design, resistant to acids, bases, salts, and oxidants.

Available sizes/variants: 0.75 x 0.5 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 185, 'https://www.makankidukan.com/uploads/products/1748929007_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748929007_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Size/Capacity":"0.75 x 0.5 inch","Temperature Resistance":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Impact Strength":"High","UV Stabilization":"Yes","Corrosion Resistance":"Resistant to acids, bases, salts, oxidants","Available Sizes":"0.75 x 0.5 inch","MRP":"Rs. 185","Source":"https://www.makankidukan.com/building-product/astral-pipe-male-ext-brass-thd-x-soc-elbow-90-degree-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Brass- Thd X Soc Elbow With Clamp', 'CPVC fittings for residential, commercial, and industrial settings. High-temperature resistance, corrosion resistance to acids, bases, salts, and oxidants, and smooth inner surface for improved flow. High impact strength suitable for pressurized conditions, with UV stabilizers and impact modifiers for enhanced durability. Lightweight and straightforward installation.

Available sizes/variants: 0.75 x 0.5 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 122, 'https://www.makankidukan.com/uploads/products/1748929229_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748929229_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Size/Capacity":"0.75 x 0.5 inch","Thickness":"0.75 x 0.5 inch","Temperature Resistance":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilized":"Yes","Available Sizes":"0.75 x 0.5 inch","MRP":"Rs. 122","Source":"https://www.makankidukan.com/building-product/astral-pipe-brass-thd-x-soc-elbow-with-clamp-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Brass Fpt - Soc Tee', 'CPVC fittings designed for residential, commercial, and industrial plumbing applications. High-temperature resistance handling water up to 93°C continuously, corrosion immunity to acids, bases, salts, oxidants, and a smooth inner surface that reduces friction and pressure drops. Installed via solvent-cement joining, lightweight.

Available sizes/variants: 0.5 x 0.5 x 0.5 inch; 0.75 x 0.75 x 0.5 inch; 0.75 x 0.75 x 0.75 inch; 1 x 1 x 0.5 inch; 1 x 1 x 0.75 inch; 1 x 1 x 1 inch; 1.25 x 1.25 x 1.25 inch; 1.25 x 1.25 x 1.5 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 114, 'https://www.makankidukan.com/uploads/products/1748929724_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748929724_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F) continuous","Corrosion Resistance":"Immune to acids, bases, salts, oxidants","Impact Strength":"High, durable under pressure","UV Stabilization":"Yes (indoor & limited outdoor use)","Installation":"Solvent-cement joining, lightweight","Standards":"ASTM D2846, ASTM F441, IS 15778","Available Sizes":"0.5 x 0.5 x 0.5 inch; 0.75 x 0.75 x 0.5 inch; 0.75 x 0.75 x 0.75 inch; 1 x 1 x 0.5 inch; 1 x 1 x 0.75 inch; 1 x 1 x 1 inch; 1.25 x 1.25 x 1.25 inch; 1.25 x 1.25 x 1.5 inch","MRP":"Rs. 114","Source":"https://www.makankidukan.com/building-product/astral-pipe-brass-fpt-soc-tee-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Male Brass Tee - Thd X Soc', 'Fittings suited for residential, commercial, and industrial piping systems. High-temperature resistance and corrosion resistance to acids, bases, salts, and oxidants. Installation is straightforward using solvent-cement joining.

Available sizes/variants: 0.75 x 0.75 x 0.5 inch; 1 x 1 x 0.5 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 193, 'https://www.makankidukan.com/uploads/products/1748929930_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748929930_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Available Sizes":"0.75 x 0.75 x 0.5 inch; 1 x 1 x 0.5 inch","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"Corrosion resistant, high impact strength, UV stabilized, smooth inner surface, fire resistant","MRP":"Rs. 193","Source":"https://www.makankidukan.com/building-product/astral-pipe-male-brass-tee-thd-x-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Male Adaptor (brass Thd X Soc)', 'CPVC male adaptor offering high-temperature resistance, corrosion immunity, smooth internal surfaces for improved flow, and lightweight installation via solvent-cement joining. Resists acids, bases, salts, and oxidants while maintaining dimensional precision.

Available sizes/variants: 0.5 inch; 0.75 inch; 1 inch; 1.25 inch; 1.5 inch; 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 206, 'https://www.makankidukan.com/uploads/products/1748930266_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748930266_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Connection Type":"Brass Threaded (THD) x Socket (SOC)","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Impact Strength":"High-impact resistant","UV Stabilization":"Yes","Available Sizes":"0.5 inch; 0.75 inch; 1 inch; 1.25 inch; 1.5 inch; 2 inch","MRP":"Rs. 206","Source":"https://www.makankidukan.com/building-product/astral-pipe-male-adaptor-brass-thd-x-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Reducer Coupler (brass Thd X Soc)', 'Made from Chlorinated Polyvinyl Chloride, suitable for residential, commercial, and industrial applications. Features continuous hot water capability up to 93°C and employs solvent-cement joining methods.

Available sizes/variants: 0.75 x 0.5 inch; 1 x 0.5 inch; 1 x 0.75 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 111, 'https://www.makankidukan.com/uploads/products/1748930528_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748930528_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Resistance":"Up to 93°C (200°F)","Corrosion Resistance":"Immune to acids, bases, salts, oxidants","Surface":"Smooth inner surface reducing friction","Impact Strength":"High-impact rated for pressure conditions","UV Stabilization":"Yes, for indoor/limited outdoor use","Manufacturing Standards":"ASTM D2846, ASTM F441, IS 15778","Connection Type":"Brass threaded x socket","Installation":"Lightweight; solvent-cement joining","Available Sizes":"0.75 x 0.5 inch; 1 x 0.5 inch; 1 x 0.75 inch","MRP":"Rs. 111","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-coupler-brass-thd-x-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Reducer Male Adaptor (brass Thd X Soc)', 'Reducer male adaptor with smooth inner surface reducing friction, lightweight and simple solvent-cement joining for easy installation. Includes UV stabilizers and impact modifiers for enhanced durability.

Available sizes/variants: 0.75 x 0.5 inch; 1 x 0.5 inch; 1 x 0.75 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 167, 'https://www.makankidukan.com/uploads/products/1748930812_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748930812_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Connection Type":"Brass Threaded x Socket","Temperature Resistance":"Up to 93°C (200°F) continuously","Corrosion Resistance":"Resistant to acids, bases, salts, oxidants","Standards":"ASTM D2846, ASTM F441, IS 15778","Impact Strength":"High-pressure rated, durable construction","UV Stabilization":"Yes, suitable for indoor and limited outdoor use","Available Sizes":"0.75 x 0.5 inch; 1 x 0.5 inch; 1 x 0.75 inch","MRP":"Rs. 167","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-male-adaptor-brass-thd-x-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Female Adaptor (brass Thd X Soc)', 'This CPVC fitting is engineered for residential, commercial, and industrial plumbing applications. It offers high-temperature resistance capable of handling water up to 93°C continuously, with corrosion resistance against acids, bases, salts, and oxidants. The design features a smooth internal surface that reduces friction, ensuring better flow and lesser pressure drops. The adaptor demonstrates high impact strength for pressurized systems and includes UV stabilization for both indoor and limited outdoor installations. Installation involves lightweight, solvent-cement joining methods.

Available sizes/variants: 0.5", 0.75", 1", 1.25", 1.5", 2"

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 199, 'https://www.makankidukan.com/uploads/products/1748931825_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748931825_0.jpg'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Female Adaptor (Brass Threaded x Socket)","Standards":"ASTM D2846, ASTM F441, IS 15778","Temperature Rating":"Up to 93°C (200°F) continuous","Key Features":"Fire resistant, UV stabilized, precise tolerances","Available Sizes":"0.5\", 0.75\", 1\", 1.25\", 1.5\", 2\"","MRP":"Rs. 199","Source":"https://www.makankidukan.com/building-product/astral-pipe-female-adaptor-brass-thd-x-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Male Union (brass Thd X Soc)', 'Constructed from Chlorinated Polyvinyl Chloride (CPVC) material, suitable for residential, commercial, and industrial use. Key capabilities include handling water temperatures up to 93°C continuously, resisting corrosion from acids/bases/salts, and featuring a smooth interior surface that minimizes friction and pressure loss. The product offers high impact strength, UV stabilization for indoor and limited outdoor settings, lightweight construction, and simple solvent-cement installation methods.

Available sizes/variants: 0.5", 0.75", 1", 1.25", 1.5", 2"

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 241, 'https://www.makankidukan.com/uploads/products/1748932206_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748932206_0.png'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Connector Type":"Brass Threaded x Socket","Standards":"ASTM D2846, ASTM F441, IS 15778","Temperature Rating":"Up to 93°C (200°F) continuous","Corrosion Resistance":"Yes","UV Stabilization":"Yes","Available Sizes":"0.5\", 0.75\", 1\", 1.25\", 1.5\", 2\"","MRP":"Rs. 241","Source":"https://www.makankidukan.com/building-product/astral-pipe-male-union-brass-thd-x-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Female Union (brass Thd X Soc)', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, suitable for residential, commercial, and industrial uses. Key capabilities include temperature resistance up to 93°C, corrosion immunity to acids/bases/salts, smooth inner surface reducing friction, high impact strength, UV stabilization, precise manufacturing with tight tolerances, and lightweight solvent-cement installation.

Available sizes/variants: 0.5", 0.75", 1", 1.25", 1.5", 2"

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 238, 'https://www.makankidukan.com/uploads/products/1748932541_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748932541_0.webp'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Type":"Female Union (Brass Threaded x Socket)","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Features":"UV stabilized, corrosion resistant, fire resistant, smooth inner surface","Available Sizes":"0.5\", 0.75\", 1\", 1.25\", 1.5\", 2\"","MRP":"Rs. 238","Source":"https://www.makankidukan.com/building-product/astral-pipe-female-union-brass-thd-x-soc-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Concealed Valve Swept Type Chrome Plate (flower) Long', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. Smooth inner surfaces reduce friction and pressure drops. Key features: high temperature resistance, pressure endurance, corrosion resistance, fire resistance, long service life, easy installation.

Available sizes/variants: 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1424, 'https://www.makankidukan.com/uploads/products/1748935188_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748935188_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Resistance":"Up to 93°C (200°F) continuously","Corrosion Resistance":"Resistant to acids, bases, salts, oxidants","Standards":"ASTM D2846, ASTM F441, IS 15778","Color":"Chrome Plate","Impact Strength":"High-impact capable under pressure","UV Stabilization":"Yes, for indoor and limited outdoor use","Installation":"Solvent-cement joining method","Price incl. GST":"Rs. 890.57","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 1424","Source":"https://www.makankidukan.com/building-product/astral-pipe-concealed-valve-swept-type-chrome-plateflower-long-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Concealed Valve Swept Type Chrome Plate (flower) Short', 'CPVC fittings designed for residential, commercial, and industrial applications with smooth flow characteristics, tough durability, and precise manufacturing tolerances. Product highlights: high temperature resistance, pressure endurance, corrosion resistance, fire resistance, long service life, easy installation.

Available sizes/variants: 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1202, 'https://www.makankidukan.com/uploads/products/1748935551_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748935551_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Resistance":"Up to 93°C (200°F) continuously","Corrosion Resistance":"Immune to acids, bases, salts, oxidants","Standards":"ASTM D2846, ASTM F441, IS 15778","Surface":"Smooth inner surface for reduced friction","UV Stabilized":"Yes, for indoor and limited outdoor use","Impact Strength":"High-impact durable construction","Installation":"Solvent-cement joining, lightweight","Price incl. GST":"Rs. 751.73","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 1202","Source":"https://www.makankidukan.com/building-product/astral-pipe-concealed-valve-swept-type-chrome-plateflower-short-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Concealed Valve Wheel Type', 'Manufactured from Chlorinated Polyvinyl Chloride (CPVC) material for residential, commercial, and industrial applications. Handles water temperatures up to 93°C continuously, resists acids/bases/salts/oxidants, has smooth inner surfaces for reduced friction, high impact strength under pressure, UV stabilization for indoor and limited outdoor use, precise manufacturing tolerances, and lightweight construction with solvent-cement joining.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 706, 'https://www.makankidukan.com/uploads/products/1748936163_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748936163_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Type":"Concealed Valve, Wheel Type","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Max Temperature":"93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Price incl. GST":"Rs. 441.53","Available Sizes":"0.5 inch, 0.75 inch, 1 inch","MRP":"Rs. 706","Source":"https://www.makankidukan.com/building-product/astral-pipe-concealed-valve-wheel-type-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Concealed Valve Swept Type Chrome Plated Triangle Long', 'Manufactured for residential, commercial, and industrial piping systems from CPVC. Tight dimensional tolerances ensure precise installation, with UV stabilizers and impact modifiers incorporated for enhanced durability. Features high-temperature resistance, pressure endurance, corrosion resistance to acids, bases, salts, and oxidants, smooth inner surface minimizing friction and pressure drops, high impact strength, simple solvent-cement joining, and fire resistant properties.

Available sizes/variants: 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1347, 'https://www.makankidukan.com/uploads/products/1748936518_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748936518_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Resistance":"Up to 93°C (200°F) continuously","Color":"Chrome Plated","UV Stabilization":"Yes","Standards":"ASTM D2846, ASTM F441, IS 15778","Price incl. GST":"Rs. 842.41","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 1347","Source":"https://www.makankidukan.com/building-product/astral-pipe-concealed-valve-swept-type-chrome-plated-triangle-long-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Concealed Valve Swept Type Chrome Plated Triangle Short', 'Suitable for residential, commercial, industrial applications. Features high-temperature resistance, pressure endurance, and fire resistance, reduced friction due to smooth interior, high impact strength under pressure, lightweight with solvent-cement joining method.

Available sizes/variants: 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1136, 'https://www.makankidukan.com/uploads/products/1748936670_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748936670_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F) continuously","Corrosion Resistance":"Resistant to acids, bases, salts, oxidants","UV Stabilization":"Yes","Standards":"ASTM D2846, ASTM F441, IS 15778","Surface Type":"Smooth inner surface","Color":"Chrome Plated","Price incl. GST":"Rs. 710.45","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 1136","Source":"https://www.makankidukan.com/building-product/astral-pipe-concealed-valve-swept-type-chrome-plated-triangle-short-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Concealed Valve Swept Type Chrome Plated Round Long', 'Offers high-temperature resistance, corrosion immunity to acids/bases/salts, reduced friction flow, high impact durability, and easy installation via solvent-cement joining. Incorporates UV stabilizers and impact modifiers for enhanced performance.

Available sizes/variants: 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1408, 'https://www.makankidukan.com/uploads/products/1748937010_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748937010_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F)","Standards":"ASTM D2846, ASTM F441, IS 15778","Surface":"Smooth inner surface","UV Treatment":"UV stabilized","Finish":"Chrome plated","Price incl. GST":"Rs. 880.56","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 1408","Source":"https://www.makankidukan.com/building-product/astral-pipe-concealed-valve-swept-type-chrome-plated-round-long-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Concealed Valve Swept Type Chrome Plated Round Short', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, ideal for residential, commercial, and industrial applications. Features high-temperature capability up to 93°C, corrosion resistance, smooth inner surfaces for improved flow, high impact strength, UV stabilization, and easy installation: lightweight and simple solvent-cement joining.

Available sizes/variants: 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1193, 'https://www.makankidukan.com/uploads/products/1748937143_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748937143_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Concealed Valve, Swept Type","Finish":"Chrome Plated","Shape":"Round Short","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilized":"Yes","Price incl. GST":"Rs. 746.10","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 1193","Source":"https://www.makankidukan.com/building-product/astral-pipe-concealed-valve-swept-type-chrome-plated-round-short-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Ball Valve Cts Socket', 'CPVC ball valve with CTS socket connection offering high temperature resistance, pressure endurance, corrosion resistance, smooth inner surface, fire resistance, long service life, and easy installation. Reduced friction flow, high impact strength, tight manufacturing tolerances, lightweight construction with impact modifiers and UV stabilizers for enhanced durability.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 133, 'https://www.makankidukan.com/uploads/products/1748937646_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748937646_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Corrosion Resistance":"Resistant to acids, bases, salts, oxidants","UV Stabilization":"Yes (suitable for limited outdoor use)","Installation Method":"Solvent-cement joining","Connection Type":"CTS Socket","Price incl. GST":"Rs. 83.18","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 133","Source":"https://www.makankidukan.com/building-product/astral-pipe-ball-valve-cts-socket-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Ball Valve Long Handle Cts Socket CPVC Pipes Fitting', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The valve features high-temperature resistance handling water up to 93°C, corrosion resistance, smooth inner surface for optimal flow, high impact strength, and UV stabilization. It meets ASTM D2846, ASTM F441, and IS 15778 standards with easy solvent-cement installation.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 123, 'https://www.makankidukan.com/uploads/products/1748943747_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748943747_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Ball Valve with Long Handle","Connection":"CTS Socket","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Features":"UV Stabilized, Impact Modifiers, Corrosion Resistant","Price Including GST":"Rs. 76.92","Return Policy":"7 days","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 123","Source":"https://www.makankidukan.com/building-product/astral-pipe-ball-valve-long-handle-cts-socket-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Fancy Handle Knob With Red & Blue Plastic Button Triangle CPVC Pipes Fitting', 'The fitting is constructed from CPVC material for residential, commercial, and industrial applications. Key capabilities include managing water up to 93°C (200°F) continuously, resistance to acids and bases, reduced friction through smooth surfaces, lightweight and simple solvent-cement joining, and compliance with standards including ASTM D2846, ASTM F441, and IS 15778.

Available sizes/variants: Common size, Thickness 0.75 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 361, 'https://www.makankidukan.com/uploads/products/1748944059_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748944059_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Thickness":"0.75 inch","Stock Status":"In Stock","Size/Capacity":"Common","Key Features":"High Temperature Resistance, Pressure Endurance, Corrosion Resistance, Smooth Inner Surface, Fire Resistance, Long Service Life, Easy Installation","Price Including GST":"Rs. 225.77","Return Policy":"7 days","Available Sizes":"Common size, Thickness 0.75 inch","MRP":"Rs. 361","Source":"https://www.makankidukan.com/building-product/astral-pipe-fancy-handle-knob-with-red-blue-plastic-button-triangle-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Fancy Handle Knob With Red & Blue Plastic Button Square CPVC Pipes Fitting', 'The product offers High-Temperature Resistance and Corrosion Resistance among other benefits including smooth inner surfaces, fire resistance, and easy installation suitable for residential and commercial applications. Made from Chlorinated Polyvinyl Chloride (CPVC), it complies with ASTM D2846, ASTM F441, and IS 15778 standards.

Available sizes/variants: Size/Capacity: common, Thickness: 0.75 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 353, 'https://www.makankidukan.com/uploads/products/1748944252_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748944252_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Thickness":"0.75 inch","Temperature Resistance":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Price Including GST":"Rs. 221.72","Stock Status":"In Stock","Return Policy":"7 days","Available Sizes":"Size/Capacity: common, Thickness: 0.75 inch","MRP":"Rs. 353","Source":"https://www.makankidukan.com/building-product/astral-pipe-fancy-handle-knob-with-red-blue-plastic-button-square-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Fancy Handle Knob With Red & Blue Plastic Button Round CPVC Pipes Fitting', 'The fitting is designed for residential, commercial, and industrial use. It resists acids, bases, and salts while maintaining structural integrity under high pressure. The product features lightweight construction enabling straightforward solvent-cement joining and incorporates UV stabilizers for durability.

Available sizes/variants: Size/Capacity: Common, Thickness: 0.75 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 353, 'https://www.makankidukan.com/uploads/products/1748944434_0.avif', ARRAY['https://www.makankidukan.com/uploads/products/1748944434_0.avif'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Size/Capacity":"Common","Thickness":"0.75 inch","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Price Including GST":"Rs. 221.72","Return Policy":"7 days","Available Sizes":"Size/Capacity: Common, Thickness: 0.75 inch","MRP":"Rs. 353","Source":"https://www.makankidukan.com/building-product/astral-pipe-fancy-handle-knob-with-red-blue-plastic-button-round-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Fancy Handle Knob With Red & Blue Plastic Button Flower CPVC Pipes Fitting', 'The product offers high-temperature resistance, corrosion resistance, and smooth inner surface to minimize friction. Additional benefits include impact strength, UV stabilization for indoor and limited outdoor use, and easy installation via solvent-cement joining with lightweight construction. Made from CPVC for residential, commercial, and industrial applications.

Available sizes/variants: Size/Capacity: Common (single option), Thickness: 0.75 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 353, 'https://www.makankidukan.com/uploads/products/1748944560_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748944560_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Thickness":"0.75 inch","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Price Including GST":"Rs. 221.72","Stock Status":"In Stock","Return Policy":"7 days","Available Sizes":"Size/Capacity: Common (single option), Thickness: 0.75 inch","MRP":"Rs. 353","Source":"https://www.makankidukan.com/building-product/astral-pipe-fancy-handle-knob-with-red-blue-plastic-button-flower-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Ball Valve Long Handle CPVC Pipes Fitting', 'Made from Chlorinated Polyvinyl Chloride (CPVC), these fittings suit residential, commercial, and industrial use. The material can handle water up to 93°C (200°F) continuously and resists most chemicals. Features include a smooth inner surface for improved flow, high impact strength, UV stabilization, lightweight construction, and solvent-cement joining installation.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 20, 'https://www.makankidukan.com/uploads/products/1748944895_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748944895_0.png'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"CPVC","Standards":"ASTM D2846, ASTM F441, IS 15778","Temperature Rating":"Up to 93°C (200°F)","Stock Status":"In Stock","Price Including GST":"Rs. 12.51","Return Policy":"7 days","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 20","Source":"https://www.makankidukan.com/building-product/astral-pipe-ball-valve-long-handle-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Ball Valve Handle CPVC Pipes Fitting', 'Made from Chlorinated Polyvinyl Chloride (CPVC), these fittings suit residential, commercial, and industrial uses. They handle water up to 93°C continuously, resist corrosion from acids, bases, and salts, and feature a smooth inner surface reducing friction. The material offers high impact strength, UV stabilization for indoor/outdoor use, precise manufacturing tolerances, and simple solvent-cement installation per ASTM D2846, ASTM F441, and IS 15778 standards.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 20, 'https://www.makankidukan.com/uploads/products/1748945302_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748945302_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Rating":"Up to 93°C (200°F) continuous","Corrosion Resistance":"Resistant to acids, bases, salts, oxidants","Features":"Smooth inner surface, high impact strength, UV stabilized","Installation":"Solvent-cement joining","Standards":"ASTM D2846, ASTM F441, IS 15778","Price Including GST":"Rs. 11.87","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 20","Source":"https://www.makankidukan.com/building-product/astral-pipe-ball-valve-handle-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe S.s. Flange With Rubber Gromet CPVC Pipes Fitting', 'This CPVC fitting is manufactured from Chlorinated Polyvinyl Chloride material, suitable for residential, commercial, and industrial applications. The product handles continuous water temperatures up to 93°C (200°F) and resists most acids, bases, salts, and oxidants. Features include a smooth inner surface reducing friction, high impact strength under pressure, UV stabilization for indoor/outdoor use, precise manufacturing tolerances, lightweight design with simple solvent-cement joining, and compliance with ASTM D2846, ASTM F441, and IS 15778 standards.

Available sizes/variants: common size category with 0.75 inch thickness

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 163, 'https://www.makankidukan.com/uploads/products/1748945725_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748945725_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Thickness":"0.75 inch","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Stock Status":"In Stock","Standards":"ASTM D2846, ASTM F441, IS 15778","Price Including GST":"Rs. 101.94","Return Policy":"7 days","Available Sizes":"common size category with 0.75 inch thickness","MRP":"Rs. 163","Source":"https://www.makankidukan.com/building-product/astral-pipe-ss-flange-with-rubber-gromet-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Brass Pipe (c.p.) Short CPVC Pipes Fitting', 'Chlorinated Polyvinyl Chloride (CPVC) fittings designed for residential, commercial, and industrial plumbing applications. Features solvent-cement joining for straightforward installation.

Available sizes/variants: 0.75 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 196, 'https://www.makankidukan.com/uploads/products/1748946102_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748946102_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Size/Thickness":"0.75 inch","Temperature Resistance":"Handles water up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Corrosion Resistance":"Resistant to acids, bases, salts, and oxidants","UV Stabilization":"UV stabilized for indoor and limited outdoor use","Additives":"Includes impact modifiers and UV stabilizers","Available Sizes":"0.75 inch","MRP":"Rs. 196","Source":"https://www.makankidukan.com/building-product/astral-pipe-brass-pipe-cp-short-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Brass Pipe (c.p.) Long CPVC Pipes Fitting', 'CPVC fittings designed for residential, commercial, and industrial plumbing applications. Features high-temperature resistance and corrosion resistance properties, making it suitable for various water distribution systems.

Available sizes/variants: 0.75 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 375, 'https://www.makankidukan.com/uploads/products/1748946239_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748946239_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Thickness":"0.75 inch","Temperature Rating":"Handles water up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"UV stabilized, smooth inner surface, high impact strength, easy solvent-cement installation","Color":"Standard (brass/metallic finish implied by C.P. designation)","Available Sizes":"0.75 inch","MRP":"Rs. 375","Source":"https://www.makankidukan.com/building-product/astral-pipe-brass-pipe-cp-long-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Spindle Valve Part With Gasket Short CPVC Pipes Fitting', 'Chlorinated Polyvinyl Chloride (CPVC) fittings designed for residential, commercial, and industrial plumbing applications with solvent-cement joining capabilities.

Available sizes/variants: 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 347, 'https://www.makankidukan.com/uploads/products/1748949745_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748949745_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Resistance":"Handles water up to 93°C (200°F) continuously","Corrosion Resistance":"Immune to acids, bases, salts, and oxidants","Impact Strength":"High-pressure durable construction","UV Stabilization":"Suitable for indoor and limited outdoor use","Standards":"ASTM D2846, ASTM F441, IS 15778","Surface":"Smooth inner surface reducing friction","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 347","Source":"https://www.makankidukan.com/building-product/astral-pipe-spindle-valve-part-with-gasket-short-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Spindle Valve Part With Gasket Long CPVC Pipes Fitting', 'Manufactured from Chlorinated Polyvinyl Chloride (CPVC) material, suited for residential, commercial, and industrial applications.

Available sizes/variants: 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 539, 'https://www.makankidukan.com/uploads/products/1748950029_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748950029_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Resistance":"Handles water up to 93°C (200°F) continuously","Corrosion Resistance":"Resistant to acids, bases, salts, and oxidants","Standards":"ASTM D2846, ASTM F441, IS 15778","Features":"Smooth inner surface, high impact strength, UV stabilized, easy solvent-cement joining","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 539","Source":"https://www.makankidukan.com/building-product/astral-pipe-spindle-valve-part-with-gasket-long-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Extension Pieces Chrome Plated Medium Duty CPVC Pipes Fitting', 'These fittings are manufactured from Chlorinated Polyvinyl Chloride and serve residential, commercial, and industrial applications. They feature lightweight construction with simple solvent-cement joining methodology.

Available sizes/variants: 1 inch, 1.5 inch, 2 inch, 2.5 inch, 3 inch, 4 inch, 5 inch, 6 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 61, 'https://www.makankidukan.com/uploads/products/1748950447_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748950447_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Color":"Chrome plated","Temperature Resistance":"Handles water up to 93°C continuously","Corrosion Resistance":"Resistant to acids, bases, salts, and oxidants","Standards":"ASTM D2846, ASTM F441, IS 15778","Surface":"Smooth inner surface reducing friction","Impact Strength":"High-impact durable construction","UV Stabilization":"Suitable for indoor and limited outdoor use","Available Sizes":"1 inch, 1.5 inch, 2 inch, 2.5 inch, 3 inch, 4 inch, 5 inch, 6 inch","MRP":"Rs. 61","Source":"https://www.makankidukan.com/building-product/astral-pipe-extension-pieces-chrome-plated-medium-duty-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Extension Pieces Chrome Plated Heavy Duty CPVC Pipes Fitting', 'Extension pieces manufactured from Chlorinated Polyvinyl Chloride designed for residential, commercial, and industrial piping applications with solvent-cement joining capabilities.

Available sizes/variants: 1 inch, 1.5 inch, 2 inch, 2.5 inch, 3 inch, 4 inch, 5 inch, 6 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 74, 'https://www.makankidukan.com/uploads/products/1748950753_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748950753_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Resistance":"Handles water up to 93°C (200°F) continuously","Corrosion Resistance":"Resistant to acids, bases, salts, and oxidants","Surface":"Smooth inner surface reduces friction","Impact Strength":"High-impact durability under pressure","UV Stabilization":"Suitable for indoor and limited outdoor use","Standards":"ASTM D2846, ASTM F441, IS 15778","Installation":"Lightweight with easy solvent-cement joining","Color":"Chrome plated finish","Available Sizes":"1 inch, 1.5 inch, 2 inch, 2.5 inch, 3 inch, 4 inch, 5 inch, 6 inch","MRP":"Rs. 74","Source":"https://www.makankidukan.com/building-product/astral-pipe-extension-pieces-chrome-plated-heavy-duty-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Spindle Valve Part With Gasket CPVC Pipes Fitting', 'Chlorinated Polyvinyl Chloride (CPVC) fitting designed for residential, commercial, and industrial applications, featuring high-temperature resistance and corrosion immunity to most chemicals.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 484, 'https://www.makankidukan.com/uploads/products/1748950919_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748950919_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"Corrosion resistant, smooth inner surface, high impact strength, UV stabilized, lightweight, solvent-cement joining","Additives":"UV stabilizers and impact modifiers","Available Sizes":"0.5 inch, 0.75 inch, 1 inch","MRP":"Rs. 484","Source":"https://www.makankidukan.com/building-product/astral-pipe-spindle-valve-part-with-gasket-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Wheel Type Valve CPVC Pipes Fitting', 'CPVC fittings manufactured for residential, commercial, and industrial applications. The product features solvent-cement joining and meets international manufacturing standards.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 454, 'https://www.makankidukan.com/uploads/products/1749013960_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749013960_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Resistance":"Can handle water up to 93°C (200°F) continuously","Corrosion Resistance":"Resistant to acids, bases, salts, and oxidants","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"UV stabilized, high impact strength, smooth inner surface, lightweight","Additives":"Includes UV stabilizers and impact modifiers","Available Sizes":"0.5 inch, 0.75 inch, 1 inch","MRP":"Rs. 454","Source":"https://www.makankidukan.com/building-product/astral-pipe-wheel-type-valve-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Concealed Chrome Plate Valve', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, this fitting offers high-temperature resistance, pressure endurance, corrosion resistance, smooth inner surface, fire resistance, and long service life with easy installation. Temperature resistance up to 93°C (200°F) continuously; corrosion resistant to acids, bases, salts, and oxidants; UV stabilized for indoor and limited outdoor use; installed via solvent-cement joining, lightweight.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 983, 'https://www.makankidukan.com/uploads/products/1749014307_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749014307_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Resistance":"Up to 93°C (200°F) continuously","Corrosion Resistance":"Immune to acids, bases, salts, and oxidants","UV Stabilized":"Yes, suitable for indoor and limited outdoor use","Installation":"Solvent-cement joining; lightweight","Manufacturing Standards":"ASTM D2846, ASTM F441, IS 15778","Additives":"UV stabilizers and impact modifiers","Available Sizes":"0.5 inch, 0.75 inch, 1 inch","MRP":"Rs. 983","Source":"https://www.makankidukan.com/building-product/astral-pipe-concealed-chrome-plate-valve-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Long Radius Bend', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The product handles hot water up to 93°C continuously and resists corrosion from acids, bases, salts, and oxidants. Features include a smooth inner surface reducing friction, high impact strength, UV stabilization, and lightweight solvent-cement joining installation.

Available sizes/variants: 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 103, 'https://www.makankidukan.com/uploads/products/1749014619_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749014619_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"Corrosion resistant, high impact strength, UV stabilized, smooth inner surface, fire resistant","Installation":"Solvent-cement joining","Additional Additives":"UV stabilizers, impact modifiers","Available Sizes":"0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 103","Source":"https://www.makankidukan.com/building-product/astral-pipe-long-radius-bend-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Step Over Bend', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The fitting handles water up to 93°C continuously and resists corrosion from acids, bases, salts, and oxidants. Features include smooth inner surfaces reducing friction, high impact strength, UV stabilization, and lightweight solvent-cement joining for simple installation.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 82, 'https://www.makankidukan.com/uploads/products/1749014969_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749014969_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Resistance":"Up to 93°C (200°F) continuous operation","Corrosion Resistance":"Immune to acids, bases, salts, oxidants","Standards":"ASTM D2846, ASTM F441, IS 15778","Inner Surface":"Smooth design for reduced friction","Impact Strength":"High durability under pressure","UV Protection":"Stabilized for indoor/limited outdoor use","Installation":"Solvent-cement joining method","Additives":"UV stabilizers and impact modifiers","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 82","Source":"https://www.makankidukan.com/building-product/astral-pipe-step-over-bend-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral All Top Adaptor 3 In 1 Wall Mixer', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The adaptor handles water temperatures up to 93°C continuously and resists corrosion from acids, bases, and salts. Installation involves lightweight solvent-cement joining.

Available sizes/variants: 0.75 x 0.5 inch, 1 x 0.5 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 497, 'https://www.makankidukan.com/uploads/products/1749015386_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749015386_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Available Sizes":"0.75 x 0.5 inch, 1 x 0.5 inch","Temperature Rating":"Up to 93°C (200°F)","Standards":"ASTM D2846, ASTM F441, IS 15778","Features":"UV stabilized, high impact strength, smooth inner surface, fire resistant","MRP":"Rs. 497","Source":"https://www.makankidukan.com/building-product/astral-pipe-all-top-adaptor-3-in-1-wall-mixer-adaptor-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Top Bottom Adaptor 3 In 1 Wall Mixer', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, this fitting handles water temperatures up to 93°C continuously. It features a smooth inner surface that reduces friction and pressure drops, along with high impact strength for durability under pressure. The product is UV stabilized for indoor and limited outdoor use, manufactured per ASTM D2846, ASTM F441, and IS 15778 standards. Offers high temperature and pressure endurance, fire resistance, corrosion resistance, easy installation and long service life.

Available sizes/variants: 0.75 x 0.5 inch, 1 x 0.5 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 497, 'https://www.makankidukan.com/uploads/products/1749015838_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749015838_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Resistance":"Up to 93°C (200°F)","Corrosion Resistance":"Resistant to acids, bases, salts, oxidants","Standards":"ASTM D2846, ASTM F441, IS 15778","Installation":"Solvent-cement joining","Weight Profile":"Lightweight","Available Sizes":"0.75 x 0.5 inch, 1 x 0.5 inch","MRP":"Rs. 497","Source":"https://www.makankidukan.com/building-product/astral-pipe-top-bottom-adaptor-3-in-1-wall-mixer-adaptor-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Top Side Adaptor 3 In 1 Wall Mixer', 'Made from CPVC material, this 3-in-1 wall mixer adaptor handles water temperatures up to 93°C continuously. Features include corrosion resistance to acids, bases, and salts; smooth inner surface reducing friction; high impact strength for pressure conditions; and UV stabilization for indoor/limited outdoor use. Installation involves lightweight solvent-cement joining with tight dimensional tolerances.

Available sizes/variants: 0.75 x 0.5 inch, 1 x 0.5 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 497, 'https://www.makankidukan.com/uploads/products/1749016094_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749016094_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Application":"Residential, commercial, industrial","Inner Surface":"Smooth (reduces friction/pressure drops)","UV Stabilized":"Yes","Installation Method":"Solvent-cement joining","Available Sizes":"0.75 x 0.5 inch, 1 x 0.5 inch","MRP":"Rs. 497","Source":"https://www.makankidukan.com/building-product/astral-pipe-top-side-adaptor-3-in-1-wall-mixer-adaptor-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Hot Up-cold Down Adaptor 3 In 1', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The adaptor features a smooth interior surface to reduce friction and pressure drops, with high impact strength for durability under demanding conditions.

Available sizes/variants: 0.75 x 0.5 inch, 1 x 0.5 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 497, 'https://www.makankidukan.com/uploads/products/1749016422_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749016422_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Resistance":"Up to 93°C (200°F) continuously","Corrosion Resistance":"Resistant to acids, bases, salts, and oxidants","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilization":"Yes, for indoor and limited outdoor use","Installation":"Solvent-cement joining, lightweight","Additives":"UV stabilizers, impact modifiers","Available Sizes":"0.75 x 0.5 inch, 1 x 0.5 inch","MRP":"Rs. 497","Source":"https://www.makankidukan.com/building-product/astral-pipe-hot-up-cold-down-adaptor-3-in-1-wall-mixer-adaptor-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Hot Side-cold Down Adaptor 3 In 1', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The adaptor features high-temperature resistance up to 93°C, corrosion resistance, smooth inner surface for optimal flow, high impact strength, UV stabilization, and easy solvent-cement installation.

Available sizes/variants: 0.75 x 0.5 inch, 1 x 0.5 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 497, 'https://www.makankidukan.com/uploads/products/1749016732_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749016732_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Type":"3 in 1 Wall Mixer Adaptor","Available Sizes":"0.75 x 0.5 inch, 1 x 0.5 inch","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"UV stabilized, corrosion resistant, fire resistant, smooth inner surface","Installation":"Lightweight, solvent-cement joining","MRP":"Rs. 497","Source":"https://www.makankidukan.com/building-product/astral-pipe-hot-side-cold-down-adaptor-3-in-1-wall-mixer-adaptor-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe End Plug Threaded CPVC Pipes Fitting', 'These fittings are constructed from Chlorinated Polyvinyl Chloride and suit residential, commercial, and industrial applications. They feature solvent-cement joining for straightforward setup.

Available sizes/variants: 0.5 inch, 0.75 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 14, 'https://www.makankidukan.com/uploads/products/1749017008_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749017008_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Capability":"Handles water up to 93°C continuously","Corrosion Resistance":"Immune to most acids, bases, salts, and oxidants","Inner Surface":"Smooth design reduces friction","Impact Strength":"High durability under pressure","UV Stabilization":"Suitable for indoor and limited outdoor use","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Attributes":"Fire resistant, lightweight, precise manufacturing","Available Sizes":"0.5 inch, 0.75 inch","MRP":"Rs. 14","Source":"https://www.makankidukan.com/building-product/astral-pipe-end-plug-threaded-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Tee Holder CPVC Pipes Fitting', 'The fitting is made from chlorinated polyvinyl chloride and designed for residential, commercial, and industrial plumbing applications. It features solvent-cement joining for straightforward setup and handles continuous water temperatures up to 93°C.

Available sizes/variants: 0.5 x 0.5 inch, 0.75 x 0.5 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 10, 'https://www.makankidukan.com/uploads/products/1749019658_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749019658_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F) continuous","Available Sizes":"0.5 x 0.5 inch, 0.75 x 0.5 inch","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Properties":"High impact strength, corrosion-resistant, smooth inner surface, UV stabilized","Additives":"UV stabilizers, impact modifiers, specialty chemicals","MRP":"Rs. 10","Source":"https://www.makankidukan.com/building-product/astral-pipe-tee-holder-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Elbow Holder CPVC Pipes Fitting', 'The product is manufactured from Chlorinated Polyvinyl Chloride (CPVC) material, suitable for residential, commercial, and industrial piping applications. It features lightweight construction with solvent-cement joining for straightforward installation.

Available sizes/variants: 0.5 x 0.5 inch, 0.75 x 0.5 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 10, 'https://www.makankidukan.com/uploads/products/1749019794_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749019794_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Rating":"Continuous use up to 93°C (200°F)","Key Properties":"Corrosion-resistant, high impact strength, UV-stabilized, smooth internal surface","Standards":"ASTM D2846, ASTM F441, IS 15778","Features":"Fire-resistant, pressure-enduring, long service life","Available Sizes":"0.5 x 0.5 inch, 0.75 x 0.5 inch","MRP":"Rs. 10","Source":"https://www.makankidukan.com/building-product/astral-pipe-elbow-holder-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Sweep Bend With Both Side Socket CPVC Pipes Fitting', 'This fitting is manufactured from Chlorinated Polyvinyl Chloride and serves residential, commercial, and industrial plumbing applications. It can handle water up to 93°C (200°F) continuously and offers resistance to corrosion from acids, bases, salts, and oxidants. Features include a smooth inner surface to minimize friction and pressure loss, high impact strength for durability, UV stabilization, and lightweight construction enabling straightforward solvent-cement installation.

Available sizes/variants: 0.75 inch, 1 inch, 1.25 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 71, 'https://www.makankidukan.com/uploads/products/1749020041_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749020041_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Rating":"Up to 93°C (200°F) continuous","Available Sizes":"0.75 inch, 1 inch, 1.25 inch","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"High temperature resistance, corrosion resistance, smooth inner surface, high impact strength, UV stabilized, precise manufacturing","MRP":"Rs. 71","Source":"https://www.makankidukan.com/building-product/astral-pipe-sweep-bend-with-both-side-socket-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Step Over Bend L CPVC Pipes Fitting', 'These fittings are manufactured from Chlorinated Polyvinyl Chloride for residential, commercial, and industrial use. They feature high-temperature resistance handling water up to 93°C continuously, corrosion immunity to acids and bases, and a smooth inner surface that reduces friction and pressure drops.

Available sizes/variants: 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 155, 'https://www.makankidukan.com/uploads/products/1749020253_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749020253_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Rating":"Up to 93°C (200°F) continuously","Key Features":"UV stabilized, high impact strength, tight dimensional tolerances","Standards":"ASTM D2846, ASTM F441, IS 15778","Installation":"Solvent-cement joining (lightweight)","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 155","Source":"https://www.makankidukan.com/building-product/astral-pipe-step-over-bend-l-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Wye Strainer CPVC Pipes Fitting', 'CPVC fittings designed for residential, commercial, and industrial plumbing applications, featuring enhanced durability through UV stabilizers, impact modifiers, and specialty additives for optimal performance. Offers high temperature and pressure endurance, corrosion resistance, smooth inner surface reducing friction, fire resistance with long service life, easy installation, and high impact strength under pressure.

Available sizes/variants: 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1214, 'https://www.makankidukan.com/uploads/products/1749021800_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749021800_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Resistance":"Up to 93°C (200°F) continuously","Corrosion Resistance":"Resistant to acids, bases, salts, oxidants","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilization":"Yes, suitable for limited outdoor use","Installation Method":"Solvent-cement joining","Weight":"Lightweight","Available Sizes":"1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 1214","Source":"https://www.makankidukan.com/building-product/astral-pipe-wye-strainer-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Ratchet Cutter CPVC Pipes Fitting', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. Features include corrosion resistance, smooth inner surface reducing friction, high impact strength suitable for pressure conditions, lightweight design, and simple solvent-cement joining for installation. Key highlights include high temperature resistance, pressure endurance, corrosion resistance, smooth inner surface, fire resistance, long service life, and easy installation.

Available sizes/variants: 1.25 x 1.25 inch (common)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 649, 'https://www.makankidukan.com/uploads/products/1749022055_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749022055_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Size/Capacity":"Common","Thickness":"1.25 x 1.25 inch","Temperature Resistance":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilized":"Yes","Available Sizes":"1.25 x 1.25 inch (common)","MRP":"Rs. 649","Source":"https://www.makankidukan.com/building-product/astral-pipe-ratchet-cutter-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Coupler Soc CPVC Schedule-40 Pipes Fitting', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings serve residential, commercial, and industrial applications. The product offers a smooth inner surface reducing friction, lightweight construction enabling simple solvent-cement joining, and immunity to acids, bases, and salts. Key highlights include high temperature resistance, pressure endurance, corrosion resistance, fire resistance, easy installation, and long service life.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 492, 'https://www.makankidukan.com/uploads/products/1749023033_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749023033_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Socket (SOC) Coupler","Schedule":"40","Temperature Resistance":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"Corrosion resistant, UV stabilized, high impact strength","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 492","Source":"https://www.makankidukan.com/building-product/astral-pipe-coupler-soc-cpvc-schedule-40-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Reducer Bushing Spg X Soc CPVC Schedule-40 Pipes Fitting', 'High-temperature resistance: can handle water up to 93°C (200°F) continuously. Corrosion-resistant to acids, bases, salts, and oxidants, with reduced friction via a smooth internal surface. UV stabilized construction offers high impact strength under pressure, lightweight design, and simple solvent-cement installation for residential, commercial, and industrial applications.

Available sizes/variants: 2.5x1, 2.5x1.25, 2.5x1.5, 2.5x2, 3x1, 3x1.5, 3x2, 3x2.5, 4x2, 4x2.5, 4x3 (inches)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 487, 'https://www.makankidukan.com/uploads/products/1749027407_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749027407_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Reducer Bushing, SPG x SOC","Schedule":"Schedule 40","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Available Sizes":"2.5x1, 2.5x1.25, 2.5x1.5, 2.5x2, 3x1, 3x1.5, 3x2, 3x2.5, 4x2, 4x2.5, 4x3 (inches)","MRP":"Rs. 487","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-bushing-spg-x-soc-cpvc-schedule-40-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Tee Soc CPVC Schedule-40 Pipes Fitting', 'CPVC pipe fittings manufactured from Chlorinated Polyvinyl Chloride material suitable for residential, commercial, and industrial use. Designed to handle temperatures up to 93°C continuously with resistance to acids, bases, salts, and oxidants. Features a smooth internal surface that minimizes friction and pressure loss. Incorporates high impact strength for durability under pressure conditions, UV stabilization for indoor and limited outdoor applications, and lightweight construction with solvent-cement joining method.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1089, 'https://www.makankidukan.com/uploads/products/1749023877_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749023877_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Schedule":"Schedule 40","Connection Type":"Socket (SOC)","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Installation Method":"Solvent-cement joining","UV Stabilized":"Yes","Corrosion Resistant":"Yes","Fire Resistance":"Yes","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 1089","Source":"https://www.makankidukan.com/building-product/astral-pipe-tee-soc-cpvc-schedule-40-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Reducer Tee Soc Schedule-40', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The product features high-temperature capability, corrosion resistance, smooth inner surfaces, and easy installation through solvent-cement joining.

Available sizes/variants: 3 x 2.5 inch, 4 x 2.5 inch, 4 x 3 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 885, 'https://www.makankidukan.com/uploads/products/1749024216_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749024216_0.webp'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Type":"Reducer Tee, Socket Connection (SOC)","Schedule":"40","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Corrosion Resistant":"Yes","UV Stabilized":"Yes","Impact Strength":"High","Stock Status":"In Stock","Available Sizes":"3 x 2.5 inch, 4 x 2.5 inch, 4 x 3 inch","MRP":"Rs. 885","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-tee-soc-cpvc-schedule-40-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Elbow 90° Soc Schedule-40', 'Manufactured from CPVC material for residential, commercial, and industrial use. The fittings resist acids, bases, salts, and oxidants. They feature UV stabilization for indoor and limited outdoor applications, high impact strength for pressure conditions, precise manufacturing tolerances, and lightweight solvent-cement joining technology.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 774, 'https://www.makankidukan.com/uploads/products/1749026687_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749026687_0.webp'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"90-Degree Elbow Fitting","Connection Type":"Socket (SOC)","Schedule":"40","Temperature Capacity":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Stock Status":"In Stock","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 774","Source":"https://www.makankidukan.com/building-product/astral-pipe-elbow-90-degree-soc-cpvc-schedule-40-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Long Radius Bend Socket', 'These fittings accommodate residential, commercial, and industrial piping applications. The material resists most acids, bases, salts, and oxidants while maintaining a low-friction interior surface that optimizes flow dynamics. UV stabilization permits both interior and limited external use. High impact strength under pressure conditions, precise manufacturing tolerances, contains UV stabilizers and impact modifiers.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1420, 'https://www.makankidukan.com/uploads/products/1749026997_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749026997_0.png'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Long Radius Bend with Socket","Schedule":"Schedule 40","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Stock Status":"In Stock","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 1420","Source":"https://www.makankidukan.com/building-product/astral-pipe-long-radius-bend-with-socket-cpvc-schedule-40-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral End Cap Schedule-40', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The product features corrosion resistance, high-temperature capability up to 93°C, smooth inner surfaces for improved flow, and lightweight construction enabling simple solvent-cement joining.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 350, 'https://www.makankidukan.com/uploads/products/1749027248_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749027248_0.webp'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"End Cap","Schedule":"40","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilization":"Yes, good for indoor and limited outdoor use","Stock Status":"In Stock","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 350","Source":"https://www.makankidukan.com/building-product/astral-pipe-end-cap-cpvc-schedule-40-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Reducer Coupler Schedule-40', 'The fitting features high-temperature resistance, corrosion resistance, smooth inner surface, fire resistance, and easy installation capabilities. Made from CPVC for residential, commercial and industrial applications.

Available sizes/variants: 3 x 2.5 inch, 4 x 2.5 inch, 4 x 3 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 708, 'https://www.makankidukan.com/uploads/products/1749027652_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749027652_0.webp'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Reducer Coupler Fitting","Schedule":"Schedule 40","Temperature Resistance":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilized":"Yes","Impact Strength":"High","Stock Status":"In Stock","Available Sizes":"3 x 2.5 inch, 4 x 2.5 inch, 4 x 3 inch","MRP":"Rs. 708","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-coupler-cpvc-schedule-40-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Coupler -soc CPVC Schedule - 80', 'This is a CPVC pipe coupling fitting from Astral Pipes, designed for residential, commercial, and industrial plumbing applications. The product features high-temperature resistance and corrosion resistance capabilities. The fitting offers easy installation through lightweight solvent-cement joining and maintains precise manufacturing tolerances for optimal fit.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch, 10 inch, 12 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 814, 'https://www.makankidukan.com/uploads/products/1749028040_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749028040_0.png'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Socket/Coupler Fitting","Schedule":"80","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"UV stabilized, smooth inner surface, high impact strength","Available Sizes":"2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch, 10 inch, 12 inch","MRP":"Rs. 814","Source":"https://www.makankidukan.com/building-product/astral-pipe-coupler-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Elbow 45 Degree - Soc CPVC Schedule - 80', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. Features high-temperature resistance, pressure endurance, corrosion resistance (immune to acids, bases, salts, oxidants), smooth inner surface reducing friction, fire resistance, UV stabilized for indoor/limited outdoor use, high impact strength, easy solvent-cement installation, long service life.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1142, 'https://www.makankidukan.com/uploads/products/1749029440_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749029440_0.webp'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"45-degree elbow with SOC (Socket) connections","Temperature Rating":"Handles water up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Stock Status":"In Stock","Available Sizes":"2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch","MRP":"Rs. 1142","Source":"https://www.makankidukan.com/building-product/astral-pipe-elbow-45-degree-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Tee - Soc CPVC Schedule - 80', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The fitting handles water continuously up to 93°C (200°F), resists corrosion from acids/bases/salts, features a smooth inner surface to reduce friction, and is UV stabilized for indoor and limited outdoor use.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1759, 'https://www.makankidukan.com/uploads/products/1749030179_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749030179_0.webp'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Type":"TEE - SOC (Slip-On-Coupling)","Schedule":"80","Standards":"ASTM D2846, ASTM F441, IS 15778","Temperature Rating":"Up to 93°C (200°F) continuous","Key Features":"High temperature/pressure/corrosion resistance, smooth inner surface, high impact strength, UV stabilized, easy solvent-cement joining","Stock Status":"In Stock","Available Sizes":"2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch","MRP":"Rs. 1759","Source":"https://www.makankidukan.com/building-product/astral-pipe-tee-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Cross - Soc CPVC Schedule - 80', 'Made using Chlorinated Polyvinyl Chloride (CPVC), this Socket-on-Copper (SOC) Cross fitting offers high-temperature resistance (up to 93°C/200°F continuously), corrosion immunity to acids, bases, salts and oxidants, a smooth inner surface that reduces friction, and high impact strength. It is UV stabilized with tight dimensional tolerances and is installed via solvent-cement joining, suitable for residential, commercial, and industrial plumbing applications.

Available sizes/variants: 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 3077, 'https://www.makankidukan.com/uploads/products/1749030761_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749030761_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Socket (SOC) Cross Fitting","Schedule":"80","Size":"4 inch","Temperature Resistance":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilized":"Yes","Available Sizes":"4 inch","MRP":"Rs. 3077","Source":"https://www.makankidukan.com/building-product/astral-pipe-cross-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Male Adaptor Brass Thd X Soc CPVC Schedule - 80', 'This CPVC Male Adaptor with a Brass Threaded (THD) end and Socket (SOC) end offers high-temperature resistance up to 93°C (200°F) continuously, resistance to corrosion from acids, bases, salts and oxidants, and a smooth inner surface that reduces friction and pressure drops. It is UV stabilized, high impact strength, and installed via solvent-cement joining, suitable for residential, commercial and industrial applications.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 4386, 'https://www.makankidukan.com/uploads/products/1749031139_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749031139_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Male Adaptor (Brass Threaded x Socket)","Schedule":"80","Temperature Resistance":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Installation":"Solvent-cement joining","UV Stabilized":"Yes","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 4386","Source":"https://www.makankidukan.com/building-product/astral-pipe-male-adaptor-brass-thd-x-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Female Adaptor Brass Thd X Soc CPVC Schedule - 80', 'Made from CPVC material for residential, commercial and industrial applications, this Female Adaptor (Brass Threaded x Socket) offers high-temperature capability up to 93°C (200°F) continuously, corrosion resistance, a smooth inner surface reducing friction, and lightweight design with solvent-cement joining installation.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 2488, 'https://www.makankidukan.com/uploads/products/1749031401_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749031401_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F) continuously","Type":"Female Adaptor, Brass Threaded x Socket","Schedule":"80","UV Stabilized":"Yes","Standards":"ASTM D2846, ASTM F441, IS 15778","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 2488","Source":"https://www.makankidukan.com/building-product/astral-pipe-female-adaptor-brass-thd-x-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Elbow 90 Degree - Soc CPVC Schedule - 80', 'This CPVC 90-degree Elbow (Socket) fitting handles water up to 93°C continuously, resists corrosion from acids and salts, features a smooth inner surface reducing friction, and offers high impact strength even under pressure. It is UV stabilized and lightweight, installed with simple solvent-cement joining.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1301, 'https://www.makankidukan.com/uploads/products/1749031662_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749031662_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"90-Degree Elbow","Connection":"SOC (Socket)","Schedule":"80","Temperature Rating":"93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilized":"Yes","Available Sizes":"2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch","MRP":"Rs. 1301","Source":"https://www.makankidukan.com/building-product/astral-pipe-elbow-90-degree-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Male Adaptor Thd X Soc CPVC Schedule - 80', 'Designed for residential, commercial, and industrial applications, this CPVC Male Adaptor (Threaded x Socket) offers corrosion resistance to acids, bases, salts and oxidants, a smooth inner surface that reduces friction and pressure drops, high impact strength, and UV stabilization. Installation involves lightweight solvent-cement joining, and it withstands temperatures up to 93°C (200°F) continuously.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 545, 'https://www.makankidukan.com/uploads/products/1749033366_0.avif', ARRAY['https://www.makankidukan.com/uploads/products/1749033366_0.avif'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Schedule":"80","Temperature Resistance":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilized":"Yes","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 545","Source":"https://www.makankidukan.com/building-product/astral-pipe-male-adaptor-thd-x-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Female Adaptor Thd X Soc CPVC Schedule - 80', 'These CPVC Female Adaptor (Threaded x Socket) fittings are designed for residential, commercial, and industrial plumbing applications, offering resistance to high temperatures (up to 93°C/200°F continuously) and corrosive environments (acids, bases, salts, oxidants), high impact strength, a smooth inner surface, precise tolerances, and easy solvent-cement installation. UV stabilized for indoor and limited outdoor use.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 529, 'https://www.makankidukan.com/uploads/products/1749037437_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749037437_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Resistance":"Up to 93°C (200°F) continuously","Corrosion Resistance":"Resistant to acids, bases, salts, oxidants","UV Stabilization":"Yes, suitable for indoor and limited outdoor use","Manufacturing Standards":"ASTM D2846, ASTM F441, IS 15778","Installation Type":"Solvent-cement joining","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 529","Source":"https://www.makankidukan.com/building-product/astral-pipe-female-adaptor-thd-x-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Reducer Coupler - Soc CPVC Schedule - 80', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, this Socket (SOC) Reducer Coupler is ideal for residential, commercial, and industrial applications, offering high-temperature resistance (up to 93°C/200°F continuously), corrosion resistance, a smooth inner surface, high impact strength, and UV stabilization, with easy solvent-cement installation and lightweight design.

Available sizes/variants: 2.5x1.25", 2.5x1.5", 2.5x2", 3x1.25", 3x1.5", 3x2", 3x2.5", 4x1.5", 4x2", 4x2.5", 4x3", 6x2", 6x2.5", 6x3", 6.5x4", 8x4", 8x6"

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 691, 'https://www.makankidukan.com/uploads/products/1749041695_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749041695_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Socket (SOC) Reducer Coupler","Schedule":"Schedule 80","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilized":"Yes","Available Sizes":"2.5x1.25\", 2.5x1.5\", 2.5x2\", 3x1.25\", 3x1.5\", 3x2\", 3x2.5\", 4x1.5\", 4x2\", 4x2.5\", 4x3\", 6x2\", 6x2.5\", 6x3\", 6.5x4\", 8x4\", 8x6\"","MRP":"Rs. 691","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-coupler-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral End Cap - Soc CPVC Schedule - 80', 'This CPVC Socket (SOC) End Cap offers high temperature resistance, corrosion immunity, a smooth inner surface, fire resistance, and durable construction. It is UV stabilized, high impact strength, and features easy, lightweight installation via solvent-cement joining, suitable for residential, commercial, and industrial applications.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch, 6 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 501, 'https://www.makankidukan.com/uploads/products/1749041937_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749041937_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Schedule":"80","Type":"Socket (SOC) End Cap","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilized":"Yes","Available Sizes":"2.5 inch, 3 inch, 4 inch, 6 inch","MRP":"Rs. 501","Source":"https://www.makankidukan.com/building-product/astral-pipe-end-cap-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Reducer Bushing Spg X Soc CPVC Schedule - 80', 'Versatile fitting composed of Chlorinated Polyvinyl Chloride (CPVC), designed for residential, commercial, and industrial piping systems. The material resists most acids, bases, salts, and oxidants. Features durable construction with impact modifiers and specialty chemical additives enhancing long-term performance. Offers high temperature resistance, corrosion immunity, a smooth inner surface reducing friction, high impact strength, UV stabilization, precise dimensional tolerances, and lightweight solvent-cement joining capability.

Available sizes/variants: 2.5x1.25", 2.5x1.5", 2.5x2", 3x1.25", 3x1.5", 3x2", 3x2.5", 4x1.5", 4x2", 4x2.5", 4x3", 6x3", 6x4", 8x4", 8x6"

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 583, 'https://www.makankidukan.com/uploads/products/1749042687_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749042687_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F) continuously","Schedule":"80","Connection Type":"SPG X SOC (Spigot x Socket)","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilized":"Yes","Available Sizes":"2.5x1.25\", 2.5x1.5\", 2.5x2\", 3x1.25\", 3x1.5\", 3x2\", 3x2.5\", 4x1.5\", 4x2\", 4x2.5\", 4x3\", 6x3\", 6x4\", 8x4\", 8x6\"","MRP":"Rs. 583","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-bushing-spg-x-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Reducer Tee - Soc CPVC Schedule - 80', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. Features include corrosion resistance, smooth inner surface for improved flow, high impact strength under pressure conditions, UV stabilization, and lightweight design with solvent-cement joining for straightforward setup. Key features include high temperature resistance, pressure endurance, corrosion resistance, smooth inner surface, fire resistance, long service life, and easy installation.

Available sizes/variants: 2.5x1", 2.5x1.25", 2.5x1.5", 2.5x2", 3x1", 3x1.25", 3x1.5", 3x2", 3x2.5", 4x1", 4x1.25", 4x1.5", 4x2", 4x2.5", 4x3", 6x2", 6x2.5", 6x3", 6x4", 8x4", 8x6"

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 675, 'https://www.makankidukan.com/uploads/products/1749103217_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749103217_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Socket (SOC) Connection","Schedule":"80","Temperature Resistance":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Available Sizes":"2.5x1\", 2.5x1.25\", 2.5x1.5\", 2.5x2\", 3x1\", 3x1.25\", 3x1.5\", 3x2\", 3x2.5\", 4x1\", 4x1.25\", 4x1.5\", 4x2\", 4x2.5\", 4x3\", 6x2\", 6x2.5\", 6x3\", 6x4\", 8x4\", 8x6\"","MRP":"Rs. 675","Source":"https://www.makankidukan.com/building-product/astral-pipe-reducer-tee-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Hex Nipple Thd X Thd CPVC Schedule - 80', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. Features include corrosion resistance to acids, bases, salts, and oxidants; easy solvent-cement installation; and tight manufacturing tolerances for precise fitting. Key highlights include high temperature resistance, pressure endurance, corrosion resistance, smooth inner surface, fire resistance, long service life, and easy installation.

Available sizes/variants: 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 34, 'https://www.makankidukan.com/uploads/products/1749103879_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749103879_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Hex Nipple, Threaded x Threaded","Schedule":"Schedule 80","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Impact Strength":"High-impact resistant","UV Protection":"UV stabilized for indoor/limited outdoor use","Inner Surface":"Smooth (reduces friction and pressure drops)","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 34","Source":"https://www.makankidukan.com/building-product/astral-pipe-hex-nipple-thd-x-thd-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Vanstone Flange Spg CPVC Schedule - 80', 'CPVC fittings engineered for residential, commercial, and industrial plumbing systems. Features robust corrosion resistance against acids, bases, and salts; precise manufacturing tolerances; and specialized additives for durability enhancement. Emphasizes high temperature resistance, corrosion immunity, fire resistance, smooth flow characteristics, and long service life with straightforward installation procedures.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1851, 'https://www.makankidukan.com/uploads/products/1749104141_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749104141_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Schedule":"80","Temperature Resistance":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilization":"Yes, suitable for indoor and limited outdoor use","Impact Strength":"High-impact rated","Surface":"Smooth inner surface for reduced friction","Joining Method":"Solvent-cement installation","Weight":"Lightweight","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 1851","Source":"https://www.makankidukan.com/building-product/astral-pipe-vanstone-flange-spg-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Flange Ring - Soc CPVC Schedule - 80', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, this flange ring suits various applications and handles water up to 93°C (200°F) continuously. It resists acids, bases, salts, and oxidants. Features include reduced friction via smooth inner surfaces, high impact strength, UV stabilization, and simple solvent-cement joining for installation.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1215, 'https://www.makankidukan.com/uploads/products/1749104429_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749104429_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"93°C (200°F) continuous","Corrosion Resistance":"Yes","Surface Type":"Smooth inner surface","Impact Strength":"High","UV Stabilized":"Yes","Fire Resistant":"Yes","Installation Method":"Solvent-cement joining","Standards":"ASTM D2846, ASTM F441, IS 15778","Fitting Type":"Socket on Copper (SOC)","Available Sizes":"2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch","MRP":"Rs. 1215","Source":"https://www.makankidukan.com/building-product/astral-pipe-flange-ring-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral True Union Ball Valve Soc Epdm CPVC Schedule - 80', 'The valve is manufactured from Chlorinated Polyvinyl Chloride (CPVC) and suits residential, commercial, and industrial applications. It maintains temperatures up to 93°C continuously and resists corrosion from acids, bases, salts, and oxidants. The design features a smooth inner surface reducing friction and pressure drops, with high impact strength for demanding conditions. The product is UV-stabilized and follows ASTM D2846, ASTM F441, and IS 15778 standards.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 13954, 'https://www.makankidukan.com/uploads/products/1749104965_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749104965_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Type":"True Union Ball Valve","Connection":"SOC (Socket)","Seal Material":"EPDM","Schedule":"Schedule 80","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Features":"UV stabilized, high impact strength, corrosion resistant","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 13954","Source":"https://www.makankidukan.com/building-product/astral-pipe-true-union-ball-valve-soc-epdm-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Vanstone Flange - Soc CPVC Schedule - 80', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The fitting features corrosion resistance, smooth inner surfaces to reduce friction, lightweight construction, and solvent-cement joining for easy installation. Key features include high temperature resistance, pressure endurance, corrosion resistance, smooth inner surface, fire resistance, long service life, and easy installation.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1694, 'https://www.makankidukan.com/uploads/products/1749105344_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749105344_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Schedule Type":"Schedule 80","Fitting Type":"Socket Outlet Connection (SOC) Flange","Temperature Resistance":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","UV Stabilization":"Yes","Impact Strength":"High","Available Sizes":"2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch","MRP":"Rs. 1694","Source":"https://www.makankidukan.com/building-product/astral-pipe-vanstone-flange-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Flange - Soc One Piece CPVC Schedule - 80', 'These CPVC fittings suit residential, commercial, and industrial use. The material withstands continuous water temperatures up to 93°C. They resist acids, bases, salts, and oxidants while featuring smooth inner surfaces that minimize friction and pressure loss. The fittings have high impact strength, UV stabilization, and tight manufacturing tolerances. Installation involves lightweight solvent-cement joining methods. Manufacturing follows ASTM D2846, ASTM F441, and IS 15778 standards.

Available sizes/variants: 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1925, 'https://www.makankidukan.com/uploads/products/1749105525_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749105525_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F)","Construction":"One-piece SOC design","Schedule":"80","Features":"Corrosion-resistant, high impact strength, UV-stabilized, fire-resistant","Standards":"ASTM D2846, ASTM F441, IS 15778","Available Sizes":"3 inch, 4 inch","MRP":"Rs. 1925","Source":"https://www.makankidukan.com/building-product/astral-pipe-flange-soc-one-piece-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Flange Hub - Soc CPVC Schedule - 80', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications, with immunity to acids, bases, salts, and oxidants. The product includes UV stabilization and solvent-cement joining capability.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 478, 'https://www.makankidukan.com/uploads/products/1749105829_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749105829_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Handles water up to 93°C continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Schedule Type":"Schedule 80","Highlights":"High temperature resistance, pressure endurance, corrosion resistance, smooth inner surface, fire resistance, long service life, easy installation","Available Sizes":"2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch","MRP":"Rs. 478","Source":"https://www.makankidukan.com/building-product/astral-pipe-flange-hub-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Blind Flange CPVC Schedule - 80', 'Made from Chlorinated Polyvinyl Chloride material, this fitting handles temperatures up to 93°C continuously and resists corrosion from acids, bases, and salts. The smooth interior reduces friction and pressure loss. It features UV stabilization, high impact strength, and precise manufacturing tolerances for proper fitting alignment.

Available sizes/variants: 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1937, 'https://www.makankidukan.com/uploads/products/1749106041_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749106041_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Rating":"Up to 93°C (200°F) continuous","Corrosion Resistance":"Immune to acids, bases, salts, oxidants","Standards":"ASTM D2846, ASTM F441, IS 15778","Installation":"Solvent-cement joining","UV Stabilization":"Yes","Impact Strength":"High-pressure rated","Available Sizes":"3 inch, 4 inch","MRP":"Rs. 1937","Source":"https://www.makankidukan.com/building-product/astral-pipe-blind-flange-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Flange Hub - Spg CPVC Schedule - 80', 'Chlorinated Polyvinyl Chloride (CPVC) flange hub with solvent cement joining (SPG), suitable for residential, commercial, and industrial piping systems. Features high-temperature resistance, pressure endurance, corrosion resistance, smooth inner surface, fire resistance, extended service life, and straightforward installation. UV stabilized with impact modifiers, demonstrating immunity to most acids, bases, and salts. Lightweight design enables simple assembly.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 636, 'https://www.makankidukan.com/uploads/products/1749106331_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749106331_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Flange Hub with Solvent Cement Joining (SPG)","Standards":"ASTM D2846, ASTM F441, IS 15778","Temperature Rating":"Handles water up to 93°C (200°F) continuously","Construction":"UV stabilized with impact modifiers","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 636","Source":"https://www.makankidukan.com/building-product/astral-pipe-flange-hub-spg-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Union - Soc CPVC Schedule - 80', 'Made from Chlorinated Polyvinyl Chloride, these fittings serve residential, commercial, and industrial applications. The material withstands water up to 93°C (200°F) continuously and resists most acids, bases, salts, and oxidants. Features include a smooth inner surface reducing friction, high impact strength under pressure, UV stabilization for indoor/outdoor use, and solvent-cement joining installation.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1411, 'https://www.makankidukan.com/uploads/products/1749106614_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749106614_0.webp'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Fire Resistance":"Yes","Corrosion Resistant":"Yes","Temperature Rating":"93°C continuous","Impact Strength":"High","UV Stabilized":"Yes","Manufacturing Standards":"ASTM D2846, ASTM F441, IS 15778","Installation Method":"Solvent-cement joining","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 1411","Source":"https://www.makankidukan.com/building-product/astral-pipe-union-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral NRV - Soc CPVC Schedule - 80', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. Key capabilities include handling temperatures up to 93°C continuously and withstanding high-pressure conditions. The product features corrosion resistance, UV stabilization, and smooth internal surfaces that reduce friction and pressure loss. Assembly uses solvent-cement joining for straightforward installation.

Available sizes/variants: 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 403, 'https://www.makankidukan.com/uploads/products/1749106898_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749106898_0.webp','https://www.makankidukan.com/uploads/products/1749106898_1.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F) continuously","Corrosion Resistance":"Immune to acids, bases, salts, oxidants","Impact Strength":"High impact strength under pressure","UV Stability":"Suitable for indoor and limited outdoor use","Standards":"ASTM D2846, ASTM F441, IS 15778","Connection Method":"Solvent-cement joining","Weight":"Lightweight","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 403","Source":"https://www.makankidukan.com/building-product/astral-pipe-nrv-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Long Radius Bend - Soc CPVC Schedule - 80', 'CPVC Long Radius Bend fitting designed for residential, commercial, and industrial applications. Features include high-temperature capability up to 93°C, corrosion resistance, and smooth inner surfaces that reduce friction and pressure drops.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1832, 'https://www.makankidukan.com/uploads/products/1749107133_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749107133_0.jpg','https://www.makankidukan.com/uploads/products/1749107133_1.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F) continuously","Corrosion Resistance":"Immune to acids, bases, salts, oxidants","Impact Strength":"High-impact resistant under pressure","UV Stabilization":"Suitable for indoor and limited outdoor use","Standards":"ASTM D2846, ASTM F441, IS 15778","Installation Method":"Solvent-cement joining","Weight Characteristic":"Lightweight","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 1832","Source":"https://www.makankidukan.com/building-product/astral-pipe-long-radius-bend-soc-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Flange Rubber Gasket CPVC Schedule - 80', 'These CPVC fittings feature high-temperature resistance and corrosion resistance for acids, bases, and salts. They offer reduced friction flow characteristics with precise manufacturing tolerances and lightweight, solvent-cement joining installation.

Available sizes/variants: 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch, 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 400, 'https://www.makankidukan.com/uploads/products/1749107658_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749107658_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Application Type":"Residential, commercial, industrial","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"Corrosion resistant, smooth inner surface, high impact strength, UV stabilized","Available Sizes":"0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch, 2.5 inch, 3 inch, 4 inch","MRP":"Rs. 400","Source":"https://www.makankidukan.com/building-product/astral-pipe-flange-rubber-gasket-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral True Union Ind Ball Valve Soc Epdm CPVC', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The product features high-temperature resistance up to 93°C, corrosion resistance to acids and bases, smooth inner surfaces reducing friction, high impact strength, UV stabilization, and easy solvent-cement installation. Manufactured per ASTM D2846, ASTM F441, and IS 15778 standards.

Available sizes/variants: 6 inch, 8 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 302293, 'https://www.makankidukan.com/uploads/products/1749112473_0.avif', ARRAY['https://www.makankidukan.com/uploads/products/1749112473_0.avif','https://www.makankidukan.com/uploads/products/1749112473_1.png'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Valve Type":"True Union Industrial Ball Valve","Fitting Type":"SOC (Solvent Cement)","Seat Material":"EPDM","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Stock Status":"In Stock","Available Sizes":"6 inch, 8 inch","MRP":"Rs. 302293","Source":"https://www.makankidukan.com/building-product/astral-pipe-true-union-ind-ball-valve-soc-epdm-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral True Union Ind Ball Check Soc Epdm CPVC', 'Manufactured using Chlorinated Polyvinyl Chloride (CPVC) material for residential, commercial, and industrial applications. It features high-temperature resistance capable of handling water up to 93°C continuously, and offers corrosion resistance to most acids, bases, salts, and oxidants. The fitting includes a smooth inner surface reducing friction, high impact strength, UV stabilization for indoor/outdoor use, precise manufacturing with tight tolerances, and uses easy installation via solvent-cement joining.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 49105, 'https://www.makankidukan.com/uploads/products/1749112810_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749112810_0.png'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Rating":"Up to 93°C (200°F)","Standards":"ASTM D2846, ASTM F441, IS 15778","Features":"UV stabilized, high impact strength, smooth inner surface, corrosion resistant, fire resistant","Available Sizes":"2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch","MRP":"Rs. 49105","Source":"https://www.makankidukan.com/building-product/astral-pipe-true-union-ind-ball-check-soc-epdm-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Water Butterfly Valve Viton With Handle CPVC', 'Manufactured from CPVC material suitable for residential, commercial, and industrial use. It offers High-Temperature Resistance capable of handling water up to 93°C continuously, along with corrosion resistance and smooth inner surfaces that reduce friction. Features include high impact strength, UV stabilization, and easy solvent-cement installation. Manufacturing follows ASTM D2846, ASTM F441, and IS 15778 standards.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 138776, 'https://www.makankidukan.com/uploads/products/1749113204_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749113204_0.jpg'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Stock Status":"In Stock","Seat Material":"Viton","Key Features":"High Temperature Resistance, Pressure Endurance, Corrosion Resistance, Smooth Inner Surface, Fire Resistance, Long Service Life, Easy Installation","Standards":"ASTM D2846, ASTM F441, IS 15778","Available Sizes":"2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch","MRP":"Rs. 138776","Source":"https://www.makankidukan.com/building-product/astral-pipe-water-butterfly-valve-viton-with-handle-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Water Butterfly Valve Epdm With Handle CPVC', 'The valve is constructed from Chlorinated Polyvinyl Chloride material suited for residential, commercial, and industrial applications. Key capabilities include handling water temperatures up to 93°C continuously, resistance to corrosive substances, and a smooth interior surface that reduces friction, ensuring better flow and lesser pressure drops. The product features tight manufacturing tolerances and easy solvent-cement joining for installation.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 47267, 'https://www.makankidukan.com/uploads/products/1749113442_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749113442_0.webp'], '{"Brand":"Astral Pipes","Category":"CPVC Pipes & Fittings","Seat Material":"EPDM","Key Specifications":"High Temperature Resistance, Pressure Endurance, Corrosion Resistance, Smooth Inner Surface, Fire Resistance, Long Service Life, Easy Installation, UV Stabilized, High Impact Strength","Standards":"ASTM D2846, ASTM F441, IS 15778","Available Sizes":"2.5 inch, 3 inch, 4 inch, 6 inch, 8 inch","MRP":"Rs. 47267","Source":"https://www.makankidukan.com/building-product/astral-pipe-water-butterfly-valve-epdm-with-handle-cpvc-pipes-fitting"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Ptfe Tape 12 mm Width CPVC Pipes Fitting Ancillary Products', 'PTFE thread sealant tape providing strong, durable joints that become virtually leak-proof, with quick installation times. Specially formulated for high/low temperature resilience and designed to withstand high-pressure systems. Composition includes PTFE-based compounds engineered to enhance piping system performance. Features high bond strength, fast curing, temperature resistance, easy application, and is safe & non-toxic.

Available sizes/variants: 4 MTR, 8 MTR

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 20, 'https://www.makankidukan.com/uploads/products/1749118158_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749118158_0.jpg'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Product Type":"PTFE Tape (Thread Sealant)","Width":"12 MM","Compatibility":"CPVC Pipes & Fittings","Stock Status":"In Stock","Return Policy":"7 days","Available Sizes":"4 MTR, 8 MTR","MRP":"Rs. 20","Source":"https://www.makankidukan.com/building-product/astral-pipe-ptfe-tape-12-mm-width-cpvc-pipes-fitting-ancillary-products"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Rescue Tape CPVC Pipes Fitting Ancillary Products', 'This solvent cement/tape product provides strong, durable joints that become virtually leak-proof, with quick drying times. It resists high and low temperatures and operates reliably in high-pressure systems. The formulation includes petroleum-based lubricants approved for potable water applications and is designed to enhance the overall performance, longevity, and ease of installation of piping systems.

Available sizes/variants: 5 ft, 10 ft, 15 ft

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 150, 'https://www.makankidukan.com/uploads/products/1749118729_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749118729_0.png'], '{"Brand":"Astral","Category":"CPVC Pipes & Fittings","Key Property":"High Bond Strength","Curing":"Fast Curing","Temperature Resistance":"Yes","Application":"Easy Application","Safety":"Safe & Non-toxic","Composition":"CPVC or PVC resins, solvents (MEK, THF), stabilizers; includes primers, lubricants, PTFE-based thread sealants","Stock Status":"In Stock","Return Policy":"7 days","Available Sizes":"5 ft, 10 ft, 15 ft","MRP":"Rs. 150","Source":"https://www.makankidukan.com/building-product/astral-pipe-rescue-tape-cpvc-pipes-fitting-ancillary-products"}'::jsonb, v_sub0, 100, true),
  ('Astral Pipe Plastic Strap Pp CPVC Pipes Fitting', 'These fittings offer high-temperature resistance and corrosion resistance suited for residential, commercial, and industrial applications. The design includes tight dimensional tolerances and enables lightweight and simple solvent-cement joining.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 6, 'https://www.makankidukan.com/uploads/products/1749017392_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749017392_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Resistance":"Handles water up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Features":"UV stabilized, corrosion resistant, high impact strength, smooth inner surface","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 6","Source":"https://www.makankidukan.com/building-product/astral-pipe-plastic-strap-pp-cpvc-pipes-fitting"}'::jsonb, v_sub1, 100, true),
  ('Astral Pipe Plastic Strap Nylon CPVC Pipes Fitting', 'This fitting is manufactured from Chlorinated Polyvinyl Chloride and is suitable for residential, commercial, and industrial plumbing applications. It can handle water up to 93°C (200°F) continuously and offers corrosion resistance to acids, bases, salts, and oxidants.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 11, 'https://www.makankidukan.com/uploads/products/1749017840_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749017840_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Rating":"Up to 93°C (200°F)","Available Thicknesses":"0.5\", 0.75\", 1\", 1.25\", 1.5\", 2\"","Manufacturing Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"High impact strength, UV stabilized, smooth inner surface, easy solvent-cement joining","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 11","Source":"https://www.makankidukan.com/building-product/astral-pipe-plastic-strap-nylon-cpvc-pipes-fitting"}'::jsonb, v_sub1, 100, true),
  ('Astral Pipe Metal Strap CPVC Pipes Fitting', 'These fittings suit residential, commercial, and industrial applications with precise manufacturing for tight dimensional tolerances ensuring optimal performance. Key features include high temperature resistance, pressure endurance, corrosion resistance, fire resistance, and easy installation.

Available sizes/variants: Thickness options: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 16, 'https://www.makankidukan.com/uploads/products/1749022421_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749022421_0.jpg','https://www.makankidukan.com/uploads/products/1749022421_1.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Resistance":"Up to 93°C (200°F) continuous","Corrosion Resistance":"Resistant to acids, bases, salts, oxidants","Inner Surface":"Smooth (reduces friction)","Impact Strength":"High, suitable for pressure conditions","UV Protection":"Stabilized for indoor/limited outdoor use","Installation":"Solvent-cement joining, lightweight","Standards":"ASTM D2846, ASTM F441, IS 15778","Additives":"UV stabilizers, impact modifiers","Available Sizes":"Thickness options: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 16","Source":"https://www.makankidukan.com/building-product/astral-pipe-metal-strap-cpvc-pipes-fitting"}'::jsonb, v_sub1, 100, true),
  ('Astral Pipe Metal Strap S.S. CPVC Pipes Fitting', 'The fitting features high-temperature resistance and pressure endurance capabilities alongside corrosion protection and straightforward installation requirements suitable for residential, commercial, and industrial use.

Available sizes/variants: Thickness options: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 20, 'https://www.makankidukan.com/uploads/products/1749022731_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749022731_0.webp','https://www.makankidukan.com/uploads/products/1749022731_1.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Corrosion Resistance":"Resistant to acids, bases, salts, oxidants","Surface Type":"Smooth inner surface for reduced friction","Impact Strength":"High-impact durable construction","UV Protection":"UV stabilized for indoor/limited outdoor use","Installation":"Solvent-cement joining method","Available Sizes":"Thickness options: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 20","Source":"https://www.makankidukan.com/building-product/astral-pipe-metal-strap-ss-cpvc-pipes-fitting"}'::jsonb, v_sub1, 100, true),
  ('Astral Drain Pro 3 M s/s Pipes', 'These drainage pipes are engineered for non-pressure underground drainage and sewerage applications. uPVC construction known for chemical resistance, durability, and low weight. Lightweight construction enabling faster installation; high ring stiffness for structural integrity against soil loads; smooth inner surface minimizing blockage and maximizing flow rates; leak-proof rubber ring socketed joints; chemical and abrasion resistant properties; corrosion-free with extended service life. Available in diameters from 110-315 mm with varying stiffness classes. Applications: sewerage systems, rainwater harvesting, stormwater drainage, residential/industrial waste drainage, and infrastructure projects. 7-day return policy available.

Available sizes/variants: 40 mm, 50 mm, 75 mm, 90 mm, 110 mm, 160 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 441, 'https://www.makankidukan.com/uploads/products/1749120360_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749120360_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Available Thickness/Sizes":"40 mm, 50 mm, 75 mm, 90 mm, 110 mm, 160 mm","Stock Status":"In Stock","Available Sizes":"40 mm, 50 mm, 75 mm, 90 mm, 110 mm, 160 mm","MRP":"Rs. 441","Source":"https://www.makankidukan.com/building-product/astral-drain-pro-3-m-ss-pipes"}'::jsonb, v_sub1, 100, true),
  ('Astral Drain Pro 3 M D/s Pipes', 'These drainage pipes serve non-pressure underground drainage and sewerage applications. Lightweight design enabling faster installation; smooth inner surface reducing blockage risk; chemical and abrasion resistant formulation; leak-proof rubber ring socketed joints; high ring stiffness for structural integrity; non-corrosive, rust-resistant construction; long-term durability with minimal maintenance. The material resists chemicals, biological attack, and scaling. Common diameter options span 110-315 mm with varying stiffness classes (SN2, SN4, SN8). Applications: sewerage systems, stormwater and rainwater drainage, residential and industrial waste management, infrastructure projects. 7-day returns & exchange available.

Available sizes/variants: 40 mm, 50 mm, 75 mm, 90 mm, 110 mm, 160 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 494, 'https://www.makankidukan.com/uploads/products/1749120337_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749120337_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Available Thickness":"40 mm, 50 mm, 75 mm, 90 mm, 110 mm, 160 mm","Stock Status":"In Stock","Available Sizes":"40 mm, 50 mm, 75 mm, 90 mm, 110 mm, 160 mm","MRP":"Rs. 494","Source":"https://www.makankidukan.com/building-product/astral-drain-pro-3-m-ds-pipes"}'::jsonb, v_sub1, 100, true),
  ('Astral Drain Pro 1 Rft s/s Pipes', 'These drainage pipes are designed for non-pressure underground drainage and sewerage applications. The material offers corrosion resistance, durability, and easy installation due to lightweight construction. Features include high ring stiffness, watertight rubber ring joints, and UV stabilization for above-ground variants. Lightweight; smooth inner surface; chemical and abrasion resistant. Applications: sewerage systems, rainwater harvesting, stormwater drainage, residential/industrial waste drainage, and infrastructure projects.

Available sizes/variants: 50mm, 75mm, 90mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 69, 'https://www.makankidukan.com/uploads/products/1749121061_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749121061_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Available Thicknesses":"50mm, 75mm, 90mm, 110mm, 160mm","Stock Status":"In Stock","Return Policy":"7 days","Available Sizes":"50mm, 75mm, 90mm, 110mm, 160mm","MRP":"Rs. 69","Source":"https://www.makankidukan.com/building-product/astral-drain-pro-1-rft-ss-pipes"}'::jsonb, v_sub1, 100, true),
  ('Astral Drain Pro 2 Rft D/s Pipes', 'These drainage pipes are engineered for non-pressure underground drainage and sewerage applications. The material resists scaling and biological attack while maintaining durability. Lightweight construction enabling faster installation; smooth inner surface reducing blockage risk; chemical and abrasion resistant for harsh environments; leak-proof rubber ring socketed joints; non-corrosive and rust-resistant; high ring stiffness for soil load protection. Common diameters span 110-315mm with various stiffness classes (SN2, SN4, SN8). Applications: sewerage systems, rainwater harvesting, stormwater drainage, residential/industrial waste drainage, and infrastructure projects. 7-day returns and exchange policy available.

Available sizes/variants: 40mm, 50mm, 75mm, 90mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 170, 'https://www.makankidukan.com/uploads/products/1749121489_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749121489_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Available Thicknesses":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","Stock Status":"In Stock","Available Sizes":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","MRP":"Rs. 170","Source":"https://www.makankidukan.com/building-product/astral-drain-pro-2-rft-ds-pipes"}'::jsonb, v_sub1, 100, true),
  ('Astral Drain Pro 3 Rft D/s Pipes', 'Specialized drainage pipes engineered for non-pressure underground drainage and sewerage applications. The uPVC composition provides durability, chemical resistance, and low weight. Lightweight construction enabling faster installation; smooth inner surface minimizing blockage risk; chemical and abrasion resistant properties; leak-proof joints with rubber ring socketed connections; non-corrosive, rust-resistant material; high ring stiffness for structural integrity. Available in standard diameters (110-315 mm) across different stiffness classes (SN2, SN4, SN8). Applications: sewerage systems, rainwater harvesting and stormwater drainage, residential and industrial waste drainage, infrastructure projects. 7-day returns and exchange available.

Available sizes/variants: 40 mm, 50 mm, 75 mm, 90 mm, 110 mm, 160 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 217, 'https://www.makankidukan.com/uploads/products/1749122122_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749122122_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Available Thicknesses":"40 mm, 50 mm, 75 mm, 90 mm, 110 mm, 160 mm","Stock Status":"In Stock","Available Sizes":"40 mm, 50 mm, 75 mm, 90 mm, 110 mm, 160 mm","MRP":"Rs. 217","Source":"https://www.makankidukan.com/building-product/astral-drain-pro-3-rft-ds-pipes"}'::jsonb, v_sub1, 100, true),
  ('Astral Drain Pro 4 Rft D/s Pipes', 'Astral Drain Pro Pipes are specialized drainage pipes designed for non-pressure underground drainage and sewerage applications. Key features include chemical resistance, durability, lightweight construction, high ring stiffness, smooth inner surface for optimal flow, leak-proof rubber ring socketed joints, and corrosion-free composition. These pipes resist harsh chemicals and provide long-term durability with minimal maintenance. Lightweight with fast installation capability; high flow rates due to smooth interior; available in common diameters (110mm to 315mm); stiffness classes: SN2, SN4, SN8. Applications: sewerage systems, rainwater harvesting, stormwater drainage, residential/industrial waste drainage, and infrastructure projects. 7-day returns and exchange policy available.

Available sizes/variants: 40mm, 50mm, 75mm, 90mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 275, 'https://www.makankidukan.com/uploads/products/1749124122_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749124122_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Available Thicknesses":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","Stock Status":"In Stock","Available Sizes":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","MRP":"Rs. 275","Source":"https://www.makankidukan.com/building-product/astral-drain-pro-4-rft-ds-pipes"}'::jsonb, v_sub1, 100, true),
  ('Astral Drain Pro 6 Rft s/s Pipes', 'uPVC (Unplasticized Polyvinyl Chloride) drainage pipes engineered for non-pressure underground drainage and sewerage applications. Features leak-proof rubber ring socketed joints for secure, watertight connections. Non-corrosive and rust-resistant with high ring stiffness for structural integrity and long service life. Suitable for sewerage systems, rainwater harvesting, stormwater drainage, residential/industrial waste drainage, and infrastructure projects. 7-day return and exchange policy available.

Available sizes/variants: 40mm, 50mm, 75mm, 90mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 344, 'https://www.makankidukan.com/uploads/products/1749126970_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749126970_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Type":"Drainage Pipe - 6 feet length, single socket (S/S)","Available Thicknesses":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","Joint Type":"Rubber ring socketed joints","Key Properties":"Lightweight, smooth inner surface, chemical & abrasion resistant, non-corrosive","Price with GST":"Rs. 215.14","Available Sizes":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","MRP":"Rs. 344","Source":"https://www.makankidukan.com/building-product/astral-drain-pro-6-rft-ss-pipes"}'::jsonb, v_sub1, 100, true),
  ('Astral Drain Pro 6 Rft D/s Pipes', 'Specialized uPVC drainage pipes engineered for non-pressure underground drainage and sewerage applications. Features chemical resistance, durability, lightweight construction, smooth inner surface for high flow rates, and leak-proof rubber ring socketed joints (double socket). The material is non-corrosive, resistant to rust and biological attack, with high ring stiffness for structural integrity against soil loads. Suitable for sewerage systems, rainwater harvesting, stormwater drainage, residential/industrial waste drainage, and infrastructure projects. 7-day returns.

Available sizes/variants: 40mm, 50mm, 75mm, 90mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 371, 'https://www.makankidukan.com/uploads/products/1749127305_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749127305_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness Options":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","Joint Type":"Rubber ring socketed joints (double socket)","Properties":"Chemical & abrasion resistant, lightweight, corrosion-free","Price with GST":"Rs. 232.02","Available Sizes":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","MRP":"Rs. 371","Source":"https://www.makankidukan.com/building-product/astral-drain-pro-6-rft-ds-pipes"}'::jsonb, v_sub1, 100, true),
  ('Astral Drain Pro 12 Rft s/s Pipes', 'uPVC drainage pipe (non-pressure), 12 RFT length, single socket. Offers chemical resistance, durability, and low weight. Smooth inner surface for optimal flow, leak-proof rubber ring socketed joints, and structural integrity against soil loads. Suitable for sewerage systems, rainwater harvesting/stormwater drainage, residential/industrial waste drainage, and infrastructure projects. 7-day returns and exchange policy.

Available sizes/variants: 110mm (range 110mm-315mm across line, SN2/SN4/SN8 stiffness classes)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 2464, 'https://www.makankidukan.com/uploads/products/1749127557_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749127557_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Diameter/Thickness":"110 mm","Length":"12 RFT","Type":"Drainage pipe (non-pressure), single socket","Price with GST":"Rs. 1,540.99","Available Sizes":"110mm (range 110mm-315mm across line, SN2/SN4/SN8 stiffness classes)","MRP":"Rs. 2464","Source":"https://www.makankidukan.com/building-product/astral-drain-pro-12-rft-ss-pipes"}'::jsonb, v_sub1, 100, true),
  ('Astral Drain Pro 2 Rft s/s Pipes', 'uPVC drainage pipe, 2 RFT length, single socket, with rubber ring socketed joints. Lightweight with smooth inner surface, chemical & abrasion resistant, non-corrosive and resistant to rust and scaling. High ring stiffness for soil load support and leak-proof joints. Corrosion-free design with minimal maintenance; suitable for above-ground UV stabilized versions. Applications include sewerage systems, rainwater harvesting, stormwater drainage, residential/industrial waste drainage, and infrastructure projects. 7-day returns.

Available sizes/variants: 110mm (range 110mm-315mm across line)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 547, 'https://www.makankidukan.com/uploads/products/1749127942_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749127942_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Diameter/Size":"110 mm","Joint Type":"Rubber ring socketed joints","Available Sizes":"110mm (range 110mm-315mm across line)","Price with GST":"Rs. 342.09","MRP":"Rs. 547","Source":"https://www.makankidukan.com/building-product/astral-drain-pro-2-rft-ss-pipes"}'::jsonb, v_sub1, 100, true),
  ('Astral Drain Pro 5 Rft D/s Pipes', 'Astral Drain Pro Pipes are specialized drainage solutions engineered for non-pressure underground drainage and sewerage applications, 5 RFT length, double socket. The uPVC construction offers chemical resistance, durability, and low weight with corrosion-free performance. Key features include lightweight design for ease of installation, high ring stiffness for structural integrity, smooth inner surface minimizing blockage, and leak-proof rubber ring joints. Applications: sewerage systems, rainwater harvesting, stormwater drainage, residential/industrial waste drainage, and infrastructure projects. 7-day returns & exchange policy.

Available sizes/variants: 110mm (range 110mm-315mm, SN2/SN4/SN8)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1097, 'https://www.makankidukan.com/uploads/products/1749128066_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749128066_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Diameter/Size":"110 mm","Type":"Non-pressure underground drainage pipe, double socket","Joint Type":"Rubber ring socketed joints","Available Size Range":"110mm to 315mm","Stiffness Classes":"SN2, SN4, SN8","Price with GST":"Rs. 686.06","Available Sizes":"110mm (range 110mm-315mm, SN2/SN4/SN8)","MRP":"Rs. 1097","Source":"https://www.makankidukan.com/building-product/astral-drain-pro-5-rft-ds-pipes"}'::jsonb, v_sub1, 100, true),
  ('Astral Bend 45 Degree Drain Pro Fittings', 'Premium uPVC drainage system components designed for non-pressure wastewater applications. The 45-degree bend fitting offers precision-designed sockets and seals ensuring reliable connections across residential, commercial, and industrial projects. Leak-proof joints, high chemical resistance, smooth inner surface, corrosion & rust-free construction, quick and easy installation with solvent cement. UV stabilized variants available for outdoor applications; recyclable, eco-friendly material. 7-day returns and exchange available.

Available sizes/variants: 40mm, 50mm, 75mm, 90mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 46, 'https://www.makankidukan.com/uploads/products/1749198004_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749198004_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Product Type":"45-degree bend drainage fitting","Standards Compliance":"IS 13592 and IS 14735","Chemical Resistance":"Withstands acids, alkalis, corrosive agents","Inner Surface":"Smooth (prevents blockages/scaling)","Installation":"Lightweight, solvent cement joinable","UV Stabilization":"Available for outdoor applications","Price with GST":"Rs. 28.77","Available Sizes":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","MRP":"Rs. 46","Source":"https://www.makankidukan.com/building-product/astral-bend-45-degree-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Bend 87.5 Degree Drain Pro Fittings', 'Premium uPVC drainage system components for non-pressure wastewater applications in residential, commercial, and industrial projects. Features leak-proof performance and long service life with precision-designed sockets and seals for tight connections. High chemical resistance, smooth inner surface, corrosion & rust-free, quick & easy installation, UV stabilized variants available, eco-friendly and recyclable.

Available sizes/variants: 40mm, 50mm, 75mm, 90mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 50, 'https://www.makankidukan.com/uploads/products/1749198502_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749198502_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness Options":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","Standards":"ISI Marked (IS 13592, IS 14735)","Type":"87.5 Degree Bend Fitting","Application":"Drainage (non-pressure wastewater)","Price with GST":"Rs. 31.27","Available Sizes":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","MRP":"Rs. 50","Source":"https://www.makankidukan.com/building-product/astral-bend-875-degree-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Bend 87.5 Degree With Door Drain Pro Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. This 87.5-degree bend with door/access door allows for maintenance/cleaning access. Key features include leak-proof joints, chemical resistance, smooth inner surfaces, corrosion-free construction, high strength, non-reactive, recyclable material, and easy installation with solvent cement.

Available sizes/variants: 75mm, 90mm, 110mm, 315mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 177, 'https://www.makankidukan.com/uploads/products/1749198831_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749198831_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Type":"Bend - 87.5 Degree with Door/Access Door","Standards":"ISI Marked (IS 13592, IS 14735)","Pressure Rating":"Non-pressure drainage applications","Finish":"UV stabilized variants available","Properties":"High strength, non-reactive, recyclable","Price with GST":"Rs. 110.70","Available Sizes":"75mm, 90mm, 110mm, 315mm","MRP":"Rs. 177","Source":"https://www.makankidukan.com/building-product/astral-bend-875-degree-with-door-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Reducer Tee Swept Drain Pro Fittings', 'Premium uPVC drainage system components designed for non-pressure wastewater applications in residential, commercial, and industrial settings. Features leak-proof joints, high chemical resistance, and a smooth inner surface that prevents blockages. Resistant to acids, alkalis, and corrosive agents; quick, easy installation with solvent cement; non-reactive to most chemicals; eco-friendly material.

Available sizes/variants: 110x50mm, 110x75mm, 160x75mm, 160x110mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 363, 'https://www.makankidukan.com/uploads/products/1749199252_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749199252_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standards":"ISI Marked (IS 13592, IS 14735)","Key Features":"Corrosion/rust-free, UV stabilized variants, recyclable, lightweight, leak-proof joints","Stock Status":"In Stock","Available Sizes":"110x50mm, 110x75mm, 160x75mm, 160x110mm","MRP":"Rs. 363","Source":"https://www.makankidukan.com/building-product/astral-reducer-tee-swept-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Coupler Drain Pro Fittings', 'Premium uPVC drainage system components engineered for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. Features precision-designed sockets and seals for reliability; lightweight, easy to cut and join with solvent cement.

Available sizes/variants: 40mm, 50mm, 75mm, 90mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 46, 'https://www.makankidukan.com/uploads/products/1749199943_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749199943_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standard Compliance":"IS 13592 and IS 14735 (ISI Marked)","Key Features":"Leak-proof joints, chemical resistant, smooth inner surface, corrosion/rust-free, UV stabilized variants available","Stock Status":"In Stock","Available Sizes":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","MRP":"Rs. 46","Source":"https://www.makankidukan.com/building-product/astral-coupler-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Tee Swept Drain Pro Fittings', 'Premium uPVC drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial contexts. Features precision engineering for leak-proof performance and extended service life with solvent cement installation.

Available sizes/variants: 40mm, 50mm, 75mm, 90mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 66, 'https://www.makankidukan.com/uploads/products/1749201130_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749201130_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standards":"ISI Marked (IS 13592, IS 14735)","Key Features":"Leak-proof joints, high chemical resistance, corrosion-free, smooth inner surface, quick installation","UV Treatment":"Available for outdoor use","Recyclability":"Eco-friendly and recyclable","Available Sizes":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","MRP":"Rs. 66","Source":"https://www.makankidukan.com/building-product/astral-tee-swept-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Tee With Door Swept Drain Pro Fittings', 'Astral Drain Pro fittings represent a premium uPVC drainage system designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. The system features precision engineering for swift installation and enduring performance.

Available sizes/variants: 75mm, 90mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 251, 'https://www.makankidukan.com/uploads/products/1749201433_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749201433_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standards Compliance":"IS 13592 and IS 14735","Key Features":"Leak-proof joints, high chemical resistance, smooth inner surface, corrosion & rust-free, quick & easy installation","Additional":"UV stabilized variants available for outdoor applications; eco-friendly and recyclable material","Stock Status":"In Stock","Available Sizes":"75mm, 90mm, 110mm, 160mm","MRP":"Rs. 251","Source":"https://www.makankidukan.com/building-product/astral-tee-with-door-swept-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Single ''y'' Drain Pro Fittings', 'Premium uPVC drainage components for non-pressure wastewater and drainage applications, offering leak-proof joints, smooth inner surface, and quick & easy installation. Material is UV stabilized, eco-friendly and recyclable.

Available sizes/variants: 40mm, 50mm, 75mm, 90mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 71, 'https://www.makankidukan.com/uploads/products/1749204484_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749204484_0.webp','https://www.makankidukan.com/uploads/products/1749203962_0.png'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Application":"Non-pressure wastewater and drainage","Standards":"IS 13592 and IS 14735","Surface":"Smooth inner surface","Chemical Resistance":"High resistance to acids and alkalis","Corrosion Resistance":"Rust-free, non-corrodible","Stock Status":"In Stock","Available Sizes":"40mm, 50mm, 75mm, 90mm, 110mm, 160mm","MRP":"Rs. 71","Source":"https://www.makankidukan.com/building-product/astral-single-y-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Access Pipe Drain Pro Fittings', 'Premium uPVC drainage components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. Emphasizes installation simplicity, leak-proof performance, and extended durability.

Available sizes/variants: 75mm, 90mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 177, 'https://www.makankidukan.com/uploads/products/1749204451_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749204451_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Stock Status":"In Stock","Standards Compliance":"IS 13592 and IS 14735 (ISI Marked)","Key Features":"Leak-proof joints, chemical resistance, smooth inner surface, corrosion/rust-free, lightweight, solvent cement compatible","Durability Notes":"UV stabilized variants available; eco-friendly and recyclable","Available Sizes":"75mm, 90mm, 110mm, 160mm","MRP":"Rs. 177","Source":"https://www.makankidukan.com/building-product/astral-access-pipe-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Reducer Coupler Drain Pro Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects.

Available sizes/variants: 50x40mm, 75x50mm, 90x75mm, 110x50mm, 110x75mm, 110x90mm, 160x75mm, 160x90mm, 160x110mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 45, 'https://www.makankidukan.com/uploads/products/1749207469_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749207469_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standard":"IS 13592 and IS 14735","Stock Status":"In Stock","Key Features":"Leak-proof joints, high chemical resistance, smooth inner surface, corrosion & rust-free, quick installation, UV stabilized variants available, recyclable","Available Sizes":"50x40mm, 75x50mm, 90x75mm, 110x50mm, 110x75mm, 110x90mm, 160x75mm, 160x90mm, 160x110mm","MRP":"Rs. 45","Source":"https://www.makankidukan.com/building-product/astral-reducer-coupler-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Reducer Single ''y'' Drain Pro Pipes Fittings', 'Premium uPVC drainage system components designed for non-pressure wastewater applications in residential, commercial, and industrial projects. Features precision-designed sockets, chemical resistance, smooth inner surfaces, and quick installation capability using solvent cement.

Available sizes/variants: 110x75mm, 160x75mm, 160x110mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 338, 'https://www.makankidukan.com/uploads/products/1749273472_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749273472_0.png'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standards":"IS 13592 and IS 14735","Key Features":"Leak-proof joints, high chemical resistance, smooth inner surface, corrosion & rust-free, quick & easy installation","Properties":"UV stabilized, eco-friendly, recyclable, non-reactive","Stock Status":"In Stock","Available Sizes":"110x75mm, 160x75mm, 160x110mm","MRP":"Rs. 338","Source":"https://www.makankidukan.com/building-product/astral-reducer-single-y-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Double ''y'' Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications across residential, commercial, and industrial settings. Key features: Leak-Proof Joints - precision-designed sockets and seals ensure a tight, reliable connection; High Chemical Resistance - withstands exposure to acids, alkalis, and other corrosive agents; Smooth Inner Surface - promotes better flow and prevents blockages or scaling; Corrosion & Rust-Free - unlike metal, uPVC fittings do not degrade over time; Quick & Easy Installation - lightweight, easy to cut and join with solvent cement. ISI Marked per IS 13592 and IS 14735 standards. Wide range of components available.

Available sizes/variants: 75 mm, 110 mm, 160 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 293, 'https://www.makankidukan.com/uploads/products/1749275054_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749275054_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standards":"IS 13592 and IS 14735 (ISI Marked)","Properties":"High strength and durability, non-reactive to most chemicals, UV stabilized variants for outdoor use, recyclable and eco-friendly","Price incl. GST":"Rs. 183.24","Return Policy":"7-day return/exchange period","Available Sizes":"75 mm, 110 mm, 160 mm","MRP":"Rs. 293","Source":"https://www.makankidukan.com/building-product/astral-double-y-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Reducer Door Tee Swept Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. Key features include leak-proof joints through precision-designed sockets, resistance to acids and alkalis, smooth inner surfaces that prevent blockages, and corrosion-free construction. Installation involves lightweight components joined with solvent cement. ISI marked, eco-friendly and recyclable material.

Available sizes/variants: 110x50 mm, 110x75 mm, 160x75 mm, 160x110 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 513, 'https://www.makankidukan.com/uploads/products/1749275553_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749275553_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standards":"IS 13592 and IS 14735","Stock Status":"In Stock","Price incl. GST":"Rs. 320.83","Available Sizes":"110x50 mm, 110x75 mm, 160x75 mm, 160x110 mm","MRP":"Rs. 513","Source":"https://www.makankidukan.com/building-product/astral-reducer-door-tee-swept-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Nahani Trap Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. Key features include leak-proof joints, chemical resistance, smooth inner surfaces preventing blockages, and corrosion-free performance, with lightweight installation using solvent cement. Complies with IS 13592 and IS 14735 standards.

Available sizes/variants: 110x75 mm, 110x90 mm, 110x110 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 200, 'https://www.makankidukan.com/uploads/products/1749275935_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749275935_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standard Compliance":"IS 13592, IS 14735","Stock Status":"In Stock","Return Policy":"7 days","Price incl. GST":"Rs. 125.08","Available Sizes":"110x75 mm, 110x90 mm, 110x110 mm","MRP":"Rs. 200","Source":"https://www.makankidukan.com/building-product/astral-nahani-trap-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Reducer Double ''y'' Drain Pro Pipes Fittings', 'This product offers uPVC drainage system components designed for non-pressure waste water and drainage applications across residential, commercial, and industrial settings. The fitting features leak-proof joints, chemical resistance, smooth inner surfaces to prevent blockages, and corrosion-free construction. Installation is lightweight and straightforward using solvent cement, with ISI compliance under IS 13592 and IS 14735 standards.

Available sizes/variants: 160x75 mm, 160x110 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 949, 'https://www.makankidukan.com/uploads/products/1749276462_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749276462_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standards":"ISI Marked (IS 13592, IS 14735)","Benefits":"Corrosion/rust-free, UV stabilized variants, eco-friendly, recyclable","Price incl. GST":"Rs. 593.50","Available Sizes":"160x75 mm, 160x110 mm","MRP":"Rs. 949","Source":"https://www.makankidukan.com/building-product/astral-reducer-double-y-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Multi Floor Trap High Riser Spigot Type Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. Key features include leak-proof joints, chemical resistance, smooth inner surfaces for flow optimization, corrosion-free construction, and easy installation with solvent cement. Complies with ISI standards (IS 13592 and IS 14735).

Available sizes/variants: 110x75x(3)50 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 589, 'https://www.makankidukan.com/uploads/products/1749276729_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749276729_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Dimensions":"110x75x(3)50 mm","Standards":"ISI Marked - IS 13592 and IS 14735","Properties":"UV stabilized variants available, eco-friendly, recyclable","Stock Status":"In Stock","Price incl. GST":"Rs. 368.99","Return Policy":"7-day return window","Available Sizes":"110x75x(3)50 mm","MRP":"Rs. 589","Source":"https://www.makankidukan.com/building-product/astral-multi-floor-trap-high-riser-spigot-type-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Multi Floor Trap Spigot Type 50mm Open Drain Pro Pipes Fittings', 'Premium uPVC drainage system components for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. Features include leak-proof joints with precision-designed seals, high chemical resistance to acids and alkalis, smooth interior surfaces that prevent blockages, corrosion-free construction, quick installation with solvent cement, and UV-stabilized options for outdoor use. Eco-friendly and recyclable material.

Available sizes/variants: 110x75x(3)50 mm (Common)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 996, 'https://www.makankidukan.com/uploads/products/1749278014_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749278014_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness":"110x75x(3)50 mm","Standards":"IS 13592, IS 14735","Stock Status":"In Stock","Price incl. GST":"Rs. 622.90","Return Policy":"7 days","Available Sizes":"110x75x(3)50 mm (Common)","MRP":"Rs. 996","Source":"https://www.makankidukan.com/building-product/astral-multi-floor-trap-spigot-type-50mm-open-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Multi Floor Trap Spigot Type 50mm Close Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications. These components feature leak-proof joints, high chemical resistance, smooth inner surfaces, corrosion-free construction, and quick installation capabilities. The material is UV stabilized, recyclable, and non-reactive to most chemicals.

Available sizes/variants: 110x75x(3)50 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 809, 'https://www.makankidukan.com/uploads/products/1749278683_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749278683_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Size/Capacity":"110x75x(3)50 mm","Standards":"IS 13592 and IS 14735","Stock Status":"In Stock","Return Policy":"7 Days","Price incl. GST":"Rs. 428.77","Available Sizes":"110x75x(3)50 mm","MRP":"Rs. 809","Source":"https://www.makankidukan.com/building-product/astral-multi-floor-trap-spigot-type-50mm-close-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Multi Floor Trap 75mm W.s. Spigot Type 50mm Open Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. Features leak-proof joints, high chemical resistance, smooth inner surfaces, corrosion-free construction, and quick installation capabilities. Complies with IS 13592 and IS 14735 standards. UV stabilized variants available, eco-friendly and recyclable.

Available sizes/variants: 75MM W.S., Spigot Type 50MM Open, 110x75x(3)50 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1050, 'https://www.makankidukan.com/uploads/products/1749279680_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749279680_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Dimensions/Thickness":"110x75x(3)50 mm","Type":"Spigot Type, Multi Floor Trap","Drain Size":"50MM Open Drain","Trap Size":"75MM W.S.","Stock Status":"In Stock","Price incl. GST":"Rs. 656.67","Return Policy":"7-day returns & exchange policy","Available Sizes":"75MM W.S., Spigot Type 50MM Open, 110x75x(3)50 mm","MRP":"Rs. 1050","Source":"https://www.makankidukan.com/building-product/astral-multi-floor-trap-75mm-ws-spigot-type-50mm-open-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Multi Floor Trap 75mm W.s. Spigot Type 50mm Close Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC (Unplasticized Polyvinyl Chloride) drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. Features leak-proof joints, high chemical resistance, smooth inner surface, corrosion & rust-free construction, and quick & easy installation with solvent cement. ISI Marked, complies with IS 13592 and IS 14735 standards; UV stabilized variants available for outdoor use.

Available sizes/variants: 110x75x(3)50 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1014, 'https://www.makankidukan.com/uploads/products/1749279845_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749279845_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Dimensions":"110x75x(3)50 mm","Thickness":"3 mm","Standards":"IS 13592 and IS 14735","Stock Status":"In Stock","Available Sizes":"110x75x(3)50 mm","MRP":"Rs. 1014","Source":"https://www.makankidukan.com/building-product/astral-multi-floor-trap-75mm-ws-spigot-type-50mm-close-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Corner Tee Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. Key features include leak-proof joints, chemical resistance, smooth inner surfaces that prevent blockages, corrosion-free construction, and easy installation with solvent cement. Non-reactive to most chemicals, UV stabilized variants available for outdoor use, recyclable, high strength and durability. Complies with IS 13592 and IS 14735 standards.

Available sizes/variants: 110 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 487, 'https://www.makankidukan.com/uploads/products/1749280287_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749280287_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness":"110 mm","Standards":"IS 13592, IS 14735","Product Type":"Corner Tee Drain Fitting","Stock Status":"In Stock","Available Sizes":"110 mm","MRP":"Rs. 487","Source":"https://www.makankidukan.com/building-product/astral-corner-tee-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Multi Floor Trap High Riser 50mm Open Drain Pro Pipes Fittings', 'Astral Drain Pro fittings represent a premium uPVC drainage system for non-pressure wastewater and drainage applications in residential, commercial, and industrial settings. Features leak-proof joints, high chemical resistance, smooth inner surface, corrosion & rust-free construction, quick & easy installation, and UV stabilization for outdoor applications. uPVC composition offers high strength and durability, non-reactivity to most chemicals, and is eco-friendly and recyclable.

Available sizes/variants: 110x75x(3)50 mm (common)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 468, 'https://www.makankidukan.com/uploads/products/1749281703_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749281703_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Dimensions":"110x75x(3)50 mm","Standards":"IS 13592 and IS 14735","Stock Status":"In Stock","Available Sizes":"110x75x(3)50 mm (common)","MRP":"Rs. 468","Source":"https://www.makankidukan.com/building-product/astral-multi-floor-trap-high-riser-50mm-open-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Multi Floor Trap High Riser 50mm Close Drain Pro Pipes Fittings', 'Astral Drain Pro fittings represent a premium uPVC drainage system designed for non-pressure wastewater and drainage in residential, commercial, and industrial applications. Features precision-designed sockets with reliable seals, resists acids and alkalis, maintains a smooth inner surface to prevent blockages, and requires no anti-corrosion treatment unlike metal alternatives. Installation involves lightweight components easily cut and joined using solvent cement. Complies with IS 13592 and IS 14735 standards.

Available sizes/variants: 50mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 534, 'https://www.makankidukan.com/uploads/products/1749282100_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749282100_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Dimensions":"110x75x(3)50 mm","Thickness":"3mm","Application":"Non-pressure waste water drainage","UV Stabilization":"Available for outdoor use","Certifications":"ISI Marked (IS 13592, IS 14735)","Recyclability":"Eco-friendly and recyclable","Available Sizes":"50mm","MRP":"Rs. 534","Source":"https://www.makankidukan.com/building-product/astral-multi-floor-trap-high-riser-50mm-close-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Plain Floor Trap Spigot Type Drain Pro Pipes Fittings', 'Astral Drain Pro fittings represent a premium uPVC drainage system designed for non-pressure wastewater applications across residential, commercial, and industrial settings. These components feature precision engineering for dependable, long-lasting performance, high chemical resistance, smooth inner surface, corrosion and rust-free construction, and quick easy installation with solvent cement. Recyclable; UV stabilized outdoor variants available.

Available sizes/variants: Common

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 200, 'https://www.makankidukan.com/uploads/products/1749282547_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749282547_0.png'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness":"110x75 mm","Standards Compliance":"IS 13592 and IS 14735 (ISI Marked)","Chemical Resistance":"High; resists acids, alkalis, corrosive agents","Surface Finish":"Smooth inner surface","Durability":"Corrosion and rust-free","Installation":"Quick and easy with solvent cement","Environmental":"Recyclable; UV stabilized outdoor variants available","Available Sizes":"Common","MRP":"Rs. 200","Source":"https://www.makankidukan.com/building-product/astral-plain-floor-trap-spigot-type-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Reducer Door ''y'' Drain Pro Pipes Fittings', 'Astral Drain Pro fittings represent a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications across residential, commercial, and industrial settings. The system features solvent cement installation, high resistance to acids, alkalis and corrosives, smooth inner surface for flow optimization, corrosion and rust-free composition, and lightweight, quick assembly.

Available sizes/variants: 110x75 mm, 160x75 mm, 160x110 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 421, 'https://www.makankidukan.com/uploads/products/1749284433_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749284433_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standards Compliance":"IS 13592 and IS 14735 (ISI Marked)","Chemical Resistance":"High resistance to acids, alkalis, corrosives","Surface":"Smooth inner surface for flow optimization","Durability":"Corrosion and rust-free composition","Installation":"Lightweight, quick assembly with solvent cement","Available Sizes":"110x75 mm, 160x75 mm, 160x110 mm","MRP":"Rs. 421","Source":"https://www.makankidukan.com/building-product/astral-reducer-door-y-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Double Tee Swept Drain Pro Pipes Fittings', 'Premium uPVC drainage components engineered for non-pressure wastewater applications across residential, commercial, and industrial settings. The fittings feature precision-designed components for dependable connections and extended operational lifespan, leak-proof joints, high chemical resistance, smooth inner surface, corrosion & rust-free construction, and quick & easy installation.

Available sizes/variants: 75 mm, 110 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 241, 'https://www.makankidukan.com/uploads/products/1749290518_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749290518_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness Options":"75 mm, 110 mm","Standards Compliance":"ISI Marked (IS 13592, IS 14735)","Chemical Resistance":"Withstands acids, alkalis, corrosive agents","Installation":"Lightweight, solvent cement joining","Durability":"Corrosion and rust-free performance","Available Sizes":"75 mm, 110 mm","MRP":"Rs. 241","Source":"https://www.makankidukan.com/building-product/astral-double-tee-swept-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral P Trap Body Drain Pro Pipes Fittings', 'Astral Drain Pro fittings represent a premium uPVC drainage system designed for non-pressure wastewater and drainage applications across residential, commercial, and industrial settings. These components feature precision-engineered sockets and seals for leak-proof joints and demonstrate high chemical resistance to acids, alkalis, and corrosive agents. The smooth inner surface prevents blockages, and the material resists corrosion and rust degradation. Installation is lightweight and straightforward using solvent cement. ISI certification ensures compliance with IS 13592 and IS 14735 standards.

Available sizes/variants: 75x75 mm, 110x110 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 301, 'https://www.makankidukan.com/uploads/products/1749291326_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749291326_0.webp','https://www.makankidukan.com/uploads/products/1749291326_1.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material Type":"uPVC (Unplasticized Polyvinyl Chloride)","Durability":"High strength with non-reactive properties to most chemicals","UV Protection":"Stabilized variants available for outdoor applications","Sustainability":"Eco-friendly and recyclable","Available Sizes":"75x75 mm, 110x110 mm","MRP":"Rs. 301","Source":"https://www.makankidukan.com/building-product/astral-p-trap-body-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Extension Piece For Nahani Trap Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. The fitting features leak-proof joints, chemical resistance, smooth inner surfaces, and corrosion-free construction. Installation involves lightweight components joined with solvent cement. The material is Unplasticized Polyvinyl Chloride that remains non-reactive and offers UV-stabilized outdoor variants with recyclable properties.

Available sizes/variants: Common (110 mm)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 185, 'https://www.makankidukan.com/uploads/products/1749292424_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749292424_0.png'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness":"110 mm","Standards Compliance":"IS 13592 and IS 14735","Pressure Rating":"Non-pressure application","Stock Status":"In Stock","Available Sizes":"Common (110 mm)","MRP":"Rs. 185","Source":"https://www.makankidukan.com/building-product/astral-extention-piece-for-nahani-trap-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Clean Out Access Plug Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. These fittings feature leak-proof joints, high chemical resistance, smooth inner surfaces that prevent blockages, and corrosion-free construction. Installation is straightforward using solvent cement, and the product complies with IS 13592 and IS 14735 standards. The range includes bends, tees, reducers, traps, and couplers.

Available sizes/variants: Common (110 mm thickness)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 411, 'https://www.makankidukan.com/uploads/products/1749293673_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749293673_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness":"110 mm","Application":"Non-pressure waste water and drainage","Standards":"IS 13592 and IS 14735","Features":"Leak-proof joints, chemical resistant, UV stabilized variants available, recyclable, eco-friendly","Available Sizes":"Common (110 mm thickness)","MRP":"Rs. 411","Source":"https://www.makankidukan.com/building-product/astral-clean-out-access-plug-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral End Plug Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications. The product features leak-proof joints, high chemical resistance, smooth inner surfaces to prevent blockages, and rust-free construction. Installation is straightforward using solvent cement, and the fittings comply with Indian Standards IS 13592 and IS 14735.

Available sizes/variants: 50 mm, 75 mm, 90 mm, 110 mm, 160 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 55, 'https://www.makankidukan.com/uploads/products/1749294012_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749294012_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Application":"Non-pressure wastewater/drainage systems","Standards":"IS 13592, IS 14735 (ISI Marked)","Features":"Leak-proof, chemical resistant, corrosion-free, UV stabilized variants available","Installation":"Quick and easy with solvent cement","Available Sizes":"50 mm, 75 mm, 90 mm, 110 mm, 160 mm","MRP":"Rs. 55","Source":"https://www.makankidukan.com/building-product/astral-end-plug-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Wc Connector 300 mm Length Drain Pro Pipes Fittings', 'The product is a premium uPVC drainage system component from Astral''s Drain Pro range, designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. Key features include leak-proof joints with precision-designed sockets, chemical resistance to acids and alkalis, smooth inner surfaces that promote flow, and corrosion-free construction. Installation involves lightweight components that are easy to cut and join with solvent cement.

Available sizes/variants: Common, 110 mm thickness, 300 mm length

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 249, 'https://www.makankidukan.com/uploads/products/1749294251_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749294251_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Product Type":"WC Connector","Length":"300 mm","Size/Capacity":"Common","Thickness":"110 mm","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standards":"ISI Marked - IS 13592 and IS 14735","Surface":"Smooth inner surface","Stock Status":"In Stock","Available Sizes":"Common, 110 mm thickness, 300 mm length","MRP":"Rs. 249","Source":"https://www.makankidukan.com/building-product/astral-wc-connector-300-mm-length-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Wc Connector 600 mm Length Drain Pro Pipes Fittings', 'The Astral Drain Pro fitting is a uPVC drainage component designed for non-pressure wastewater applications in residential, commercial, and industrial settings. Key features include Leak-Proof Joints, High Chemical Resistance, Smooth Inner Surface, and Corrosion & Rust-Free construction. The material is lightweight, easy to install with solvent cement, and complies with IS 13592 and IS 14735 standards.

Available sizes/variants: 110 mm thickness, 600 mm length

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 414, 'https://www.makankidukan.com/uploads/products/1749294370_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749294370_0.jpg'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Product Type":"WC Connector","Length":"600 mm","Thickness":"110 mm","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Application":"Non-pressure waste water & drainage","Standards":"IS 13592, IS 14735","Features":"UV stabilized, recyclable, chemical resistant","Available Sizes":"110 mm thickness, 600 mm length","MRP":"Rs. 414","Source":"https://www.makankidukan.com/building-product/astral-wc-connector-600-mm-length-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Bend 45 Degree With 50 mm Vent Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. The product features leak-proof joints, high chemical resistance, smooth inner surfaces, corrosion resistance, and quick installation capabilities. It complies with IS 13592 and IS 14735 standards.

Available sizes/variants: Common (110 mm thickness, 50 mm vent)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 572, 'https://www.makankidukan.com/uploads/products/1749295818_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749295818_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness":"110 mm","Fitting Type":"45 Degree Bend with Vent Drain","Pipe Size":"50 mm","Product Line":"Drain Pro","Standards":"IS 13592, IS 14735","Status":"In Stock","Available Sizes":"Common (110 mm thickness, 50 mm vent)","MRP":"Rs. 572","Source":"https://www.makankidukan.com/building-product/astral-bend-45-degree-with-50-mm-vent-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Reducer Bend 45 Degree With 50 mm Vent Drain Pro Pipes Fittings', 'Premium uPVC drainage components designed for non-pressure wastewater applications in residential, commercial, and industrial settings. Features precision-designed sockets, chemical resistance, smooth inner surfaces to prevent blockages, and lightweight construction compatible with solvent cement installation. The material is UV-stabilized, eco-friendly, and recyclable.

Available sizes/variants: 110×75 mm (reducer bend with 50 mm vent drain)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 630, 'https://www.makankidukan.com/uploads/products/1749296432_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749296432_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Size/Capacity":"Common","Thickness":"110×75 mm","Standards":"ISI Marked (IS 13592, IS 14735)","Features":"Leak-Proof Joints, High Chemical Resistance, Smooth Inner Surface, Corrosion & Rust-Free, Quick & Easy Installation","Available Sizes":"110×75 mm (reducer bend with 50 mm vent drain)","MRP":"Rs. 630","Source":"https://www.makankidukan.com/building-product/astral-reducer-bend-45-degree-with-50-mm-vent-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Reducer Bend 45 Degree Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications. Key features include leak-proof joints, chemical resistance, smooth inner surfaces preventing blockages, corrosion-free construction, and easy installation with solvent cement. The product complies with IS 13592 and IS 14735 standards and is available in a wide range including bends, tees, reducers, traps, and couplers.

Available sizes/variants: Common, 110×75 mm thickness

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 494, 'https://www.makankidukan.com/uploads/products/1749296678_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749296678_0.webp'], '{"Brand":"ASTRAL PIPES","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Dimensions":"110×75 mm","Product Type":"Reducer Bend (45 Degree)","Application":"Drainage/Waste water (non-pressure)","Finish":"Corrosion & rust-free","Available Sizes":"Common, 110×75 mm thickness","MRP":"Rs. 494","Source":"https://www.makankidukan.com/building-product/astral-reducer-bend-45-degree-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Knob With Rubber Gasket For Mft Partition Drain Pro Pipes Fittings', 'Premium uPVC drainage system component designed for non-pressure wastewater applications. Features precision-designed sockets with leak-proof joints, high chemical resistance, and smooth inner surface to prevent blockages. Material is corrosion-resistant and quick to install using solvent cement.

Available sizes/variants: Common (single option)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 24, 'https://www.makankidukan.com/uploads/products/1749297179_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749297179_0.png'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness":"110 mm","Standards":"ISI Marked (IS 13592, IS 14735)","Features":"Leak-proof joints, chemical resistant, rust-free, UV stabilized variants available","Price Including GST":"Rs. 15.01","Available Sizes":"Common (single option)","MRP":"Rs. 24","Source":"https://www.makankidukan.com/building-product/astral-knob-with-rubber-gasket-for-mft-partition-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Partition With Knob For Mft 6 Inch Height Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications. The product features leak-proof joints, chemical resistance, smooth inner surfaces, and corrosion-free construction.

Available sizes/variants: Common (no additional variants specified)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 79, 'https://www.makankidukan.com/uploads/products/1749297966_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749297966_0.png'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Durability":"High strength and durability","Chemical Resistance":"Non-reactive to most chemicals","UV Stabilization":"Variants available for outdoor use","Eco-friendly":"Recyclable","Standards":"ISI Marked (IS 13592 and IS 14735)","Price Including GST":"Rs. 49.41","Available Sizes":"Common (no additional variants specified)","MRP":"Rs. 79","Source":"https://www.makankidukan.com/building-product/astral-partition-with-knob-for-mft-6-inch-height-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Partition With Knob For Mft 7 Inch Height Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects.

Available sizes/variants: Size/Capacity: Common; Thickness: 110 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 86, 'https://www.makankidukan.com/uploads/products/1749298109_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749298109_0.png'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness":"110 mm","Standards":"IS 13592 and IS 14735","Features":"Leak-proof joints, chemical resistant, smooth inner surface, corrosion-free, easy installation","Price Including GST":"Rs. 53.78","Available Sizes":"Size/Capacity: Common; Thickness: 110 mm","MRP":"Rs. 86","Source":"https://www.makankidukan.com/building-product/astral-partition-with-knob-for-mft-7-inch-height-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Repair Coupler Drain Pro Pipes Fittings', 'Premium uPVC drainage system components engineered for non-pressure waste water and drainage applications in residential, commercial, and industrial settings with solvent cement installation.

Available sizes/variants: 50 mm, 75 mm, 90 mm, 110 mm, 160 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 75, 'https://www.makankidukan.com/uploads/products/1749298938_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749298938_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standards":"IS 13592 and IS 14735","Key Features":"Leak-proof joints, chemical resistance, smooth inner surface, corrosion-free, quick installation","Finish":"UV stabilized variants available","Price Including GST":"Rs. 46.91","Available Sizes":"50 mm, 75 mm, 90 mm, 110 mm, 160 mm","MRP":"Rs. 75","Source":"https://www.makankidukan.com/building-product/astral-repair-coupler-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Hanging Clamp Drain Pro Pipes Fittings', 'Premium uPVC drainage system components designed for non-pressure wastewater and drainage applications. The fittings feature precision-designed sockets and seals and smooth inner surface to prevent blockages, with corrosion-free performance and lightweight installation using solvent cement.

Available sizes/variants: Common size (110 mm thickness)

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 670, 'https://www.makankidukan.com/uploads/products/1749447311_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749447311_0.png'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness":"110 mm","Standards":"IS 13592 and IS 14735","Key Features":"Leak-proof joints, high chemical resistance, corrosion & rust-free, quick & easy installation, UV stabilized variants available","Price Including GST":"Rs. 419.02","Available Sizes":"Common size (110 mm thickness)","MRP":"Rs. 670","Source":"https://www.makankidukan.com/building-product/astral-hanging-clamp-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Sovent Drain Pro Pipes Fittings', 'Premium uPVC drainage system components engineered for non-pressure waste water and drainage applications in residential, commercial, and industrial settings with quick installation and leak-proof performance.

Available sizes/variants: Common

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 6971, 'https://www.makankidukan.com/uploads/products/1749447775_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749447775_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness":"110 mm","Standards":"ISI Marked, complies with IS 13592 and IS 14735","Features":"Leak-proof joints, high chemical resistance, smooth inner surface, corrosion/rust-free, UV stabilized variants available","Product Range":"Includes bends, tees, reducers, traps, couplers","Price Including GST":"Rs. 4,359.66","Available Sizes":"Common","MRP":"Rs. 6971","Source":"https://www.makankidukan.com/building-product/astral-sovent-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral S Trap Drain Pro Pipes Fittings', 'Premium uPVC drainage system components for non-pressure wastewater applications in residential, commercial, and industrial settings. Features leak-proof joints, high chemical resistance, smooth inner surfaces, and corrosion-free construction. Materials include uPVC with UV stabilization options and eco-friendly recyclability.

Available sizes/variants: 110x110 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1116, 'https://www.makankidukan.com/uploads/products/1749447990_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749447990_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Thickness":"110x110 mm","Standards":"IS 13592 and IS 14735 (ISI Marked)","Chemical Resistance":"Acids, alkalis, corrosive agents","Installation":"Lightweight, solvent cement joining method","Price Including GST":"Rs. 697.95","Available Sizes":"110x110 mm","MRP":"Rs. 1116","Source":"https://www.makankidukan.com/building-product/astral-s-trap-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Reducer Short Drain Pro Pipes Fittings', 'Premium uPVC drainage system designed for non-pressure wastewater applications. Features leak-proof joints with precision-designed sockets and seals for reliable connections. The system provides chemical resistance and corrosion-free performance suitable for residential and commercial projects.

Available sizes/variants: 110x75 mm, 160x110 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 159, 'https://www.makankidukan.com/uploads/products/1749448492_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749448492_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Available Sizes":"110x75 mm, 160x110 mm","Standards":"ISI Marked (IS 13592 and IS 14735 compliance)","Key Features":"Smooth inner surface, UV stabilized variants available, lightweight, recyclable","Price Including GST":"Rs. 99.44","MRP":"Rs. 159","Source":"https://www.makankidukan.com/building-product/astral-reducer-short-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Rubber Sealing Ring Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC (Unplasticized Polyvinyl Chloride) drainage system components engineered for non-pressure wastewater and drainage applications in residential, commercial, and industrial projects. They feature leak-proof joints via precision-designed sockets, high resistance to acids, alkalis, and corrosive agents, a smooth inner surface that prevents blockages, corrosion and rust resistance, a lightweight design for easy installation with solvent cement, and are available across a wide range including bends, tees, reducers, and traps. The range is ISI marked, complying with IS 13592 and IS 14735, with UV stabilized variants available, and is eco-friendly and recyclable.

Available sizes/variants: Thickness options: 40 mm, 50 mm, 75 mm, 90 mm, 110 mm, 160 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 11.5, 'https://www.makankidukan.com/uploads/products/1749448992_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749448992_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Application":"Non-pressure wastewater and drainage systems","Standards Compliance":"ISI Marked (IS 13592, IS 14735)","Key Features":"High strength, UV stabilized variants, recyclable, non-reactive","Available Sizes":"Thickness options: 40 mm, 50 mm, 75 mm, 90 mm, 110 mm, 160 mm","MRP":"Rs. 11.5","Source":"https://www.makankidukan.com/building-product/astral-rubber-sealing-ring-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Rubber O Ring For Access Door Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications in residential, commercial, and industrial projects. Key features include leak-proof joints with precision-designed sockets, chemical resistance, smooth inner surfaces, corrosion-free construction, and easy installation using solvent cement. The product complies with IS 13592 and IS 14735 standards and is ISI marked, with UV stabilized variants available and eco-friendly, recyclable material.

Available sizes/variants: Thickness options: 75 mm, 110 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 11.5, 'https://www.makankidukan.com/uploads/products/1749454733_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749454733_0.png'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Characteristics":"High strength, non-reactive, UV stabilized variants available, eco-friendly and recyclable","Application":"Non-pressure wastewater and drainage systems","Available Sizes":"Thickness options: 75 mm, 110 mm","MRP":"Rs. 11.5","Source":"https://www.makankidukan.com/building-product/astral-rubber-o-ring-for-access-door-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Safety Clip For Coupler Clamp Door Drain Pro Pipes Fittings', 'Part of Astral Drain Pro fittings, a premium uPVC drainage system for non-pressure wastewater applications in residential, commercial, and industrial settings. Features precision-designed sockets and seals for tight connections, resistance to acids, alkalis, and other corrosive agents, and a lightweight design that is easy to cut and join for installation. Leak-proof, corrosion/rust-free, smooth inner surface, UV stabilized variants available, and recyclable. ISI marked, complying with IS 13592 and IS 14735.

Available sizes/variants: 75mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 180, 'https://www.makankidukan.com/uploads/products/1749455560_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749455560_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Available Thicknesses":"75 mm, 110 mm, 160 mm","Standards":"IS 13592 and IS 14735 (ISI Marked)","Features":"Leak-proof, corrosion/rust-free, smooth inner surface, UV stabilized variants available, recyclable","Available Sizes":"75mm, 110mm, 160mm","MRP":"Rs. 180","Source":"https://www.makankidukan.com/building-product/astral-safety-clip-for-coupler-clamp-door-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Safety Clip For Socket Plug End Cap Door Drain Pro Pipes Fittings', 'Astral Drain Pro fittings represent a premium range of uPVC drainage system components designed for non-pressure waste water applications across residential, commercial, and industrial sectors. Key features include leak-proof joints, high chemical resistance, a smooth inner surface, corrosion & rust-free construction, and quick & easy installation. ISI marked, complying with IS 13592 and IS 14735.

Available sizes/variants: Thickness options: 75 mm, 110 mm, 160 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 180, 'https://www.makankidukan.com/uploads/products/1749455786_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749455786_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride) - high strength and durability, non-reactive to most chemicals, UV stabilized variants available for outdoor use, eco-friendly and recyclable","Standards Compliance":"ISI Marked (IS 13592 and IS 14735)","Size/Capacity":"Common","Available Sizes":"Thickness options: 75 mm, 110 mm, 160 mm","MRP":"Rs. 180","Source":"https://www.makankidukan.com/building-product/astral-safety-clip-for-socket-plug-end-cap-door-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Heavy Duty Saddle With Rubber Drain Pro Pipes Fittings', 'Astral Drain Pro fittings are a premium range of uPVC drainage system components designed for non-pressure waste water and drainage applications, with the offering including bends, tees, reducers, traps, and couplers, comprised of Unplasticized Polyvinyl Chloride material that is high strength and durable and non-reactive to most chemicals. Features leak-proof joints with precision-designed sockets, high chemical resistance against acids and alkalis, a smooth inner surface preventing blockages, corrosion and rust-free composition, quick installation with solvent cement. ISI marked, complying with IS 13592 and IS 14735, with UV stabilized variants available, and eco-friendly and recyclable.

Available sizes/variants: Thickness options: 40 mm, 50 mm, 75 mm, 90 mm, 110 mm, 160 mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 20, 'https://www.makankidukan.com/uploads/products/1749456188_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749456188_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Standards Compliance":"ISI Marked (IS 13592, IS 14735)","Available Sizes":"Thickness options: 40 mm, 50 mm, 75 mm, 90 mm, 110 mm, 160 mm","MRP":"Rs. 20","Source":"https://www.makankidukan.com/building-product/astral-heavy-duty-saddle-with-rubber-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Split Clamps Drain Pro Pipes Fittings', 'Premium uPVC drainage system components engineered for non-pressure wastewater applications in residential, commercial, and industrial settings. Features include leak-proof joints with precision-designed sockets, high chemical resistance to acids and alkalis, smooth inner surfaces preventing blockages, corrosion-free composition, lightweight construction for easy installation using solvent cement, ISI certification (IS 13592 and IS 14735 compliance), and availability in multiple fittings including bends, tees, and reducers.

Available sizes/variants: Thickness options: 40mm, 50mm, 63mm, 75mm, 90mm, 110mm, 160mm

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 59, 'https://www.makankidukan.com/uploads/products/1749456846_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749456846_0.webp'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Characteristics":"High strength and durability, non-reactive to most chemicals, UV stabilized variants for outdoor applications, eco-friendly and recyclable","Available Sizes":"Thickness options: 40mm, 50mm, 63mm, 75mm, 90mm, 110mm, 160mm","MRP":"Rs. 59","Source":"https://www.makankidukan.com/building-product/astral-split-clamps-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Ptfe Tape 12 mm Width Drain Pro Pipes Fittings', 'This PTFE thread seal tape produces strong, durable joints that become virtually leak-proof, with quick drying capabilities. It offers high/low temperature resilience and is designed to withstand high-pressure systems without failure. The formulation includes PTFE-based compounds suitable for thread sealing applications, with low-VOC and eco-friendly options available. Features high bond strength, fast curing, temperature resistance, easy application, and is safe & non-toxic.

Available sizes/variants: 4 MTR, 8 MTR

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 20, 'https://www.makankidukan.com/uploads/products/1749458103_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749458103_0.jpg'], '{"Brand":"Astral","Category":"SWR / DrainPro Pipes & Fittings","Type":"PTFE thread seal tape","Features":"High bond strength, fast curing, temperature resistance, easy application, safe & non-toxic","Available Sizes":"4 MTR, 8 MTR","MRP":"Rs. 20","Source":"https://www.makankidukan.com/building-product/astral-ptfe-tape-12-mm-width-drain-pro-pipes-fittings"}'::jsonb, v_sub1, 100, true),
  ('Astral Ips Weld On 500 Cts Adhesive Solution Yellow Solvent', 'Astral Solvent Cements and Primers are specially formulated adhesives designed for joining plastic pipes and fittings. They work through chemical softening of pipe surfaces to create leak-proof joints.

Available sizes/variants: 50 ml, 118 ml, 237 ml, 473 ml, 946 ml

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 165, 'https://www.makankidukan.com/uploads/products/1749111042_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749111042_0.jpg'], '{"Brand":"Astral Pipes","Category":"Solvent Cement & Adhesives","Product Type":"Solvent Cement & Primer","Color":"Yellow","Bond Strength":"High-strength joints for long-term durability","Curing":"Fast setting; reduces installation time","Viscosity":"Available in regular, medium, and heavy-bodied grades","Material Compatibility":"PVC, CPVC, UPVC piping systems","Temperature Resistance":"Up to 93°C (200°F) for certain formulations","Standards":"ASTM, NSF, and IS compliant","Application":"Brushable; spreads uniformly without running","Available Sizes":"50 ml, 118 ml, 237 ml, 473 ml, 946 ml","MRP":"Rs. 165","Source":"https://www.makankidukan.com/building-product/astral-pipe-ips-weld-on-500-cts-adhesive-solution-yellow-solvent-cements-and-primer"}'::jsonb, v_sub2, 100, true),
  ('Astral Pipefix CPVC 307 Solvent Cements And Primer', 'A specialized adhesive for joining plastic pipes and fittings. It works by chemically softening the surfaces of the pipe and fitting, allowing them to fuse together into a strong, leak-proof joint. Provides high-strength bonds with quick curing, uniform application without running, and temperature resistance up to 93°C. Compatible with PVC, CPVC, and UPVC piping systems and meets international standards including ASTM, NSF, and IS.

Available sizes/variants: 50 ml, 118 ml, 237 ml, 473 ml, 946 ml

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 170, 'https://www.makankidukan.com/uploads/products/1749111328_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749111328_0.jpg','https://www.makankidukan.com/uploads/products/1749111328_1.webp'], '{"Brand":"Astral Pipes","Category":"Solvent Cement & Adhesives","High Bond Strength":"Yes","Fast Curing":"Yes","Temperature Resistance":"Up to 93°C","Easy Application":"Yes","Stock Status":"In Stock","Return Policy":"7 Days","Available Sizes":"50 ml, 118 ml, 237 ml, 473 ml, 946 ml","MRP":"Rs. 170","Source":"https://www.makankidukan.com/building-product/astral-pipe-pipefix-cpvc-307-solvent-cements-and-primer"}'::jsonb, v_sub2, 100, true),
  ('Astral Ips Weld On Primer P 70 Suitable For(2 1/2"-12")', 'A solvent cement and primer specifically formulated for joining plastic pipes and fittings. It works by chemically softening pipe and fitting surfaces to create strong, leak-proof joints. Key features include high-strength bonding for long-term durability, quick curing to reduce installation time, and uniform application without running. The primer is designed for PVC, CPVC, and UPVC piping systems with available heavy-bodied grades for different applications. It resists temperatures up to 93°C (200°F) for CPVC variants, meets international standards (ASTM, NSF, IS), and includes non-flammable and low VOC options for safer indoor use.

Available sizes/variants: 473 ml, 946 ml

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 625, 'https://www.makankidukan.com/uploads/products/1749111865_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749111865_0.jpg','https://www.makankidukan.com/uploads/products/1749111865_1.jpg'], '{"Brand":"Astral Pipes","Category":"Solvent Cement & Adhesives","Suitable For":"2½\"-12\" SCH 40 & SCH 80","Compatibility":"PVC, CPVC, UPVC pipes","Temperature Resistance":"Up to 93°C / 200°F","Stock Status":"In Stock","Return Period":"7 Days","Available Sizes":"473 ml, 946 ml","MRP":"Rs. 625","Source":"https://www.makankidukan.com/building-product/astral-pipe-ips-weld-on-primer-p-70-suitable-for2-12-12-sch-40-sch-80-solvent-cements-and-primer"}'::jsonb, v_sub2, 100, true),
  ('Astral CPVC 724 Suitable For (2 1/2"*12") SCH 40 & SCH 80', 'Astral Solvent Cements and Primers are specially formulated adhesives designed for joining plastic pipes and fittings. They chemically soften surfaces to create leak-proof joints. Key features include strong bonding, quick setting, compatibility with PVC/CPVC/UPVC systems, uniform application, and temperature resistance up to 93°C.

Available sizes/variants: 473 ml, 946 ml

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1415, 'https://www.makankidukan.com/uploads/products/1749112141_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749112141_0.webp','https://www.makankidukan.com/uploads/products/1749112141_1.jpg'], '{"Brand":"Astral","Category":"Solvent Cement & Adhesives","High Bond Strength":"Provides durable, long-term joints","Fast Curing":"Reduces installation time","Temperature Resistance":"Withstands up to 93°C (200°F)","Easy Application":"Brushable, spreads uniformly","Material Compatibility":"PVC, CPVC, UPVC piping systems","Standards Compliance":"Meets ASTM, NSF, and IS requirements","Low VOC Options":"Eco-friendly variants available","Primer Types":"Color-coded (typically purple or clear)","Available Sizes":"473 ml, 946 ml","MRP":"Rs. 1415","Source":"https://www.makankidukan.com/building-product/astral-pipe-cpvc-724-suitable-for-2-1212-sch-40-sch-80-solvent-cements-and-primer"}'::jsonb, v_sub2, 100, true),
  ('Astral Pipe Bondset Fast Setting CPVC Pipes Fitting Ancillary Products', 'High Bond Strength solvent cement producing durable, virtually leak-proof joints. Fast Curing formulation for quick drying/curing to expedite installation. Temperature Resistance - formulated for high/low temperature resilience. Easy Application with smooth, easy-flow formulation. Safe & Non-toxic with low-VOC eco-friendly options. Composition includes CPVC/PVC resins, solvents (MEK, THF), and stabilizers, plus primers for surface cleaning/softening, petroleum-based or synthetic lubricants safe for potable water, and PTFE-based thread sealants. Designed for pressure resistance in piping systems meeting domestic and industrial standards.

Available sizes/variants: 50 GM, 100 GM

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 20, 'https://www.makankidukan.com/uploads/products/1749117124_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749117124_0.png'], '{"Brand":"Astral","Category":"Solvent Cement & Adhesives","Material/Composition":"CPVC/PVC resins, solvents (MEK, THF), stabilizers","Key Property":"High Bond Strength","Curing":"Fast Curing","Temperature Resistance":"Formulated for high/low temperature resilience","Application":"Easy Application, smooth flow","Safety":"Safe & Non-toxic, low-VOC options","Stock Status":"In Stock","Return Policy":"7 days","Available Sizes":"50 GM, 100 GM","MRP":"Rs. 20","Source":"https://www.makankidukan.com/building-product/astral-pipe-bondset-fast-setting-cpvc-pipes-fitting-ancillary-products"}'::jsonb, v_sub2, 100, true),
  ('Astral Pipe Resi-shield CPVC Pipes Fitting Ancillary Products', 'High Bond Strength solvent cement producing leak-proof joints. Fast Curing accelerates installation timelines. Temperature Resistance formulated for extreme conditions. Pressure Resistance suitable for high-pressure systems. Easy Application with smooth, efficient flow. Safe & Non-toxic with low-VOC options available. Composition combines CPVC or PVC resins, solvents like MEK and THF, and stabilizers. Additional components include primers, lubricants for potable water use, and PTFE-based thread sealants.

Available sizes/variants: 100 ml, 200 ml, 500 ml, 1 Ltr, 5 Ltr, 20 Ltr

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 50, 'https://www.makankidukan.com/uploads/products/1749117945_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1749117945_0.jpg','https://www.makankidukan.com/uploads/products/1749117945_1.jpg'], '{"Brand":"Astral","Category":"Solvent Cement & Adhesives","Material/Composition":"CPVC or PVC resins, solvents (MEK, THF), stabilizers","Key Property":"High Bond Strength","Curing":"Fast Curing","Temperature Resistance":"Formulated for extreme conditions","Pressure Resistance":"Suitable for high-pressure systems","Safety":"Safe & Non-toxic, low-VOC options","Stock Status":"In Stock","Return Policy":"7 days","Available Sizes":"100 ml, 200 ml, 500 ml, 1 Ltr, 5 Ltr, 20 Ltr","MRP":"Rs. 50","Source":"https://www.makankidukan.com/building-product/astral-pipe-resi-shield-cpvc-pipes-fitting-ancillary-products"}'::jsonb, v_sub2, 100, true),
  ('Astral Bondset Fast Setting Drain Pro Pipes Fittings', 'This solvent cement product combines CPVC or PVC resins, solvents like MEK and THF, and stabilizers for pipe joining applications. Key features include strong, leak-proof joints with quick drying/curing times and formulation for temperature extremes. The product handles high-pressure systems and offers smooth, easy-flow formulations for cleaner and efficient application. It''s classified as low-VOC with eco-friendly options available.

Available sizes/variants: 50 GM, 100 GM

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 20, 'https://www.makankidukan.com/uploads/products/1749458730_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749458730_0.png'], '{"Brand":"Astral","Category":"Solvent Cement & Adhesives","Composition":"CPVC/PVC resins, solvents, stabilizers","Bond Type":"Solvent cement","Curing":"Fast","Pressure Rating":"High-pressure resistant","Toxicity":"Non-toxic, low-VOC","Return Policy":"7 days","Available Sizes":"50 GM, 100 GM","MRP":"Rs. 20","Source":"https://www.makankidukan.com/building-product/astral-bondset-fast-setting-drain-pro-pipes-fittings"}'::jsonb, v_sub2, 100, true),
  ('Astral Rescue Tape Drain Pro Pipes Fittings', 'Rescue tape featuring high bond strength, fast curing, temperature resistance, easy application, and safety. Composition of CPVC or PVC resins, solvents like MEK and THF, and stabilizers, providing strong, durable joints that become virtually leak-proof, with quick drying/curing times, formulated for high/low temperature resilience, designed to withstand high-pressure systems, offering smooth, easy-flow formulations for cleaner application, and low-VOC/eco-friendly options available.

Available sizes/variants: 5 ft, 10 ft, 15 ft

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 150, 'https://www.makankidukan.com/uploads/products/1749459218_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1749459218_0.png'], '{"Brand":"Astral","Category":"Solvent Cement & Adhesives","Composition":"CPVC or PVC resins, solvents like MEK and THF, and stabilizers","Bond Strength":"Provide strong, durable joints that become virtually leak-proof","Curing":"Quick drying/curing times, speeding up installation","Temperature":"Specially formulated for high/low temperature resilience","Pressure Rating":"Designed to withstand high-pressure systems","Application":"Smooth, easy-flow formulations for cleaner application","Safety":"Low-VOC and eco-friendly options available","Return Policy":"7 days","Available Sizes":"5 ft, 10 ft, 15 ft","MRP":"Rs. 150","Source":"https://www.makankidukan.com/building-product/astral-rescue-tape-drain-pro-pipes-fittings"}'::jsonb, v_sub2, 100, true),
  ('Astral Pipe Joint Lubricant Drain Pro Pipes Fittings', 'Solvent cements and lubricants that provide strong, durable joints that become virtually leak-proof with quick drying capabilities, offering temperature and pressure resistance designed for demanding piping systems. The formulation includes combinations of CPVC or PVC resins, solvents like MEK (Methyl Ethyl Ketone), THF (Tetrahydrofuran), and stabilizers along with primers, lubricants, and thread sealants, engineered for enhanced overall performance, longevity, and ease of installation, meeting domestic and industrial standards. The lubricants are non-toxic, petroleum-based or synthetic greases safe for potable water.

Available sizes/variants: 100 GM, 200 GM, 500 GM

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 25, 'https://www.makankidukan.com/uploads/products/1749458511_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749458511_0.webp'], '{"Brand":"Astral","Category":"Solvent Cement & Adhesives","Features":"High bond strength, fast curing, temperature resistance, easy application, safe & non-toxic","Composition":"CPVC or PVC resins, MEK, THF, stabilizers","Available Sizes":"100 GM, 200 GM, 500 GM","MRP":"Rs. 25","Source":"https://www.makankidukan.com/building-product/astral-pipe-joint-lubricant-drain-pro-pipes-fittings"}'::jsonb, v_sub2, 100, true),
  ('Astral Pipe Tank Adapter (thd*thd)', 'Made from Chlorinated Polyvinyl Chloride (CPVC), this fitting suits residential, commercial, and industrial applications. It handles water up to 93°C continuously, resists corrosion from acids/bases/salts, features a smooth inner surface reducing friction, and offers high impact strength. The product is UV stabilized, precisely manufactured with tight tolerances, and uses solvent-cement joining for easy installation.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 77, 'https://www.makankidukan.com/uploads/products/1748860228_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748860228_0.webp'], '{"Brand":"Astral","Category":"Water Tanks","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Connection Type":"THD*THD (threaded connections)","Key Features":"High-temperature resistance, corrosion resistance, smooth inner surface, high impact strength, UV stabilized, fire resistance, lightweight construction","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 77","Source":"https://www.makankidukan.com/building-product/astral-pipe-tank-adapter-thdthd-cpvc-pipes-fitting"}'::jsonb, v_sub3, 100, true),
  ('Astral Pipe Tank Adaptor Socket Type Thd X Soc CPVC Pipes Fitting', 'This fitting is constructed from Chlorinated Polyvinyl Chloride and works for residential, commercial, and industrial applications. It manages water temperatures up to 93°C continuously and resists corrosion from acids, bases, and salts. The smooth interior minimizes friction for improved flow performance.

Available sizes/variants: 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 74, 'https://www.makankidukan.com/uploads/products/1749021161_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749021161_0.webp','https://www.makankidukan.com/uploads/products/1749021161_1.webp'], '{"Brand":"Astral","Category":"Water Tanks","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Temperature Rating":"Up to 93°C (200°F) continuous","Available Sizes":"0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"UV stabilized, high impact strength, lightweight, solvent-cement joining","MRP":"Rs. 74","Source":"https://www.makankidukan.com/building-product/astral-pipe-tank-adaptor-socket-type-thd-x-soc-cpvc-pipes-fitting"}'::jsonb, v_sub3, 100, true),
  ('Astral Pipe Tank Adaptor Socket Type Thd X Spg CPVC Pipes Fitting', 'CPVC material fittings suitable for residential, commercial, and industrial applications. Capable of handling water up to 93°C continuously. Features corrosion resistance to acids, bases, salts, and oxidants with a smooth internal surface minimizing friction. Demonstrates high impact strength under pressure and includes UV stabilization. Manufactured with tight dimensional tolerances using solvent-cement joining methods. Typically manufactured as per ASTM D2846, ASTM F441, and IS 15778 standards.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 75, 'https://www.makankidukan.com/uploads/products/1749021499_0.avif', ARRAY['https://www.makankidukan.com/uploads/products/1749021499_0.avif'], '{"Brand":"Astral","Category":"Water Tanks","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Rating":"Up to 93°C (200°F)","Features":"High impact strength, UV stabilized, corrosion resistant, smooth inner surface, easy installation","Standards":"ASTM D2846, ASTM F441, IS 15778","Available Sizes":"0.5 inch, 0.75 inch, 1 inch, 1.25 inch, 1.5 inch, 2 inch","MRP":"Rs. 75","Source":"https://www.makankidukan.com/building-product/astral-pipe-tank-adaptor-socket-type-thd-x-spg-cpvc-pipes-fitting"}'::jsonb, v_sub3, 100, true),
  ('Astral Tank Adaptor Long Thd X Spg CPVC Schedule - 80', 'CPVC tank adaptor (long threaded x socket) featuring high temperature resistance, pressure endurance, and corrosion resistance. Its smooth inner surface reduces friction for improved flow. Additional benefits include fire resistance, extended durability, and straightforward installation via solvent-cement joining.

Available sizes/variants: 2.5 inch, 3 inch, 4 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1775, 'https://www.makankidukan.com/uploads/products/1749103620_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1749103620_0.webp'], '{"Brand":"Astral","Category":"Water Tanks","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Tank Adaptor (Long Threaded x Socket)","Schedule":"Schedule 80","Temperature Resistance":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"Corrosion resistant, smooth inner surface, high impact strength, UV stabilized","Available Sizes":"2.5 inch, 3 inch, 4 inch","MRP":"Rs. 1775","Source":"https://www.makankidukan.com/building-product/astral-pipe-tank-adaptor-long-thd-x-spg-cpvc-schedule-80-pipes-fitting"}'::jsonb, v_sub3, 100, true),
  ('Astral Pio Water Tank 3 Layer', 'Astral PIO Water Tanks are multi-layered, rotational-moulded polyethylene water tanks designed for safe, hygienic, and durable water storage. The acronym PIO stands for Pure Inside Out, emphasizing purity and strength. These tanks handle harsh Indian weather and come in capacities from 500L to 5000L.

Available sizes/variants: 500L, 750L, 1000L, 1500L, 2000L, 3000L, 5000L

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 5100, 'https://www.makankidukan.com/uploads/products/1747724019_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1747724019_0.png'], '{"Brand":"Astral","Category":"Water Tanks","Material":"LLDPE (Linear Low-Density Polyethylene)","Material Grade":"100% Virgin Food-Grade","Construction":"Rotational-molded","UV Protection":"Yes, with dedicated layer","Heat Reflection":"Yes, maintains water temperature","Certification":"ISI Marked & Certified","Odor Profile":"Odor-free","Leak Design":"Leak-proof, seamless","Maintenance":"Low maintenance","Available Sizes":"500L, 750L, 1000L, 1500L, 2000L, 3000L, 5000L","MRP":"Rs. 5100","Source":"https://www.makankidukan.com/building-product/astral-pio-water-tank-3-layer"}'::jsonb, v_sub3, 100, true),
  ('Astral Vito Water Tank 3 Layer', 'This rotational-molded water tank utilizes 100% virgin, food-grade LLDPE material for safe potable water storage. It incorporates multiple protective layers and is engineered to withstand Indian climate conditions, particularly heat and UV exposure.

Available sizes/variants: 500 Ltr, 750 Ltr, 1000 Ltr, 1500 Ltr, 2000 Ltr, 3000 Ltr, 5000 Ltr

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 5570, 'https://www.makankidukan.com/uploads/products/1747724940_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1747724940_0.jpg','https://www.makankidukan.com/uploads/products/1747724940_1.png','https://www.makankidukan.com/uploads/products/1747724940_2.jpg','https://www.makankidukan.com/uploads/products/1747724940_3.webp','https://www.makankidukan.com/uploads/products/1747724940_4.jpg'], '{"Brand":"Astral","Category":"Water Tanks","Material":"100% Virgin LLDPE (Linear Low-Density Polyethylene)","Safety":"Non-toxic, BPA-free","Outer Layer":"UV-stabilized for sun protection","Inner Surface":"Smooth, prevents scaling","Construction":"Leak-proof seamless body via rotational molding","Applications":"Domestic, commercial, agricultural, industrial use","Return Policy":"7 days","Available Sizes":"500 Ltr, 750 Ltr, 1000 Ltr, 1500 Ltr, 2000 Ltr, 3000 Ltr, 5000 Ltr","MRP":"Rs. 5570","Source":"https://www.makankidukan.com/building-product/astral-vito-water-tank-3-layer"}'::jsonb, v_sub3, 100, true),
  ('Astral Concealed Valve Chrome Plated (triangle)', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The product features high-temperature resistance up to 93°C, corrosion resistance, smooth inner surface for improved flow, high impact strength, UV stabilization, and easy solvent-cement joining.

Available sizes/variants: 0.5", 0.75", 1"

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1132, 'https://www.makankidukan.com/uploads/products/1748932774_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748932774_0.jpg'], '{"Brand":"Astral Pipes","Category":"Sanitary & Other","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Type":"Concealed Valve (Chrome Plated Triangle)","Color":"Chrome Plated","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Surface":"Smooth inner surface","Impact Strength":"High","UV Treatment":"UV Stabilized","Available Sizes":"0.5\", 0.75\", 1\"","MRP":"Rs. 1132","Source":"https://www.makankidukan.com/building-product/astral-pipe-concealed-valve-chrome-platedtriangle-cpvc-pipes-fitting"}'::jsonb, v_sub4, 100, true),
  ('Astral Concealed Valve Chrome Plated (square)', 'Manufactured from Chlorinated Polyvinyl Chloride (CPVC) material suitable for residential, commercial, and industrial applications. It can manage water temperatures up to 93°C continuously and resists most acids, bases, salts, and oxidants. The valve features a smooth inner surface that reduces friction and pressure drops, maintains high impact strength under pressure, and includes UV stabilization for both indoor and limited outdoor use. Manufacturing employs tight dimensional tolerances and incorporates UV stabilizers and impact modifiers for enhanced performance.

Available sizes/variants: 0.5", 0.75", 1"

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1178, 'https://www.makankidukan.com/uploads/products/1748933016_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748933016_0.jpg'], '{"Brand":"Astral Pipes","Category":"Sanitary & Other","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Type":"Concealed Valve","Finish":"Chrome Plated","Shape":"Square","Temperature Resistance":"Up to 93°C (200°F)","Corrosion Resistance":"Yes","Standards":"ASTM D2846, ASTM F441, IS 15778","Color":"Chrome (plated)","Available Sizes":"0.5\", 0.75\", 1\"","MRP":"Rs. 1178","Source":"https://www.makankidukan.com/building-product/astral-pipe-concealed-valve-chrome-platedsquare-cpvc-pipes-fitting"}'::jsonb, v_sub4, 100, true),
  ('Astral Concealed Valve Swept Type Chrome Plated (square) Long', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The product handles hot water up to 93°C continuously and resists corrosion from acids, bases, and salts. Features include smooth inner surfaces reducing friction, high impact strength, UV stabilization, and lightweight construction enabling simple solvent-cement joining.

Available sizes/variants: 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1400, 'https://www.makankidukan.com/uploads/products/1748933783_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748933783_0.webp'], '{"Brand":"Astral Pipes","Category":"Sanitary & Other","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Type":"Concealed Valve Swept (Chrome Plated, Square)","Color":"Chrome Plated","Temperature Rating":"Up to 93°C (200°F) continuous","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"High-temperature resistant, corrosion resistant, fire resistant, UV stabilized, easy installation","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 1400","Source":"https://www.makankidukan.com/building-product/astral-pipe-concealed-valve-swept-type-chrome-platedsquare-long-cpvc-pipes-fitting"}'::jsonb, v_sub4, 100, true),
  ('Astral Concealed Valve Swept Type Chrome Plated (square) Short', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, ideal for residential, commercial, and industrial applications. High temperature and pressure endurance, corrosion and fire resistant, smooth inner surface reduces friction and pressure drops, high impact strength, easy solvent-cement installation, lightweight.

Available sizes/variants: 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1180, 'https://www.makankidukan.com/uploads/products/1748933962_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748933962_0.webp'], '{"Brand":"Astral Pipes","Category":"Sanitary & Other","Material":"Chlorinated Polyvinyl Chloride (CPVC)","Temperature Resistance":"Up to 93°C (200°F) continuously","Corrosion Resistance":"Resistant to acids, bases, salts, oxidants","Standards":"ASTM D2846, ASTM F441, IS 15778","Finish":"Chrome Plated","Design Type":"Concealed Valve Swept, Square","UV Stabilized":"Yes (indoor and limited outdoor use)","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 1180","Source":"https://www.makankidukan.com/building-product/astral-pipe-concealed-valve-swept-type-chrome-platedsquare-short-cpvc-pipes-fitting"}'::jsonb, v_sub4, 100, true),
  ('Astral Concealed Valve Chrome Plate (flower)', 'Made using Chlorinated Polyvinyl Chloride (CPVC) material, these fittings are ideal for residential, commercial, and industrial applications. The valve features high-temperature resistance handling water up to 93°C, corrosion resistance, smooth inner surface for reduced friction, and easy installation with solvent-cement joining.

Available sizes/variants: 0.5 inch, 0.75 inch, 1 inch

Why choose Astral:
- Trusted, ISI/ASTM-compliant piping brand used across India
- Corrosion, chemical and UV resistant construction
- Smooth bore for efficient flow and low friction loss
- Easy installation with leak-proof jointing
- Long service life with minimal maintenance', 1178, 'https://www.makankidukan.com/uploads/products/1748934914_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748934914_0.webp'], '{"Brand":"Astral Pipes","Category":"Sanitary & Other","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Color":"Chrome Plate","Temperature Rating":"Up to 93°C (200°F) continuously","Standards":"ASTM D2846, ASTM F441, IS 15778","Key Features":"UV stabilized, high impact strength, precise manufacturing","Available Sizes":"0.5 inch, 0.75 inch, 1 inch","MRP":"Rs. 1178","Source":"https://www.makankidukan.com/building-product/astral-pipe-concealed-valve-chrome-plateflower-cpvc-pipes-fitting"}'::jsonb, v_sub4, 100, true);
END $$;
