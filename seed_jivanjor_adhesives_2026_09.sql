-- Jivanjor Adhesives (5 September 2026) - from owner-provided CSV + product photos.
-- 12 products inserted: 3 single-price (variants NULL, no selector) and 9 with variant selectors.
-- 36 variant prices in the source; the product price is the cheapest variant.
-- 12 images in /public/images/jivanjor/ - deploy with the frontend.
-- Owner decision: P5 Lamino Advance reuses P4 Lamino's description, tech specs,
-- USP and Applications content - P5's own source cells were placeholder text
-- referring to Lamino (quarantined by the analysis); P5 keeps its own name,
-- variants and prices.
-- 7 variant prices exceed Rs 10,000 (max Rs 20,542 on Lamino Advance 60kg): after
-- running, verify all 12 products / 36 variants are visible on the live shop and
-- category pages, counting with an explicit limit > 1000 (MISTAKES.md #6, #7).
-- Safe to re-run: rows are tagged with Source='jivanjor-adhesives-5-september-2026'
-- and deleted before re-insert.

ALTER TABLE products ADD COLUMN IF NOT EXISTS variants JSONB DEFAULT '[]'::jsonb;

DO $$
DECLARE
  v_parent UUID;
  v_adhesives UUID;
BEGIN
  SELECT id INTO v_parent FROM categories WHERE slug='jivanjor' OR lower(name)='jivanjor' LIMIT 1;
  IF v_parent IS NULL THEN
    INSERT INTO categories (name, slug) VALUES ('Jivanjor','jivanjor') RETURNING id INTO v_parent;
  END IF;
  SELECT id INTO v_adhesives FROM categories WHERE parent_id=v_parent AND name='Adhesives' LIMIT 1;
  IF v_adhesives IS NULL THEN
    INSERT INTO categories (name, slug, parent_id) VALUES ('Adhesives', 'jivanjor-adhesives', v_parent) RETURNING id INTO v_adhesives;
  END IF;

  -- Remove rows from any earlier run of this script, then re-insert.
  DELETE FROM products WHERE specs->>'Source' = 'jivanjor-adhesives-5-september-2026';

  INSERT INTO products (name, description, price, image_url, images, specs, variants, category_id, stock, is_active) VALUES
  ('Jivanjor Allrounder', 'The true all rounder in wood working adhesive
HP Technology - Strong Bonding
Multipurpose application
Easy to spread and work

Key Features:
- Superior Bond Strength- Provides strong and dependable bonding across woodworking applications.
- Quick Setting- Develops handling strength in 6–8 hours for faster project completion.
- Better Coverage- Smooth flow and spreadability help maximize coverage and application efficiency.
- Safe Formulation- Water-based, non-toxic and solvent-free with low odour for comfortable use.

Applications:
- Woodworking Application- All Rounder furniture manufacturing like chairs, tables, beds, wardrobes, general laminate & veneer pasting on plywood, particle board, MDF etc.
- Industrial Application- All Rounder is used in industries like pencil manufacturing, paper tubes, wallpaper, m carpet manufacturing, sports goods and general packaging', 1405, '/images/jivanjor/jivanjor-allrounder.png', ARRAY['/images/jivanjor/jivanjor-allrounder.png'], '{"Brand": "Jivanjor", "Category": "Adhesives", "Appearance": "Milk white", "Solids": "43-45%", "Viscosity": "270-320 Poise", "Coverage": "40-44 Sqft/Kg", "GST": "18%", "Source": "jivanjor-adhesives-5-september-2026"}'::jsonb, '[{"label": "5kg", "price": 1405, "is_default": true}, {"label": "10kg", "price": 2686, "is_default": false}, {"label": "20kg", "price": 5085, "is_default": false}, {"label": "50kg", "price": 10856, "is_default": false}]'::jsonb, v_adhesives, 100, true),
  ('Jivanjor Watershield', 'Heatproof & Waterproof Adhesive
CLP Technology for strong hold
Superior Flow & Easy Application
Dries in 4-6 Hours
Loaded with CLP tech, Watershield helps increase water resistance along with a smooth & effortless application.
Specialist CLP tech helps resist moisture and helps to increase life of furniture in wet areas

Key Features:
- Water Resistant Bonding- Ideal for furniture prone to high moisture and humid climate.
- CLP Technology For Long Lasting Bonds- Cross linking polymers help prevent debonding of laminates exposed to high moisture areas
- Non Toxic Formula- Formaldehyde free, watershield sets in about 4-6 hours and helps in faster furniture production and installation
- Superior Coverage- Excellent flow and spreadability ensure smooth application and better coverage.

Applications:
- Laminate to Plywood Bonding- Watershield is ideal for bonding laminate to Plywood, HDHMR, particle board and MDF
- Kitchen Cabinets and Home Interiors- Watershield is highly recommended for application on high moisture prone areas, kitchen, washrooms as well as general furniture like wardrobes and storage racks.', 1752, '/images/jivanjor/jivanjor-watershield.png', ARRAY['/images/jivanjor/jivanjor-watershield.png'], '{"Brand": "Jivanjor", "Category": "Adhesives", "Appearance": "Milk white", "Solids": "47-50%", "Viscosity": "250-400 Poise", "Coverage": "45-50 Sqft/Kg", "GST": "18%", "Source": "jivanjor-adhesives-5-september-2026"}'::jsonb, '[{"label": "5kg", "price": 1752, "is_default": true}, {"label": "10kg", "price": 3379, "is_default": false}, {"label": "20kg", "price": 5935, "is_default": false}, {"label": "50kg", "price": 14107, "is_default": false}]'::jsonb, v_adhesives, 100, true),
  ('Jivanjor Aquabond', 'Synthetic Resin Adhesive
Cross Linking Polymer
Water Proof
Heat Proof
Aquabond is a ready-to-use adhesive for all wood working applications. It is a water based adhesive, non-flammable and non-toxic in nature.
Specialist CLP tech helps resist moisture and helps to increase life of furniture in wet areas. Added heat resistance provides perfect peace of mind

Key Features:
- Strong Water Resistance- Ideal for furniture prone to high moisture and humid climates
- Heat Resistance- For an added comfort specific to furniture exposed to high heat areas like kitchen
- CLP Tech For Stronger Bonds- Cross linking polymers help prevent debonding of laminates exposed to high moisture areas
- Fast Setting & Non Toxic Formula- Formaldehyde free, Aquabond sets in about 6 hours and helps in faster furniture production and installation

Applications:
- Laminate to Plywood Bonding- Aquabond is ideal for bonding laminate to Plywood, HDHMR, particle board and MDF.
- Kitchen, Home Interiors and Storage Applications- Aquabond is highly recommended for application on high moisture prone areas, kitchen, washrooms as well as general furniture like wardrobes and storage racks.', 1794, '/images/jivanjor/jivanjor-aquabond.png', ARRAY['/images/jivanjor/jivanjor-aquabond.png'], '{"Brand": "Jivanjor", "Category": "Adhesives", "Appearance": "Milk white", "Solids": "47-50%", "Viscosity": "250-400 Poise", "Coverage": "45-50 Sqft/Kg", "GST": "18%", "Source": "jivanjor-adhesives-5-september-2026"}'::jsonb, '[{"label": "5kg", "price": 1794, "is_default": true}, {"label": "10kg", "price": 3460, "is_default": false}, {"label": "20kg", "price": 6350, "is_default": false}, {"label": "50kg", "price": 14501, "is_default": false}, {"label": "60kg", "price": 17393, "is_default": false}]'::jsonb, v_adhesives, 100, true),
  ('Jivanjor Lamino', 'Laminate ka Specialist
Anti Bubble Formula
Fast Drying adhesive
Superior Grab
Powered by IPN Technology, it provides superior bonding, water-resistant, bubble-free bonding & 20% higher coverage as compared with traditional white glue.
Lamino is suitable for application across premium laminates, furniture and interior applications which demand superior finish & long lasting bond.

Key Features:
- Bubble Free Lamination- Provides uniform adhesive spread for seamless lamination without trapped air bubbles.
- Superior Grab- IPN formula provides strong tack, ensuring firm laminate placement, reducing slippage and improving application efficiency.
- Tough Resistant Formula- Designed to withstand moisture, keeping laminates securely bonded over time.
- Super Fast Drying Adhesive- Sets in just 2-4 hours, reduces waiting time, enabling quicker laminate application and improved productivity.

Applications:
- Laminate Bonding- Specially designed for laminate pasting on plywood and others options such as WPC sheets, HDHMR boards, MDF, particle board, and PVC boards.
- Kitchen Areas- Lamino''s durable interpenetrating bond gives your kitchen cabinet resistance to moisture and provides durable long lasting adhesion.
- Dining, Living and Overall Home Decor- Lamino special formula helps in providing clean bubble free finish & durable long lasting furniture for any surface where laminate is bonded onto Ply or HDHMR substrate.', 1891, '/images/jivanjor/jivanjor-lamino.png', ARRAY['/images/jivanjor/jivanjor-lamino.png'], '{"Brand": "Jivanjor", "Category": "Adhesives", "Appearance": "Milk white", "Solids": "47-50%", "Viscosity": "250-350 Poise", "Coverage": "45-50 Sqft/Kg", "GST": "18%", "Source": "jivanjor-adhesives-5-september-2026"}'::jsonb, '[{"label": "5kg", "price": 1891, "is_default": true}, {"label": "10kg", "price": 3636, "is_default": false}, {"label": "20kg", "price": 6387, "is_default": false}, {"label": "50kg", "price": 15669, "is_default": false}]'::jsonb, v_adhesives, 100, true),
  ('Jivanjor Lamino Advance', 'Laminate ka Specialist
Anti Bubble Formula
Fast Drying adhesive
Superior Grab
Powered by IPN Technology, it provides superior bonding, water-resistant, bubble-free bonding & 20% higher coverage as compared with traditional white glue.
Lamino is suitable for application across premium laminates, furniture and interior applications which demand superior finish & long lasting bond.

Key Features:
- Bubble Free Lamination- Provides uniform adhesive spread for seamless lamination without trapped air bubbles.
- Superior Grab- IPN formula provides strong tack, ensuring firm laminate placement, reducing slippage and improving application efficiency.
- Tough Resistant Formula- Designed to withstand moisture, keeping laminates securely bonded over time.
- Super Fast Drying Adhesive- Sets in just 2-4 hours, reduces waiting time, enabling quicker laminate application and improved productivity.

Applications:
- Laminate Bonding- Specially designed for laminate pasting on plywood and others options such as WPC sheets, HDHMR boards, MDF, particle board, and PVC boards.
- Kitchen Areas- Lamino''s durable interpenetrating bond gives your kitchen cabinet resistance to moisture and provides durable long lasting adhesion.
- Dining, Living and Overall Home Decor- Lamino special formula helps in providing clean bubble free finish & durable long lasting furniture for any surface where laminate is bonded onto Ply or HDHMR substrate.', 10253, '/images/jivanjor/jivanjor-lamino-advance.jpeg', ARRAY['/images/jivanjor/jivanjor-lamino-advance.jpeg'], '{"Brand": "Jivanjor", "Category": "Adhesives", "Appearance": "Milk white", "Solids": "47-50%", "Viscosity": "250-350 Poise", "Coverage": "45-50 Sqft/Kg", "GST": "18%", "Source": "jivanjor-adhesives-5-september-2026"}'::jsonb, '[{"label": "30kg", "price": 10253, "is_default": true}, {"label": "60kg", "price": 20542, "is_default": false}]'::jsonb, v_adhesives, 100, true),
  ('Jivanjor PVC Xtra', 'PVC & Acrylic Adhesive
Edge banding specialist
No visible marks
Clear and transparent film
PVC Xtra is a water-based adhesive specially made for wood-to-PVC bonding, ensuring a strong hold and clean finish.
Specially made for PVC, acrylic, UPVC & WPC sheets, keeping edges firmly in place for a neat finish.

Key Features:
- PVC Sheet Bonding- Specially made for bonding PVC sheets to wood and plywood.
- Acrylic & UPVC- Suitable for bonding acrylic and UPVC sheets to wood surfaces.
- Edge Banding- Ideal for bonding PVC strips on furniture edges for a neat finish.
- Dries Transparent- Dries into a clear film that leaves no visible marks, keeping PVC looking clean and new.

Applications:
- PVC Laminate to Ply, HDHMR and MDF Bonding- Best suited for bonding low energy and non porous PVC and Acrylic substrates.
- Modular Kitchen and Interior Applications- Heat resistant and fast drying, along with easy spreadability make it one of the best choices for usage in modern interior works', 256, '/images/jivanjor/jivanjor-pvc-xtra.png', ARRAY['/images/jivanjor/jivanjor-pvc-xtra.png'], '{"Brand": "Jivanjor", "Category": "Adhesives", "Appearance": "Yellow Viscous Liquid", "Solids": "55-58%", "Viscosity": "50-120 Poise", "Coverage": "45-50 Sqft/Kg", "GST": "18%", "Source": "jivanjor-adhesives-5-september-2026"}'::jsonb, '[{"label": "500ml", "price": 256, "is_default": true}, {"label": "1 liter", "price": 485, "is_default": false}, {"label": "5 liter", "price": 2235, "is_default": false}, {"label": "10 liter", "price": 4168, "is_default": false}]'::jsonb, v_adhesives, 100, true),
  ('Jivanjor Polystic', 'Synthetic performance oriented economical adhesive for wood working application
Strong Bond Strength
Smooth and Easy Application
Water-Based & Safe Formula
Reliable wood adhesive designed to deliver durable bond, smooth application, lasting performance for furniture & interior woodworking projects

Key Features:
- Strong Bond Strength- Provides durable and dependable bonding for woodworking applications
- Better Coverage- Delivers coverage of up to 38–40 sq. ft./kg for efficient usage
- Safe Water-Based Formula- Non-flammable, non-toxic and solvent-free for safer application
- Easy Clean-Up- Excess adhesive can be easily removed with a wet cloth
- Delivers exceptional value for furniture application for home and office and general commercial usage

Applications:
- Carpentry Applications- Polystic Super bonding to laminate or veneer to Plywood, HDHMR, MDF, particle board and so on
- Non Furniture Application- Polystic Super bonding of wooden boxes for TV and radio, frames for wall clock, usage in making of wooden toys and more', 156, '/images/jivanjor/jivanjor-polystic.png', ARRAY['/images/jivanjor/jivanjor-polystic.png'], '{"Brand": "Jivanjor", "Category": "Adhesives", "Appearance": "Mix White Emulsion", "Solids": "29.7-31.7%", "Viscosity": "380-480 Poise", "GST": "18%", "Source": "jivanjor-adhesives-5-september-2026"}'::jsonb, '[{"label": "1kg", "price": 156, "is_default": true}, {"label": "5kg", "price": 835, "is_default": false}, {"label": "10kg", "price": 1642, "is_default": false}, {"label": "20kg", "price": 3099, "is_default": false}, {"label": "50kg", "price": 7110, "is_default": false}]'::jsonb, v_adhesives, 100, true),
  ('Jivanjor Jubi Spray', 'Easy spray adhesive for bonding different surfaces at home or on site.
Multi Substrate Application
Fast Tack
Nail and Tape Free Application
A convenient spray adhesive made for quick bonding across different surfaces and everyday jobs.
Easy to use for home interiors, furniture work and quick on-site jobs.

Key Features:
- Fast Tack- Provides instant grab for quicker positioning and faster application
- Class 1 Fire Rating- Certified for enhanced fire performance and added safety
- Soft Glue Line- Suitable for curved surfaces where a flexible hold is needed
- Multi substrate application- Works on leather, fabric, foam, sheet metal, laminates, veneer, louvers and more

Applications:
- Laminate and Veneer Pasting- Useful for fixing laminates and veneer on walls, ceilings and other areas where clamps or tape are difficult to use
- Interior and Modular Furniture- Ideal for quick repairs and finishing work on edge bands, wardrobes and modular furniture without carrying large adhesive packs', 616, '/images/jivanjor/jivanjor-jubi-spray.png', ARRAY['/images/jivanjor/jivanjor-jubi-spray.png'], '{"Brand": "Jivanjor", "Category": "Adhesives", "Appearance": "White", "Viscosity": "300 cos at 25 degrees", "Coverage": "25-35 Sqft / bottle of 500 Ml", "GST": "18%", "Source": "jivanjor-adhesives-5-september-2026"}'::jsonb, NULL, v_adhesives, 100, true),
  ('Jivanjor Hero', 'Economical, dependable and versatile woodworking adhesive
Strong Bond Strength
Value for Money
Safe Water-Based Formula
A water-based woodworking adhesive delivering strong bonds, easy application and reliable performance across furniture applications.
Woodworking applications for professional furniture manufacturing, fabrication and interior installation.

Key Features:
- Strong Bond Strength- Delivers reliable and durable bonding for woodworking applications
- Water-Based Formula- Non-flammable and non-toxic for safer everyday use
- Easy Clean-Up- Excess adhesive can be easily removed with a wet cloth
- Smooth & Easy Application- Continuous flow and good spreadability ensure hassle-free application

Applications:
- Carpentry Applications- Hero bonding to laminate or veneer to Plywood, HDHMR, MDF, particle board and so on
- Non Furniture Application- Hero bonding of wooden boxes for TV and radio, frames for wall clock, usage in making of wooden toys and more', 134, '/images/jivanjor/jivanjor-hero.png', ARRAY['/images/jivanjor/jivanjor-hero.png'], '{"Brand": "Jivanjor", "Category": "Adhesives", "Appearance": "Milky White Emulsion", "Solids": "26-28%", "Viscosity @ 25°C": "350-500 Poise", "GST": "18%", "Source": "jivanjor-adhesives-5-september-2026"}'::jsonb, NULL, v_adhesives, 100, true),
  ('Jivanjor Jubipaste', 'Instant grip adhesive sealant for nail and tape free application
No Nails, Screws or Tape Needed
Multi Substrate Bonding
Heat, Weather & Water Resistant
Jubipaste gives an instant, strong hold without the need for nails, screws or other fittings.
Sticks ACP, mirror, marble, granite, plywood and tiles directly to the surface. No nails, no screws, no dust—just press and fix.

Key Features:
- Instant Grab Technology- Holds surfaces in place quickly, reducing the need for nails, screws or other fittings
- High Strength Bonding- Delivers durable, long-lasting adhesion across a wide range of substrates. Can be used for bonding substrates even under water
- Flexible, Tough & Elastic Bond- Maintains flexibility after curing without shrinking or cracking
- Weather & UV Resistant- Offers excellent resistance to UV exposure, moisture and harsh environmental conditions

Applications:
- Interior, Kitchen And Mirror Applications- Can be used for ACP panel fixing, decorative wall panels, wall cladding installations, mirror installation, stone and granite fixtures and more
- Wet Areas Application and Repair Work- Used for wet area bonding and sealing in kitchen and bathroom, wall cladding, rainwater duct joints, gap sealing, modular kitchen and more', 353, '/images/jivanjor/jivanjor-jubipaste.png', ARRAY['/images/jivanjor/jivanjor-jubipaste.png'], '{"Brand": "Jivanjor", "Category": "Adhesives", "Appearance": "White", "Curing System": "Moisture Curing", "Elongation at Break": "Approx 300%", "Application Temperature": "5-40 Degrees", "JUBIPASTE NAIL FREE complies with": "ISO11600 F 20HM - ASTM C 920 - ASTM C 1248 for Non Staining", "GST": "18%", "Source": "jivanjor-adhesives-5-september-2026"}'::jsonb, NULL, v_adhesives, 100, true),
  ('Jivanjor Termilok', 'Anti termite Wood Preservative
Termite Protection
Borer Resistance
Durable & Cost Effective Solution
An eco-friendly wood preservative that penetrates deep into wood to protect against termites and borers
Woodworking applications for professional furniture manufacturing, fabrication and interior installation.

Key Features:
- Termite & Borer Protection- Creates a protective barrier against termite and borer infestation
- Deep Penetration Formula- Penetrates deep into the wood for enhanced protection
- Long-Lasting Performance- Provides durable protection to help extend wood life
- Eco-Friendly & Easy to Apply- User-friendly formulation suitable for brush, spray or cloth application

Applications:
- Furniture and Interior Woodwork- Termilok usage to protect general furniture like wardrobes, tables chairs beds and more against borer and termite infestation
- Preventive Maintenance- Termilok protecting interior furniture (new and existing), doors, door frames, window frames, wooden ceilings, wall panelling from borer and termite', 258, '/images/jivanjor/jivanjor-termilok.png', ARRAY['/images/jivanjor/jivanjor-termilok.png'], '{"Brand": "Jivanjor", "Category": "Adhesives", "Appearance": "Flowing Liquid", "Coverage": "Approx. 12–15 sq. m./litre per coat", "GST": "18%", "Source": "jivanjor-adhesives-5-september-2026"}'::jsonb, '[{"label": "500ml", "price": 258, "is_default": true}, {"label": "1 liter", "price": 425, "is_default": false}]'::jsonb, v_adhesives, 100, true),
  ('Jivanjor Fastx', 'Super Fast Drying Adhesive
Advanced Nano Technology
No Harmful Smell
Heat Proof upto 180 Degrees
A ready-to-use, benzene-free adhesive for woodworking and laminate bonding, designed to withstand temperatures up to 180°C.
Solvent based heat resistant contact adhesive suitable for furniture and interior industry

Key Features:
- Quick Working Time- Super fast workability -4–8 minute open time with handling strength in just 1–2 hours
- High Tack- Delivers excellent initial grab for faster assembly and handling. Suitable for vertical application.
- Benzene-Free Formula- Safer formulation with low odour for a better working experience.
- High Heat Resistance- Withstands temperatures up to 180°C for demanding applications in kitchen areas and likewise.

Applications:
- Laminate to Plywood Bonding- FastX is suitable for bonding decorative laminates to plywood blockboards, HDHMR, MDF and Particle Board. Suitable for kitchen and modular furniture
- Nano Technology for vertical lamination & areas needed demanding application- FastX built for speed & reliability, FastX special Nano tech helps resist spring back action and is suitable for curved areas, laminate on laminate & vertical application', 138, '/images/jivanjor/jivanjor-fastx.png', ARRAY['/images/jivanjor/jivanjor-fastx.png'], '{"Brand": "Jivanjor", "Category": "Adhesives", "Appearance": "Yellow Viscous Liquid", "Solids": "23-28%", "Viscosity": "20-40 Poise", "Coverage": "40 Sqft/Kg", "GST": "18%", "Source": "jivanjor-adhesives-5-september-2026"}'::jsonb, '[{"label": "200ml", "price": 138, "is_default": true}, {"label": "500ml", "price": 310, "is_default": false}, {"label": "1 liter", "price": 595, "is_default": false}]'::jsonb, v_adhesives, 100, true);
END $$;
