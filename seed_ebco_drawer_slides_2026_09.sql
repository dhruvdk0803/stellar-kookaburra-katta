-- Ebco Drawer Slides (6 September 2026) - from owner-provided CSV + product photos.
-- 17 products inserted: 14 drawer slides with size variants (80 size+price pairs,
-- product price = cheapest size) and 3 single-price accessories promoted from
-- sheet sub-items (Stabilizer Bar 900mm, Kitchen Basket 500mm, Undermount Slide
-- 450mm - no photos in the source, so image_url is NULL / images empty and the
-- site shows its placeholder).
-- P12 'Concealed Drawer Slide Slim - 2 Push Open': the unpriced 550mm size is
-- dropped per owner decision - only the 5 priced sizes (300-500mm) ship.
-- 22 images in /public/images/ebco/drawer-slides/ - deploy with the frontend.
-- Safe to re-run: rows are tagged with specs.Source='ebco-drawer-slides-6-september-2026'
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
  SELECT id INTO v_ebco FROM categories WHERE parent_id=v_parent
    AND (name='Drawer Slides' OR slug='ebco-drawer-slides') LIMIT 1;
  IF v_ebco IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('Drawer Slides', 'ebco-drawer-slides', v_parent) RETURNING id INTO v_ebco;
  END IF;

  -- Remove rows from any earlier run of this script, then re-insert.
  DELETE FROM products WHERE specs->>'Source' = 'ebco-drawer-slides-6-september-2026';

  INSERT INTO products (name, description, price, image_url, images, specs, variants, category_id, stock, is_active) VALUES
  ('Ebco Heavy Duty Drawer Slides - 90Kg', 'Full extension of drawer available.
Direct front installation.
Precision ball bearing for smooth movement.
Hole ''System - 32'' compatible.
Load capacity 90 Kgs.
Removable drawer with Latch.', 1687, '/images/ebco/drawer-slides/ebco-drawer-slide-1a.jpg', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-1a.jpg'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "Heavy Duty Drawer Slides - 90Kg", "Max. Load Capacity": "90 Kg", "Gap per Side (mm)": "16.6", "Finish": "Zinc White", "Caution": "For efficiency and durability: - Strictly maintain 16.6mm side gap. - Fit slides parallel and at equal heights. - Do not apply paint or polish. - Do not let saw dust enter into the slides.", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "450 mm", "price": 1687, "is_default": true}, {"label": "500 mm", "price": 1877, "is_default": false}, {"label": "600 mm", "price": 2249, "is_default": false}, {"label": "750 mm", "price": 2814, "is_default": false}, {"label": "900 mm", "price": 3377, "is_default": false}, {"label": "1050 mm", "price": 4177, "is_default": false}, {"label": "1200 mm", "price": 4765, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco Heavy Duty Drawer Slides - 125Kg', 'Full extension of drawer available.
Direct front installation.
Precision ball bearing for smooth movement.
Hole ''System-32'' compatible.
Load capacity - 125 kgs.
Removable drawer with Latch.', 1780, '/images/ebco/drawer-slides/ebco-drawer-slide-2a.jpeg', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-2a.jpeg', '/images/ebco/drawer-slides/ebco-drawer-slide-2b.jpg'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "Heavy Duty Drawer Slides - 125Kg", "Finish": "Zinc White", "Caution": "For efficiency and durability - Strictly maintain 16.6mm side gap. - Fit slides parallel and at equal heights. - Do not apply paint or polish. - Do not let saw dust enter into the slides.", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "450 mm", "price": 1780, "is_default": true}, {"label": "500 mm", "price": 1986, "is_default": false}, {"label": "550 mm", "price": 2196, "is_default": false}, {"label": "600 mm", "price": 2373, "is_default": false}, {"label": "750 mm", "price": 3009, "is_default": false}, {"label": "900 mm", "price": 3591, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco Premium Sleek Telescopic Drawer Slide 35kg - Soft Close', 'Ultra-smooth operation, precision ball bearings ensure effortless drawer movement.
A gentle push closes the drawer silently.
1,00,000 cycles tested.
10-year functional warranty
72 hours salt spray tested
Ideal for use in wood pedestals, dressers, desks, residential, & kitchen cabinetry.
Recommended to use Ebco U-clamp (KBCT1) to fit with Ebco kitchen baskets.', 958, '/images/ebco/drawer-slides/ebco-drawer-slide-3a.jpg', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-3a.jpg', '/images/ebco/drawer-slides/ebco-drawer-slide-3b.jpg'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "Premium Sleek Telescopic Drawer Slide (35 kg) Soft Close", "Finish": "Zinc White", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "300 mm", "price": 958, "is_default": true}, {"label": "350 mm", "price": 1008, "is_default": false}, {"label": "400 mm", "price": 1049, "is_default": false}, {"label": "450 mm", "price": 1140, "is_default": false}, {"label": "500 mm", "price": 1200, "is_default": false}, {"label": "550 mm", "price": 1236, "is_default": false}, {"label": "600 mm", "price": 1319, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco EcoGlide Concealed Drawer Slide (with Facia Bracket)', 'An undermount drawer slide with 1-D adjustment
Load Capacity : 35Kg
Length : 300-550mm
Height Adjustment : 0~+3mm', 917, '/images/ebco/drawer-slides/ebco-drawer-slide-4a.jpg', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-4a.jpg'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "EcoGlide Concealed Drawer Slide (with Facia Bracket)", "Finish": "Zinc White", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "300 mm", "price": 917, "is_default": true}, {"label": "350 mm", "price": 937, "is_default": false}, {"label": "400 mm", "price": 1039, "is_default": false}, {"label": "450 mm", "price": 1121, "is_default": false}, {"label": "500 mm", "price": 1203, "is_default": false}, {"label": "550 mm", "price": 1353, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco Sleek Telescopic Drawer Slide 35kg SS304', 'Manufactured out of stainless steel 304 grade.
Precision ball bearings ensure smooth movement.
Full extension of drawer.
Easy for installation
Load Capacity: 35 kgs.
Direct fitting from front
Removable drawer with latch
System 32 installation
72 hrs. salt spray test passed
BIS certified
50000 cycles tested', 1371, '/images/ebco/drawer-slides/ebco-drawer-slide-5a.webp', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-5a.webp', '/images/ebco/drawer-slides/ebco-drawer-slide-5b.webp'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "SS 304 - Sleek Telescopic Drawer Slides - 35Kg. (35 Kg, 45 mm Ht)", "Finish": "Stainless Steel", "Caution": "For efficiency and durability: - Strictly maintain 12.7 to 13.0mm side gap. - Fit slides parallel and at equal heights. - Do not apply paint or polish. - Do not let saw dust enter into the slides.", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "300 mm", "price": 1371, "is_default": true}, {"label": "350 mm", "price": 1606, "is_default": false}, {"label": "400 mm", "price": 1838, "is_default": false}, {"label": "450 mm", "price": 2056, "is_default": false}, {"label": "500 mm", "price": 2290, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco Sleek Telescopic Drawer Slide 35kg SS304 Soft Close', 'Manufactured out of stainless steel 304 grade.
Built-in soft close mechanism.
Precision ball bearings ensure smooth movement.
Full extension of drawer.
Easy for installation
Load Capacity: 35 kgs.
Direct fitting from front
Removable drawer with latch
System 32 installation
72 hrs. salt spray test passed
BIS certified
50000 cycles tested', 1674, '/images/ebco/drawer-slides/ebco-drawer-slide-6a.webp', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-6a.webp', '/images/ebco/drawer-slides/ebco-drawer-slide-6b.webp'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "SS 304 - Sleek Telescopic Drawer Slides - 35Kg - Soft Close (35 Kg, 45 mm Ht)", "Finish": "Stainless Steel", "Caution": "For efficiency and durability: - Strictly maintain 12.7 to 13.0mm side gap. - Fit slides parallel and at equal heights. - Do not apply paint or polish. - Do not let saw dust enter into the slides.", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "300 mm", "price": 1674, "is_default": true}, {"label": "350 mm", "price": 1906, "is_default": false}, {"label": "400 mm", "price": 2133, "is_default": false}, {"label": "450 mm", "price": 2370, "is_default": false}, {"label": "500 mm", "price": 2619, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco Concealed Drawer Slide Slim 3 (With Facia Brackets)', 'Perfect for modern furniture drawers, this concealed slide gives a sleek appearance without visible hardware.
Uses minimal space below the drawer (27mm clearance).
Drawer 3D adjustment:
Height adjustment: 0 ~ +3mm.
Depth adjustment: 0 ~ +5mm.
Width adjustment: ±1.5 mm
Length: 300 - 600mm
Finish: Zinc white', 1150, '/images/ebco/drawer-slides/ebco-drawer-slide-7a.webp', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-7a.webp', '/images/ebco/drawer-slides/ebco-drawer-slide-7b.webp'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "Concealed Drawer Slide Slim 3 (With Facia Brackets)", "Finish": "Zinc White", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "300 mm", "price": 1150, "is_default": true}, {"label": "350 mm", "price": 1206, "is_default": false}, {"label": "400 mm", "price": 1265, "is_default": false}, {"label": "450 mm", "price": 1341, "is_default": false}, {"label": "500 mm", "price": 1435, "is_default": false}, {"label": "550 mm", "price": 1474, "is_default": false}, {"label": "600 mm", "price": 1541, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco Steel Furniture Drawer Slide', 'Precision ball bearing.
Full Extension of Drawer.
Direct fitting from front.
Removable drawer with latch.
Load capacity 35kg.', 546, '/images/ebco/drawer-slides/ebco-drawer-slide-8a.jpg', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-8a.jpg'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "Steel Furniture Drawer Slide", "Gap/side (mm)": "12.7 to 13.0", "Max. Load (Kgs)": "35 Kgs.", "Finish": "Zinc White", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "400 mm", "price": 546, "is_default": true}, {"label": "450 mm", "price": 612, "is_default": false}, {"label": "500 mm", "price": 683, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco Sleek Telescopic Drawer Slide 35 - Soft Close', 'Precision telescopic slides
Soft closing function built in slide, easy for installation.
Full extension of drawer
Load capacity : 35 Kgs
Direct fitting from the front
Removable drawer with Latch
System 32 Installation', 722, '/images/ebco/drawer-slides/ebco-drawer-slide-9a.jpg', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-9a.jpg'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "Sleek Telescopic Drawer Slide 35 - Soft Close", "Finish": "Zinc White / Zinc Black", "Caution": "For efficiency and durability: - Strictly maintain 12.7 to 13.0mm side gap. - Fit slides parallel and at equal heights. - Do not apply paint or polish. - Do not let saw dust enter into the slides", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "300 mm", "price": 722, "is_default": true}, {"label": "350 mm", "price": 796, "is_default": false}, {"label": "400 mm", "price": 871, "is_default": false}, {"label": "450 mm", "price": 949, "is_default": false}, {"label": "500 mm", "price": 1024, "is_default": false}, {"label": "550 mm", "price": 1115, "is_default": false}, {"label": "600 mm", "price": 1189, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco Sleek Telescopic Drawer Slides 1 - 35', 'Precision Telescopic Slides
Full Extension of Drawer
Direct fitting from front
Load Capacity: 35 Kgs
Removable drawer with latch
System 32 Installation
Comes in Pack of 2 Pairs (4 Slides – for 2 Drawers)', 271, '/images/ebco/drawer-slides/ebco-drawer-slide-10a.jpg', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-10a.jpg', '/images/ebco/drawer-slides/ebco-drawer-slide-10b.jpg'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "Sleek Telescopic Drawer Slides 1 - 35", "Finish": "Zinc Plated White/ Zinc Plated Black", "Caution": "For efficiency and durability: - Strictly maintain 12.7 to 13.0mm side gap. - Fit slides parallel and at equal heights. - Do not apply paint or polish. - Do not let saw dust enter into the slides.", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "250 mm", "price": 271, "is_default": true}, {"label": "300 mm", "price": 325, "is_default": false}, {"label": "350 mm", "price": 369, "is_default": false}, {"label": "400 mm", "price": 409, "is_default": false}, {"label": "450 mm", "price": 459, "is_default": false}, {"label": "500 mm", "price": 494, "is_default": false}, {"label": "550 mm", "price": 561, "is_default": false}, {"label": "600 mm", "price": 611, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco Concealed Drawer Slide - Slim 2 - Smart Push (with Fascia Bracket)', 'Concealed drawer slides slim 2 with smart push mechanism for handle less drawers.
Load capacity: 35kg
Lengths: 350, 400, 450 & 500mm
3D adjustment
Drawer height adjustment: 0~+3mm
Drawer width adjustment: ±1.5mm
Front panel gap adjustment: -2.5 to + 4mm
Comes with stabilizer bar for the wide drawers to improve the stability of drawer and reduce the drawer sag.', 3600, '/images/ebco/drawer-slides/ebco-drawer-slide-11a.jpg', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-11a.jpg', '/images/ebco/drawer-slides/ebco-drawer-slide-11b.jpg'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "Concealed Drawer Slide- Slim 2", "Finish": "Zinc Plated White", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "350 mm", "price": 3600, "is_default": true}, {"label": "400 mm", "price": 3741, "is_default": false}, {"label": "450 mm", "price": 3873, "is_default": false}, {"label": "500 mm", "price": 4067, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco Concealed Drawer Slide Slim – 2 Push Open (with Fascia Bracket)', 'Concealed drawer slide slim 2 with facia brackets has in-built PUSH OPEN mechanism
This compact model uses minimal space (27mm) below the drawer
Flexible 3D adjustment allows facia brackets to be adjusted in 3 directions
Load capacity: 35kgs
Finish: Zinc white', 1648, '/images/ebco/drawer-slides/ebco-drawer-slide-12a.png', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-12a.png'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Name": "Concealed Drawer Slide Slim – 2 Push Open (with Facia Bracket)", "Pcs/Set": "Set of 2", "Finish": "Zinc Plated White", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "300 mm", "price": 1648, "is_default": true}, {"label": "350 mm", "price": 1689, "is_default": false}, {"label": "400 mm", "price": 1827, "is_default": false}, {"label": "450 mm", "price": 1950, "is_default": false}, {"label": "500 mm", "price": 2101, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco Two Way Slides', 'Slim design requires only 9.5mm side gap.
Can be used with bigger drawers as slides are reversible.
"System 32" compatible.
Precision Telescopic Slide for smooth movement.
Load capacity - 12 kgs.', 191, '/images/ebco/drawer-slides/ebco-drawer-slide-13a.jpg', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-13a.jpg'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Model": "Two Way Slide", "Length (mm)": "194", "Extension Loss (mm)": "58", "Drawer Length ''A'' mm": "200-325", "Max.Load Kgs.": "12", "Gap/Side (mm)": "10", "Caution": "Strictly maintain side gap given in the diagrams. - Fit slides parallel and at equal heights. - Do not apply paint or polish. - Do not let saw dust enter into the slides.", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "200 mm", "price": 191, "is_default": true}, {"label": "300 mm", "price": 252, "is_default": false}, {"label": "375 mm", "price": 301, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco Concealed Drawer Slides - Slim 2 (Soft Close)', 'This concealed drawer slide - slim 2 model is compact and uses minimal space below the drawer (27mm clearance).
Available with facia bracket for wooden drawers and without facia bracket for kitchen baskets.
Full extension with soft close and tool free assembly and removal of drawers.
Height adjustment: 0 ~ +3mm.
Depth adjustment: 0 ~ +5mm.
Width adjustment: ±1.5 mm
Load Capacity- 35kgs.
Soft Closing.', 1523, '/images/ebco/drawer-slides/ebco-drawer-slide-14a.jpg', ARRAY['/images/ebco/drawer-slides/ebco-drawer-slide-14a.jpg', '/images/ebco/drawer-slides/ebco-drawer-slide-14b.jpg'], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "Concealed Drawer Slide - Slim 2 (with facia bracket)", "Finish": "Zinc White", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, '[{"label": "300 mm", "price": 1523, "is_default": true}, {"label": "350 mm", "price": 1572, "is_default": false}, {"label": "400 mm", "price": 1722, "is_default": false}, {"label": "450 mm", "price": 1832, "is_default": false}, {"label": "500 mm", "price": 1984, "is_default": false}, {"label": "550 mm", "price": 2150, "is_default": false}, {"label": "600 mm", "price": 2245, "is_default": false}]'::jsonb, v_ebco, 100, true),
  ('Ebco Stabilizer Bar 900mm', 'Stabilizer bar for wide drawers.
Improves the stability of the drawer and reduces sag.
Length: 900 mm.
Finish: Zinc Plated White.', 305, NULL, ARRAY[]::text[], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "Stabilizer Bar", "Size (mm)": "900", "Finish": "Zinc Plated White", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Ebco Kitchen Basket 500mm', 'Concealed Drawer Slide - Slim 2 for kitchen baskets, without facia bracket.
Length: 500 mm.
Finish: Zinc White.', 1648, NULL, ARRAY[]::text[], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "Concealed Drawer Slide - Slim 2 (for kitchen basket - w/o facia bracket)", "Size (mm)": "500", "Finish": "Zinc White", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, NULL, v_ebco, 100, true),
  ('Ebco Undermount Slide 450mm', 'Concealed Drawer Slide - Slim 2 for undermount kitchen baskets (Extendo), without facia bracket.
Length: 450 mm.
Finish: Zinc White.', 1523, NULL, ARRAY[]::text[], '{"Brand": "Ebco", "Category": "Drawer Slides", "Item": "Concealed Drawer Slide - Slim 2 (for Undermount kitchen Baskets - w/o Facia Bracket/Extendo)", "Size (mm)": "450", "Finish": "Zinc White", "GST": "18%", "Source": "ebco-drawer-slides-6-september-2026"}'::jsonb, NULL, v_ebco, 100, true);
END $$;
