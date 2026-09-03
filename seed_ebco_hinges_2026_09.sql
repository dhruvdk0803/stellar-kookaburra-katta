-- Ebco Hinges (SeptemberBatch2) - from owner-provided CSV + product photos.
-- 28 products inserted: 9 single-price (variants NULL, no selector) and 19 with variant selectors.
-- 69 variant prices in the source; the product price is the cheapest variant.
-- 55 images in /public/images/ebco/hinges/ - deploy with the frontend.
-- Safe to re-run: rows are tagged with Source='ebco-hinges-septemberbatch2'
-- and deleted before re-insert.

ALTER TABLE products ADD COLUMN IF NOT EXISTS variants JSONB DEFAULT '[]'::jsonb;

DO $$
DECLARE
  v_parent UUID;
  v_ebco UUID;
BEGIN
  SELECT id INTO v_parent FROM categories WHERE slug='ebco' OR lower(name)='ebco' LIMIT 1;
  IF v_parent IS NULL THEN
    INSERT INTO categories (name, slug) VALUES ('Ebco','ebco') RETURNING id INTO v_parent;
  END IF;
  SELECT id INTO v_ebco FROM categories WHERE parent_id=v_parent AND name='Hinges' LIMIT 1;
  IF v_ebco IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('Hinges', 'ebco-hinges', v_parent) RETURNING id INTO v_ebco;
  END IF;

  -- Remove rows from any earlier run of this script, then re-insert.
  DELETE FROM products WHERE specs->>'Source' = 'ebco-hinges-septemberbatch2';

  INSERT INTO products (name, description, price, image_url, images, specs, variants, category_id, stock, is_active) VALUES
  ('Short Arm Hinge with 4 Hole Mounting Plate (A) 0 crank', 'Available in Full Overlay.
Can be used in Aluminium Framed Cabinets.
Max. Opening : 100°.
Max. Shutter size: 34" x 22" (850mm x 550mm) for 2 Hinges.
Shutter Thickness: 16mm to 19mm.
Shutter cavity: Ø35mm,12 deep, cavity 4mm from edge.', 396, '/images/ebco/hinges/ebco-hinge-1a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-1a.jpg', '/images/ebco/hinges/ebco-hinge-1b.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "Item Code": "HSA1A-M1", "Finish": "Nickel Plated", "Item": "Short Arm Hinge with 4 Hole Mounting Plate", "Size (mm)": "ø 35 mm", "Caution": "For efficiency and durability : - To avoid damage to hinge, Do not force the door to exceed 100°. - Do not apply paint or polish. - Hinges must be parallel. - The hinges must not be hammered.", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, NULL, v_ebco, 100, true),
  ('Hinge Slow-Motion ''S'' Click On (A)', 'Unique built in damping system allows the shutter to close in slow motion without banging.
Available in Full overlay, Half overlay & Inset.
Max. opening : 105°.
Max. Shutter size: 34" x 22" (850mm x 550mm) for 2 hinges.
Shutter Thickness: 16mm to 19mm.
Shutter Cavity: Ø35mm, 12mm deep, cavity 4mm from edge.', 225, '/images/ebco/hinges/ebco-hinge-2a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-2a.jpg', '/images/ebco/hinges/ebco-hinge-2b.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "Item Code": "HSMS1A", "Finish": "Nickel Plated", "Item": "Hinge Slow-Motion ''S'' Click On (Overlay, Half-Overlay, Inset)", "Caution": "For Efficiency and durability : - To avoid damage to hinge, Do not force the door to exceed 105°. - Do not apply paint or polish. - Hinges must be parallel. - The hinge must not be hammered", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "0 crank", "price": 225, "is_default": true}, {"label": "8 crank", "price": 228, "is_default": false}, {"label": "16 crank", "price": 240, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Slip On Hinge - Euro (A)', 'Available in Full Overlay, Half Overlay & Inset.
Max. opening: 105°.
Max. Shutter size: 34" x 22" (850mm x 550mm) for 2 hinges.
Shutter Thickness: 16mm to 19mm.
Shutter Cavity: Ø35mm,12 deep, cavity 4mm from edge.', 100, '/images/ebco/hinges/ebco-hinge-3a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-3a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "Item Code": "E-HS1A", "Finish": "Nickel Plated", "Item": "Slip on Hinge - Euro - Overlay, Half Overlay & Inset", "Size (mm)": "Ø 35 mm", "Caution": "For efficiency and durability: - To avoid damage to hinge, Do not force the door to exceed 105°. - Do not apply paint or polish. - Hinges must be parallel. - The hinges must not be hammered.", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "0 crank", "price": 100, "is_default": true}, {"label": "8 crank", "price": 110, "is_default": false}, {"label": "16 crank", "price": 120, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Plano Hinge', 'Ideal for downward opening flaps, with horizontal & vertical adjustments for precise alignments
Applicable for lid stay, flap stay & many more
Cut-out dimensions: ø35mm, depth 12mm
Max opening angle 90° with full overlay
Die cast body for strength', 492, '/images/ebco/hinges/ebco-hinge-4a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-4a.jpg', '/images/ebco/hinges/ebco-hinge-4b.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "Item Code": "PH-40", "Finish": "Nickel Plated", "Item": "Plano Hinge", "Size": "40mm", "Caution": "Do not chisel. - Hinges must not be hammered.", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, NULL, v_ebco, 100, true),
  ('Recessed Hinge 35 - Soft Close', 'For shutter up to (H)3000 x (W)650mm, thickness: 26 to 40mm
Load up to 35Kg
For Wood & Aluminium profile shutters, with 3D adjustment and opening angle up to 105°', 8450, '/images/ebco/hinges/ebco-hinge-5a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-5a.jpg', '/images/ebco/hinges/ebco-hinge-5b.jpg', '/images/ebco/hinges/ebco-hinge-5c.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "Demo Video": "https://youtu.be/br7AWF-Hi9s", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "Left", "price": 8450, "is_default": true}, {"label": "Right", "price": 8450, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Hinge for Aluminium Profile 3D - With Linear Mounting Plate', 'Specially designed hinge with linear mounting plate for the Glass shutter Al. profiles.
Available in Overlay & Half Overlay
Hinge opening angle: 105°
Glass THK: 4mm
Finish:
Hinge: Nickel Plated, Titanium', 600, '/images/ebco/hinges/ebco-hinge-6a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-6a.jpg', '/images/ebco/hinges/ebco-hinge-6b.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "0 crank", "price": 600, "is_default": true}, {"label": "8 crank", "price": 600, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Hinge For Aluminium Profile 3D', 'Specially designed for Al. Profile Shutter
Available in Overlay & Half Overlay', 580, '/images/ebco/hinges/ebco-hinge-7a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-7a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "Demo Video": "https://youtu.be/7JPGj4W6GKI", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "0 crank", "price": 580, "is_default": true}, {"label": "8 crank", "price": 580, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Blind corner Hinge- 3D-Soft close', '3D Adjustment
Max. opening: 90°
In-built soft close mechanism prevents shutter from banging
Max. shutter size: 850mm X 550mm
Shutter thickness: 16mm – 19mm
Finish: Nickel Plated', 410, '/images/ebco/hinges/ebco-hinge-8a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-8a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, NULL, v_ebco, 100, true),
  ('Click on Hinge (I)- 4 Hole Mounting Plate', 'Click on hinge full overlay, half overlay & inset with 4 hole mounting plate
Unique Click on System enables easy installation of the shutter.
Max. Shutter size: 34" x 22"(850mm x 550mm) for 2 hinges.
Max. Opening: 105°.
Shutter Thickness: 16mm to 19mm.', 160, '/images/ebco/hinges/ebco-hinge-9a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-9a.jpg', '/images/ebco/hinges/ebco-hinge-9b.jpeg', '/images/ebco/hinges/ebco-hinge-9c.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "0 crank", "price": 160, "is_default": true}, {"label": "8 crank", "price": 165, "is_default": false}, {"label": "16 crank", "price": 170, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Recessed Hinge 25 - Soft Close', 'Recessed hinge for Wooden and Al. frame doors.
3D adjustment
105° opening angle
Max. recommended shutter size with 2 hinges: Width≤600mm, Height≤2100mm
Max. recommended shutter weight to use with 2 hinge ≤25kg
Shutter thickness: 16-30mm
Max cabinet side panel thickness: 25mm
50000 Cycle tested', 5450, '/images/ebco/hinges/ebco-hinge-10a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-10a.jpg', '/images/ebco/hinges/ebco-hinge-10b.jpg', '/images/ebco/hinges/ebco-hinge-10c.jpg', '/images/ebco/hinges/ebco-hinge-10d.jpg', '/images/ebco/hinges/ebco-hinge-10e.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "Demo Video": "https://youtu.be/br7AWF-Hi9s", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "Left", "price": 5450, "is_default": true}, {"label": "Right", "price": 5450, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Thick Door Hinge 15-35mm with 3D mounting plate', 'Now with 3D adjustable mounting plate
Specially designed hinge for shutter thickness of 15-35mm
Max opening: 95°
For cabinet side panel thickness: 17-22mm
Available for Overlay & Half-overlay door applications
Shutter cavity: ø35mm, 11.5mm deep
Available in Nickel Plated', 394, '/images/ebco/hinges/ebco-hinge-11a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-11a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "0 crank", "price": 394, "is_default": true}, {"label": "8 crank", "price": 394, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Shower Hinges', 'Premium Ebco shower hinges for frameless glass shower doors and enclosures.
Available in wall-to-glass (T Type and L Type) and glass-to-glass mounting configurations, with 90°, 135° and 180° opening angles.
Choice of brushed steel or polished steel finish (see variants for pricing).
Corrosion-resistant construction for bathroom use. Fitting instructions available on request.', 1968, '/images/ebco/hinges/ebco-hinge-12a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-12a.jpg', '/images/ebco/hinges/ebco-hinge-12b.jpg', '/images/ebco/hinges/ebco-hinge-12c.jpg', '/images/ebco/hinges/ebco-hinge-12d.jpg', '/images/ebco/hinges/ebco-hinge-12e.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "Shower Hinge 90° Wall to Glass - T Type Brushed Steel", "price": 1968, "is_default": true}, {"label": "Shower Hinge 90° Wall to Glass - L Type Brushed Steel", "price": 2142, "is_default": false}, {"label": "Shower Hinge 90° Wall to Glass - T Type Polished Steel", "price": 2165, "is_default": false}, {"label": "Shower Hinge 90° Wall to Glass - L Type Polished Steel", "price": 2174, "is_default": false}, {"label": "Shower Hinge 135° Glass to Glass Brushed Steel", "price": 2620, "is_default": false}, {"label": "Shower Hinge 180° Glass to Glass Brushed Steel", "price": 2620, "is_default": false}, {"label": "Shower Hinge 135° Glass to Glass Polished Steel", "price": 2932, "is_default": false}, {"label": "Shower Hinge 90° Glass to Glass Brushed Steel", "price": 2986, "is_default": false}, {"label": "Shower Hinge 180° Glass to Glass Polished Steel", "price": 3048, "is_default": false}, {"label": "Shower Hinge 90° Glass to Glass Polished Steel", "price": 3195, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Concealed Hinge - 3D', 'For flush wooden door application.
3D dimensional adjustment after installation.
Max Door Weight with 2 hinges - 40 Kgs, 80 Kgs and 120 Kgs
Min door thickness - 35 mm, 40 mm and 45 mm
Max door width - 850 mm, 1000 mm and 1400 mm
Max opening - 180°', 3778, '/images/ebco/hinges/ebco-hinge-13a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-13a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "(For minimum Door thickness 35 mm)", "price": 3778, "is_default": true}, {"label": "(For minimum Door thickness 40 mm)", "price": 4557, "is_default": false}, {"label": "(For minimum Door thickness 45 mm)", "price": 7624, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Concealed Corner Hinge', 'SS 304', 532, '/images/ebco/hinges/ebco-hinge-14a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-14a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "Demo Video": "https://youtu.be/Lg261nrgikc", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "side Hung - 80 (with New Bevelled Groove)", "price": 532, "is_default": true}, {"label": "side Hung - 120 (with New Bevelled Groove)", "price": 696, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Thick Door Hinge - Soft Close', 'Available in Full Overlay, Half Overlay & Inset
Soft Close mechanism prevents shutters from banging.
Max. Opening : 95°
Max. Shutter Size: 34" x 22" (850mm x 550mm) for 2 hinges.
Shutter Thickness: 18mm to 30mm.
Shutter Cavity: Ø40mm, 14 deep', 395, '/images/ebco/hinges/ebco-hinge-15a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-15a.jpg', '/images/ebco/hinges/ebco-hinge-15b.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "Caution": "For efficiency and durability. - To avoid damage to hinge, do not force the door to exceed 95°. - Do not apply paint or polish. - Hinges must be parallel. - The hinges must not be hammered.", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "0 crank- gun metal finish", "price": 424, "is_default": true}, {"label": "0 crank- nickel plated", "price": 395, "is_default": false}, {"label": "8 crank- gun metal finish", "price": 424, "is_default": false}, {"label": "8 crank- nickel plated", "price": 395, "is_default": false}, {"label": "16 crank- gun metal finish", "price": 424, "is_default": false}, {"label": "16 crank- nickel plated", "price": 395, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Thick Door Hinge 15-35mm Soft Close With 3D Mounting Plate', '3D adjustments
Specially designed hinge for shutter thickness of 15-35mm
Max. opening: 95°
For cabinet side panel thickness: 17-22mm
Available for Overlay & Half-overlay door applications.
Soft-closing mechanism allows gentle closing of the cabinet door.
Shutter cavity:Ø35mm, 11.5mm deep', 394, '/images/ebco/hinges/ebco-hinge-16a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-16a.jpg', '/images/ebco/hinges/ebco-hinge-16b.jpg', '/images/ebco/hinges/ebco-hinge-16c.jpg', '/images/ebco/hinges/ebco-hinge-16d.jpg', '/images/ebco/hinges/ebco-hinge-16e.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "0 crank- gun metal finish", "price": 422, "is_default": true}, {"label": "0 crank- nickel plated", "price": 394, "is_default": false}, {"label": "8 crank- gun metal finish", "price": 422, "is_default": false}, {"label": "8 crank- nickel plated", "price": 394, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('155° Hinge - Zero Protrusion (Soft Close)', '155° ZERO PROTRUSION hinge ensures clear/ non-obstruct opening of the cabinet door.
Specially designed for the cabinets that house drawers.
Available for Overlay & Half-overlay door applications.
Max. opening: 155°
Soft-closing mechanism allows gentle closing of the cabinet door.
Shutter cavity: Ø35mm, 11.5mm deep
Shutter thickness: 14-24mm
Cabinet side panel thickness: 17-21mm
Finish: Nickel plated', 835, '/images/ebco/hinges/ebco-hinge-17a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-17a.jpg', '/images/ebco/hinges/ebco-hinge-17b.jpg', '/images/ebco/hinges/ebco-hinge-17c.jpg', '/images/ebco/hinges/ebco-hinge-17d.jpg', '/images/ebco/hinges/ebco-hinge-17e.png'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "0 crank- gun metal finish", "price": 893, "is_default": true}, {"label": "0 crank- nickel plated", "price": 835, "is_default": false}, {"label": "8 crank- gun metal finish", "price": 893, "is_default": false}, {"label": "8 crank- nickel plated", "price": 835, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Glass Hinge - Inset (16 crank)', 'Max shutter size: 800 mm x 350 mm.
Glass shutter thickness: 4 to 6 mm
No cavity required.
Built in catch for flush fitting glass shutters.', 330, '/images/ebco/hinges/ebco-hinge-18a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-18a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, NULL, v_ebco, 100, true),
  ('Pivot Hinge - 16 crank', 'Designed for Inset Windows.
Made of AISI 304 Stainless Steel.
Can be used in Wood, Aluminium & Plastic windows.
Easy to Fit.
Finish : Raw Stainless Steel.', 148, '/images/ebco/hinges/ebco-hinge-19a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-19a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, NULL, v_ebco, 100, true),
  ('Cabinet Hinge', 'Designed for Overlay Shutters.
180° Opening angle.
Horizontal and Vertical Adjustments provided.
System ''32'' Compatible.
Easy to Fit.', 80, '/images/ebco/hinges/ebco-hinge-20a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-20a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "Anthracite", "price": 80, "is_default": true}, {"label": "White Matt", "price": 80, "is_default": false}, {"label": "Silver", "price": 80, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Inline Hinge', 'Ideal for folding shutters.
Spring loaded with adjustment.
Die cast and powder coated.
Used in walk in closets.
Finish: Black', 363, '/images/ebco/hinges/ebco-hinge-21a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-21a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "Finish": "Black", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, NULL, v_ebco, 100, true),
  ('Spring Loaded Hinge', 'Built in spring that acts as a catch to keep shutters closed
Available with 180° opening
No cavity required', 85, '/images/ebco/hinges/ebco-hinge-22a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-22a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "Black", "price": 85, "is_default": true}, {"label": "Brown", "price": 85, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Cranked Hinge', 'Partly visible and extremely easy to fit on modular and CKD Cabinets.
Built in spring catch with 180° max. opening angle.
Available in different finishes.', 78, '/images/ebco/hinges/ebco-hinge-23a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-23a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "Black", "price": 78, "is_default": true}, {"label": "Brown", "price": 78, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('165° Hinge (I)', 'Heavy duty cupboard hinges.
Spring loaded with ''Auto-Closing'' feature.
165° opening angle.
Max shutter size 2135mm x 600mm (85" x 24") for 2 hinges.
Shutter thickness:16mm to 26mm.
Adjustments for gap and pivot angle.
System 32'' compatible.
Available in 2 models - Overlay & Half Overlay.
Shutter Cavity: Ø35mm, 12mm deep, 4mm from edge.
Finish: Nickel plated.', 535, '/images/ebco/hinges/ebco-hinge-24a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-24a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "Caution": "For efficiency and durability. - To avoid damage to hinge, do not force door to exceed 165°. - Hinges must be parallel. - Do not apply paint or polish - The hinges must not be hammered.", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "0 crank", "price": 535, "is_default": true}, {"label": "8 crank", "price": 535, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Blind Corner Hinge - Euro', 'Designed for cabinets having blind corner panel.
Max opening: 105°
Max shutter size: 850mm X 550mm (34" X 22") for 2 hinges.
Shutter thickness 16mm to 19mm.
3 way adjustment with system 32 compatibility.
Finish - Nickel Plated.', 345, '/images/ebco/hinges/ebco-hinge-25a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-25a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "Caution": "For efficiency and durability. - To avoid damage to hinge, do not force the door to exceed 105°. - Do not apply paint or polish. - Hinges must be parallel. - The hinges must not be hammered.", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, NULL, v_ebco, 100, true),
  ('Pivot Hinge with Spring', 'Ideal for Steel Cabinet.
Spring loaded latch mechanism for long lasting uses.
Easy to use.', 40, '/images/ebco/hinges/ebco-hinge-26a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-26a.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, NULL, v_ebco, 100, true),
  ('Pivot Glass Hinge 8mm', 'Specially designed hinge for small cabinets with glass doors.
Compatible for glass thickness from 6mm to 10mm
Made of SS304
Min cabinet top & base panel thickness: 18mm', 515, '/images/ebco/hinges/ebco-hinge-27a.jpg', ARRAY['/images/ebco/hinges/ebco-hinge-27a.jpg', '/images/ebco/hinges/ebco-hinge-27b.jpg', '/images/ebco/hinges/ebco-hinge-27c.jpg'], '{"Brand": "Ebco", "Category": "Hinges", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, NULL, v_ebco, 100, true),
  ('Hinge Push Open (with magnetic push open fittings)', 'This new hinge with special reverse spring enables automatic opening of door by exerting small amount of pressure to the door.
Available in Full Overlay, Half Overlay and Inset.
For shutter thickness of 16mm to 19mm.', 211, '/images/ebco/hinges/ebco-hinge-28a.png', ARRAY['/images/ebco/hinges/ebco-hinge-28a.png'], '{"Brand": "Ebco", "Category": "Hinges", "Caution": "For efficiency and durability - To avoid damage to hinge, do not force the door to exceed 105° - Do not apply paint or polish - Hinges must be parallel - The hinge must not be hammered", "GST": "18%", "Source": "ebco-hinges-septemberbatch2"}'::jsonb, '[{"label": "0 crank", "price": 211, "is_default": true}, {"label": "8 crank", "price": 211, "is_default": false}, {"label": "16 crank", "price": 211, "is_default": false}]'::jsonb, v_ebco, 100, true);
END $$;
