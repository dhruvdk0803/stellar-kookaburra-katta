-- Additional Apollo products scraped from makankidukan.com (July 2026).
-- Adds 29 product types NOT present in the March 2026 price-list seed
-- (uPVC/SWR pipe lengths, solvent cements, water tanks, NRV/saddle/gully-trap fittings).
-- Run AFTER seed_apollo_pricelist.sql. Safe to re-run: deletes its own rows first (matched by Source spec).

DO $$
DECLARE
  v_parent UUID;
  v_sub0 UUID;  -- CPVC Fittings & Pipes
  v_sub1 UUID;  -- SWR / uPVC Pipes & Fittings
  v_sub2 UUID;  -- Solvent Cement
  v_sub3 UUID;  -- Water Tanks
BEGIN
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

  DELETE FROM products WHERE specs->>'Source' LIKE 'https://www.makankidukan.com/building-product/%' AND specs->>'Brand' = 'APL Apollo';

  INSERT INTO products (name, description, price, image_url, images, specs, category_id, stock, is_active) VALUES
  ('Apollo NRV (non Returnable Valve) SDR CPVC Fitting', 'Apollo SDR pipes and fittings form high-performance thermoplastic piping systems. The NRV is a non-returnable valve designed for CPVC applications. SDR represents the ratio of pipe diameter to wall thickness, affecting the pressure rating.

Available sizes/variants: 0.75 inch, 1 inch, 1.25 inch, 1.5 inch

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 452, 'https://www.makankidukan.com/uploads/products/1748338707_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748338707_0.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Standards":"ASTM D1785, D2241, or D2665","Color":"Gray or white","Corrosion Resistance":"Excellent resistance to corrosion and chemical attack","Weight":"Lightweight compared to metal piping","Interior":"Smooth interior reduces friction","Temperature":"Higher temperatures than standard PVC","Installation":"Solvent-weld and gasketed options available","Available Sizes":"0.75 inch, 1 inch, 1.25 inch, 1.5 inch","MRP":"Rs. 452","Source":"https://www.makankidukan.com/building-product/apollo-nrv-non-returnable-valve-sdr-cpvc-fitting"}'::jsonb, v_sub0, 100, true),
  ('Apollo Concealed Valve Swept SDR CPVC Fitting SCH 40 & 80', 'Apollo SDR pipes and fittings are engineered for high-performance thermoplastic piping systems. This product utilizes CPVC material and meets ASTM standards for pressure and drain-waste-vent applications. It features excellent resistance to corrosion and chemical attack along with lightweight construction that simplifies installation compared to metal alternatives, reduces friction and increases flow efficiency, with long service life and solvent-weld/gasketed installation options.

Available sizes/variants: 0.75 inch, 1 inch

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 1800, 'https://www.makankidukan.com/uploads/products/1748345773_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748345773_0.jpg'], '{"Brand":"APL Apollo","Category":"CPVC Fittings & Pipes","Material":"CPVC (Chlorinated Polyvinyl Chloride)","Fitting Type":"Concealed Valve, Swept","Standards":"ASTM D1785, D2241, D2665","Available Schedules":"SCH 40 & 80","Color":"Gray or white","Thermal Resistance":"CPVC withstands higher temperatures than standard PVC","Available Sizes":"0.75 inch, 1 inch","MRP":"Rs. 1800","Source":"https://www.makankidukan.com/building-product/apollo-concealed-valve-swept-sdr-cpvc-fitting-sch-40-80"}'::jsonb, v_sub0, 100, true),
  ('Apollo SWR Drainage 4kg/cm2 3mtr uPVC Pipe', 'This sewerage/drainage pipe offers leak-proof joints and a smooth inner surface that minimizes clogging. It resists chemicals and acids typically found in sewage plus biological attacks. Additional benefits include UV resistance, lightweight construction, and environmental safety without soil reactivity.

Available sizes/variants: 2 inch, 2.5 inch, 3 inch, 4 inch, 4.5 inch, 5 inch, 6 inch, 7 inch, 8 inch, 9 inch, 10 inch, 11 inch, 12 inch, 14 inch, 16 inch

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 434.25, 'https://www.makankidukan.com/uploads/products/1748410709_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748410709_0.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Pressure Rating":"4 KG/CM2","Length":"3 Meter","Application":"Sewerage/Drainage System","Stock Status":"In Stock","Return Policy":"7 days","Available Sizes":"2 inch, 2.5 inch, 3 inch, 4 inch, 4.5 inch, 5 inch, 6 inch, 7 inch, 8 inch, 9 inch, 10 inch, 11 inch, 12 inch, 14 inch, 16 inch","MRP":"Rs. 434.25","Source":"https://www.makankidukan.com/building-product/apollo-swr-drainage-4kgcm2-3mtr-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo SWR Drainage 6kg/cm2 3mtr uPVC Pipe', 'This sewerage pipe system features uPVC material offering strength and corrosion resistance. Key attributes include resistance to chemicals, biological attacks, and rust; high durability without degradation; leak-proof joints; smooth inner surface reducing friction; UV resistance for underground/exposed use; lightweight construction; and environmental safety.

Available sizes/variants: 1.25", 1.5", 2", 2.5", 3", 4", 4.5", 5", 6", 7", 8", 9", 10", 11", 12", 14", 16"

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 257, 'https://www.makankidukan.com/uploads/products/1748412585_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748412585_0.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Pressure Rating":"6 KG/CM2","Length":"3 Meter","Thickness Option":"Common","Stock Status":"In Stock","Return Policy":"7 days","Available Sizes":"1.25\", 1.5\", 2\", 2.5\", 3\", 4\", 4.5\", 5\", 6\", 7\", 8\", 9\", 10\", 11\", 12\", 14\", 16\"","MRP":"Rs. 257","Source":"https://www.makankidukan.com/building-product/apollo-swr-drainage-6kgcm2-3mtr-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Service Saddle uPVC Pipe Fittings', 'Apollo SWR drainage pipes designed for efficient drainage and wastewater management in residential, commercial, agricultural, and industrial settings. Corrosion and rust resistant. Leak-proof rubber ring or solvent cement joints. Smooth inner surface minimizes noise during fluid flow. Non-toxic, bacteria-resistant construction. Chemical resistant. Impact resistant. Eco-friendly, recyclable material.

Available sizes/variants: 63×25 mm, 63×32 mm, 63×63 mm, 75×20 mm, 75×25 mm, 75×32 mm, 90×20 mm, 90×25 mm, 90×32 mm, 110×15 mm, 110×20 mm, 110×25 mm

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 94, 'https://www.makankidukan.com/uploads/products/1748518702_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748518702_0.jpg','https://www.makankidukan.com/uploads/products/1748518702_1.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Type":"Service Saddle Fitting","Standards":"IS 13592 and IS 14735 (SWR systems)","Stock Status":"In Stock","Available Sizes":"63×25 mm, 63×32 mm, 63×63 mm, 75×20 mm, 75×25 mm, 75×32 mm, 90×20 mm, 90×25 mm, 90×32 mm, 110×15 mm, 110×20 mm, 110×25 mm","MRP":"Rs. 94","Source":"https://www.makankidukan.com/building-product/apollo-service-saddle-upvc-pipe-fittings"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe 2.5kg/cm2 With Rubber Ring 3 Mtrs uPVC Pipe', 'Apollo uPVC drainage pipes designed for effective discharge of soil, waste, and rainwater. Features include corrosion resistance, smooth bore for excellent flow, UV resistance in certain models, lightweight construction, leak-proof joints, and a service life exceeding 50 years. Made from rigid, chemically-resistant uPVC without plasticizers, suitable for underground drainage and non-pressure plumbing applications.

Available sizes/variants: 3 Meter length; thickness 75mm/90mm/110mm/160mm

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 456, 'https://www.makankidukan.com/uploads/products/1748587278_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748587278_0.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Length":"3 Meter","Pressure Rating":"2.5 KG/CM2","Thickness Options":"75 mm, 90 mm, 110 mm, 160 mm","Features":"Non-corrosive, Lead-free, Eco-friendly, Chemically resistant","Maintenance":"Low/Minimal","Available Sizes":"3 Meter length; thickness 75mm/90mm/110mm/160mm","MRP":"Rs. 456","Source":"https://www.makankidukan.com/building-product/apollo-pipe-25kgcm2-with-rubber-ring-3-mtrs-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe Type A With Rubber Ring 3 Mtrs uPVC Pipe', 'Apollo uPVC drainage pipes designed for soil, waste, and rainwater discharge. Features include corrosion resistance, smooth bore for optimal flow, lightweight construction, leak-proof joints, and a lifespan exceeding 50 years with minimal maintenance required.

Available sizes/variants: 3 Mtr length; thickness 75mm/90mm/110mm/160mm

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 564, 'https://www.makankidukan.com/uploads/products/1748587065_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748587065_0.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Length":"3 Meter","Thickness Options":"75 mm, 90 mm, 110 mm, 160 mm","Lead Content":"Lead-free","Corrosion Resistance":"Resists moisture and chemicals","UV Resistant":"Yes (certain models)","Bore Type":"Smooth bore","Service Life":"50+ years","Maintenance":"Low maintenance","Available Sizes":"3 Mtr length; thickness 75mm/90mm/110mm/160mm","MRP":"Rs. 564","Source":"https://www.makankidukan.com/building-product/apollo-pipe-type-a-with-rubber-ring-3-mtrs-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe Type B With Rubber Ring 3 Mtrs uPVC Pipe', 'Apollo uPVC drainage pipes designed for soil, waste, and rainwater discharge. Features include corrosion resistance, smooth bore for optimal flow, UV resistance in certain models, lightweight construction, leak-proof joints, and 50+ year service life with minimal maintenance. The uPVC material is rigid, chemically resistant, non-toxic, and ideal for underground drainage and non-pressure plumbing applications.

Available sizes/variants: 3 Mtr (fixed length); thickness 75mm/90mm/110mm/160mm

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 925, 'https://www.makankidukan.com/uploads/products/1748587521_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748587521_0.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Length":"3 Meter","Thickness Options":"75mm, 90mm, 110mm, 160mm","Corrosion Resistant":"Yes","Service Life":"50+ years","Joint Type":"Rubber ring with leak-proof design","Lead-Free":"Yes","Chemical Resistant":"Yes","Available Sizes":"3 Mtr (fixed length); thickness 75mm/90mm/110mm/160mm","MRP":"Rs. 925","Source":"https://www.makankidukan.com/building-product/apollo-pipe-type-b-with-rubber-ring-3-mtrs-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Self Fit Pipe 2.5kg/cm2 3 Mtrs uPVC Pipe', 'Apollo uPVC drainage pipes designed for soil, waste, and rainwater discharge. Features include corrosion resistance, smooth bore construction, lightweight design, leak-proof joints, and an expected lifespan exceeding 50 years. The material is non-toxic and chemically resistant, making these pipes ideal for underground drainage and non-pressure plumbing applications with minimal maintenance requirements.

Available sizes/variants: Thickness options: 75mm, 90mm, 110mm, 160mm

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 450, 'https://www.makankidukan.com/uploads/products/1748587824_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748587824_0.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Service Life":"Over 50 years","Pressure Rating":"2.5 kg/cm2","Length":"3 meters","UV Resistant":"Available for certain models","Lead-free/Eco-friendly":"Yes","Available Sizes":"Thickness options: 75mm, 90mm, 110mm, 160mm","MRP":"Rs. 450","Source":"https://www.makankidukan.com/building-product/apollo-self-fit-pipe-25kgcm2-3-mtrs-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Self Fit Pipe Type A 3 Mtrs uPVC Pipe', 'Apollo uPVC drainage pipes designed for soil, waste, and rainwater discharge. Features include corrosion resistance, smooth bore for excellent flow, UV resistance in certain models, lightweight construction, leak-proof joints, and a 50+ year service life with minimal maintenance requirements. The uPVC material is rigid, chemically resistant, free from plasticizers, non-toxic, and ideal for underground drainage and non-pressure plumbing applications.

Available sizes/variants: 3 Meter length with multiple thickness options (75mm, 90mm, 110mm, 160mm)

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 547.5, 'https://www.makankidukan.com/uploads/products/1748588067_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748588067_0.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Size/Capacity":"3 Meter","Thickness Options":"75 mm, 90 mm, 110 mm, 160 mm","Properties":"Lead-free, eco-friendly, non-corrosive, lightweight, UV resistant (certain models)","Pressure Rating":"Non-pressure applications","Service Life":"50+ years","Available Sizes":"3 Meter length with multiple thickness options (75mm, 90mm, 110mm, 160mm)","MRP":"Rs. 547.5","Source":"https://www.makankidukan.com/building-product/apollo-self-fit-pipe-type-a-3-mtrs-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Self Fit Pipe Type B 3 Mtrs uPVC Pipe', 'Apollo uPVC drainage pipes designed for soil, waste, and rainwater discharge. Features include corrosion resistance, smooth bore for optimal flow, UV resistance in select models, lightweight construction, leak-proof joints, and 50+ year service life. Non-toxic, non-corrosive uPVC material ideal for underground drainage and non-pressure plumbing applications requiring minimal maintenance.

Available sizes/variants: 3 Mtr length with four thickness options (75mm, 90mm, 110mm, 160mm)

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 910, 'https://www.makankidukan.com/uploads/products/1748588272_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748588272_0.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Size/Length":"3 Meters","Thickness Options":"75 mm, 90 mm, 110 mm, 160 mm","Type":"Self Fit Pipe Type B","Service Life":"50+ years","Lead Content":"Lead-free","Application":"Drainage (soil, waste, rainwater)","Available Sizes":"3 Mtr length with four thickness options (75mm, 90mm, 110mm, 160mm)","MRP":"Rs. 910","Source":"https://www.makankidukan.com/building-product/apollo-self-fit-pipe-type-b-3-mtrs-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Self Fit Pipe Single Socket With Rubber Ring 12 ft uPVC Pipe', 'Apollo uPVC drainage pipes designed for soil, waste, and rainwater discharge. Features include corrosion resistance, smooth bore for excellent flow, lightweight construction, and leak-proof joints. Service life exceeds 50 years with minimal maintenance requirements. The pipes are non-toxic and ideal for underground drainage and non-pressure plumbing applications.

Available sizes/variants: 75 mm, 90 mm, 110 mm, 160 mm thickness options

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 690, 'https://www.makankidukan.com/uploads/products/1748588613_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748588613_0.webp','https://www.makankidukan.com/placeholder.svg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Size/Length":"12 ft","Diameter Options":"75 mm, 90 mm, 110 mm, 160 mm","Properties":"Non-corrosive, lead-free, eco-friendly, chemically resistant","UV Resistant":"Yes (certain models)","Weight Characteristic":"Lightweight","Maintenance":"Low maintenance","Service Life":"50+ years","Available Sizes":"75 mm, 90 mm, 110 mm, 160 mm thickness options","MRP":"Rs. 690","Source":"https://www.makankidukan.com/building-product/apollo-self-fit-pipe-single-socket-with-rubber-ring-12-ft-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe Double Socket Type A uPVC Pipe', 'Drainage pipes designed for soil, waste, and rainwater discharge, featuring a smooth bore design that ensures excellent flow characteristics, reducing the risk of blockage. These leak-proof pipes provide secure and reliable connections and require minimal upkeep once installed. Designed for non-pressure applications.

Available sizes/variants: 2 ft, 3 ft, 4 ft, 6 ft, 10 ft, 12 ft; thickness 75mm, 90mm, 110mm, 160mm

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 188, 'https://www.makankidukan.com/uploads/products/1748591011_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748591011_0.webp','https://www.makankidukan.com/placeholder.svg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Key Properties":"Non-corrosive, lightweight, durable, lead-free, eco-friendly","Chemical Resistance":"Resistant to chemical and biological degradation","Available Sizes":"2 ft, 3 ft, 4 ft, 6 ft, 10 ft, 12 ft; thickness 75mm, 90mm, 110mm, 160mm","Thickness Options":"75 mm, 90 mm, 110 mm, 160 mm","Service Life":"Over 50 years under normal conditions","UV Resistance":"Available for certain models","MRP":"Rs. 188","Source":"https://www.makankidukan.com/building-product/apollo-pipe-double-socket-type-a-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe Double Socket Type B uPVC Pipe', 'Drainage pipes designed for soil, waste, and rainwater discharge. Features a smooth bore construction for optimal flow characteristics and includes leak-proof joints for secure connections. The product offers corrosion resistance, lightweight construction, and minimal maintenance requirements with an expected lifespan exceeding 50 years.

Available sizes/variants: Size options: 2 ft, 3 ft, 4 ft, 6 ft, 10 ft; thickness options: 75 mm, 90 mm, 110 mm, 160 mm

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 297, 'https://www.makankidukan.com/uploads/products/1748592051_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748592051_0.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Type":"Double Socket Type B","Corrosion Resistance":"Non-corrosive, lead-free","UV Resistance":"Yes (certain models)","Service Life":"50+ years","Application":"Underground drainage, non-pressure plumbing","Available Sizes":"Size options: 2 ft, 3 ft, 4 ft, 6 ft, 10 ft; thickness options: 75 mm, 90 mm, 110 mm, 160 mm","MRP":"Rs. 297","Source":"https://www.makankidukan.com/building-product/apollo-pipe-double-socket-type-b-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe With Rubber Ring 3 Mtr Length Type A uPVC Pipe', 'Apollo uPVC drainage pipes designed for soil, waste, and rainwater discharge. Features include corrosion resistance, smooth bore construction, UV resistance (certain models), lightweight design, leak-proof joints, and 50+ year service life with minimal maintenance. The pipes are non-toxic, non-corrosive, and ideal for underground drainage and non-pressure plumbing applications.

Available sizes/variants: Thickness sizes: 75 mm, 90 mm, 110 mm, 160 mm (all in 3 Mtr length)

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 659, 'https://www.makankidukan.com/uploads/products/1748592408_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748592408_0.jpg'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Length":"3 Meter","Type":"Type A","Thickness Options":"75 mm, 90 mm, 110 mm, 160 mm","Application":"Drainage, non-pressure plumbing","Service Life":"Over 50 years","Properties":"Lead-free, eco-friendly, chemically resistant","Available Sizes":"Thickness sizes: 75 mm, 90 mm, 110 mm, 160 mm (all in 3 Mtr length)","MRP":"Rs. 659","Source":"https://www.makankidukan.com/building-product/apollo-pipe-with-rubber-ring-3-mtr-length-type-a-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Pipe With Rubber Ring 3 Mtr Length Type B uPVC Pipe', 'Apollo uPVC drainage pipes designed for soil, waste, and rainwater discharge. Features include corrosion resistance, smooth bore for optimal flow, UV resistance (select models), lightweight construction, leak-proof joints, and 50+ year lifespan with minimal maintenance. Made from rigid, chemically-resistant uPVC without plasticizers, ideal for underground drainage and non-pressure plumbing.

Available sizes/variants: 75 mm, 90 mm, 110 mm, 160 mm thickness options

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 1129, 'https://www.makankidukan.com/uploads/products/1748592750_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748592750_0.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Length":"3 Meter","Type":"Type B","Thickness Options":"75mm, 90mm, 110mm, 160mm","Properties":"Non-corrosive, lightweight, lead-free, eco-friendly","Service Life":"50+ years","Application":"Underground drainage, non-pressure plumbing","Available Sizes":"75 mm, 90 mm, 110 mm, 160 mm thickness options","MRP":"Rs. 1129","Source":"https://www.makankidukan.com/building-product/apollo-pipe-with-rubber-ring-3-mtr-length-type-b-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Self Fit Pipe 3 Mtr Length Type A uPVC Pipe', 'Apollo uPVC drainage pipes designed for soil, waste, and rainwater discharge. Features include corrosion resistance, smooth bore for optimal flow, UV resistance, lightweight construction, leak-proof joints, and a service life exceeding 50 years. The pipes are non-toxic, non-corrosive, and suitable for underground drainage and non-pressure plumbing applications with minimal maintenance requirements.

Available sizes/variants: Four thickness options (75mm, 90mm, 110mm, 160mm)

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 653, 'https://www.makankidukan.com/uploads/products/1748593095_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748593095_0.webp'], '{"Brand":"APL Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Length":"3 Meter","Type":"Type A","Available Thicknesses":"75mm, 90mm, 110mm, 160mm","Lead Content":"Lead-free","Properties":"Non-corrosive, lightweight, durable, eco-friendly","Resistance":"Chemical and biological degradation resistant","Service Life":"Over 50 years (normal conditions)","Maintenance":"Low maintenance","Available Sizes":"Four thickness options (75mm, 90mm, 110mm, 160mm)","MRP":"Rs. 653","Source":"https://www.makankidukan.com/building-product/apollo-self-fit-pipe-3-mtr-length-type-a-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Self Fit Pipe 3 Mtr Length Type B uPVC Pipe', 'Apollo uPVC drainage pipes designed for soil, waste, and rainwater discharge. Features include corrosion resistance, smooth bore for optimal flow, UV resistance in select models, lightweight construction, leak-proof joints, and a lifespan exceeding 50 years. The material is non-toxic, non-corrosive, and requires minimal maintenance once installed.

Available sizes/variants: 75 mm, 90 mm, 110 mm, 160 mm

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 1119, 'https://www.makankidukan.com/uploads/products/1748594291_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748594291_0.webp'], '{"Brand":"APOLLO","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Length":"3 Meter","Type":"Type B","Application":"Drainage/Non-pressure plumbing","Status":"In Stock","Available Sizes":"75 mm, 90 mm, 110 mm, 160 mm","MRP":"Rs. 1119","Source":"https://www.makankidukan.com/building-product/apollo-self-fit-pipe-3-mtr-length-type-b-upvc-pipe"}'::jsonb, v_sub1, 100, true),
  ('Apollo Height Raiser SWR Fitting', 'Apollo SWR (Soil, Waste & Rainwater) Drainage Pipes and Fittings are designed for efficient drainage and wastewater management in residential, commercial, agricultural, and industrial settings. Corrosion, rust, and chemical resistant; leak-proof joints with rubber ring or solvent cement; lightweight with simple jointing system; minimal noise during fluid flow; non-toxic and bacterial growth-resistant; chemical resistant for domestic and industrial use; recyclable and eco-friendly; high flow efficiency with smooth bore; impact resistant material.

Available sizes/variants: 110x50 mm

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 250, 'https://www.makankidukan.com/uploads/products/1748683468_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748683468_0.png'], '{"Brand":"Apollo","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Size/Capacity":"110x50 mm","Product Type":"Height Raiser SWR Fitting","Standards":"IS 13592 and IS 14735","Stock Status":"In Stock","Available Sizes":"110x50 mm","MRP":"Rs. 250","Source":"https://www.makankidukan.com/building-product/apollo-height-raiser-swr-fitting-self-fit-upvc-pipe-fittings"}'::jsonb, v_sub1, 100, true),
  ('Apollo Gully Trap SWR Fitting', 'Apollo SWR (Soil, Waste & Rainwater) Drainage Pipes and Fittings are designed for efficient drainage and wastewater management across residential, commercial, agricultural, and industrial applications. Features excellent resistance to corrosion, rust, chemicals, and UV rays; rubber ring or solvent cement joints ensure a leak-proof fit; non-corrosive, lightweight, durable, and lead-free; smooth inner surface minimizes noise during fluid flow; resistant to chemical and bacterial degradation; recyclable and eco-friendly.

Available sizes/variants: 160×110 mm

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 550, 'https://www.makankidukan.com/uploads/products/1748688749_0.png', ARRAY['https://www.makankidukan.com/uploads/products/1748688749_0.png'], '{"Brand":"APOLLO","Category":"SWR / uPVC Pipes & Fittings","Material":"uPVC (Unplasticized Polyvinyl Chloride)","Size/Capacity":"Common","Thickness":"160×110 mm","Standard":"IS 13592 and IS 14735","Stock Status":"In Stock","Available Sizes":"160×110 mm","MRP":"Rs. 550","Source":"https://www.makankidukan.com/building-product/apollo-gully-trap-swr-fitting-self-fit-upvc-pipe-fittings"}'::jsonb, v_sub1, 100, true),
  ('Apollo CPVC Solvent Cement Tube', 'Apollo Solvent Cement is a specially formulated adhesive designed for PVC, CPVC, or UPVC piping systems for plumbing, agriculture, and industrial uses. It bonds by softening pipe and fitting surfaces, allowing them to fuse upon curing, chemically fusing pipe and fitting for zero-leakage joints.

Available sizes/variants: 10 ml, 25 ml, 50 ml

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 48, 'https://www.makankidukan.com/uploads/products/1748691182_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748691182_0.jpg'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Primary Components":"PVC or CPVC-based resins","Solvents Used":"MEK (Methyl Ethyl Ketone), THF (Tetrahydrofuran), Cyclohexanone","Additives":"Stabilizers, viscosity modifiers, fillers","Initial Set Time":"Minutes","Full Cure Time":"Approximately 24 hours","Bond Strength":"High; suitable for pressure and non-pressure applications","Temperature Resistance":"Thermal resistant (especially CPVC variants for hot water)","Chemical Resistance":"Resistant to most household and industrial chemicals","Application Method":"Brush-on; no heating or soldering required","Available Sizes":"10 ml, 25 ml, 50 ml","MRP":"Rs. 48","Source":"https://www.makankidukan.com/building-product/apollo-cpvc-solvent-cement-tube"}'::jsonb, v_sub2, 100, true),
  ('Apollo CPVC Solvent Cement Tin', 'Apollo Solvent Cement is a specially formulated adhesive designed for PVC, CPVC, or UPVC piping systems used in plumbing, agricultural, and industrial applications. It functions by softening pipe and fitting surfaces, enabling fusion upon curing.

Available sizes/variants: 59 ml, 118 ml, 237 ml, 473 ml, 946 ml

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 165, 'https://www.makankidukan.com/uploads/products/1748691438_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748691438_0.jpg','https://www.makankidukan.com/placeholder.svg'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Base Resin":"PVC or CPVC-based","Primary Solvents":"MEK, THF, Cyclohexanone","Bond Strength":"High—suitable for pressure/non-pressure applications","Initial Set Time":"Minutes","Full Cure":"~24 hours","Thermal Resistance":"Withstands high temperatures (CPVC versions)","Chemical Resistance":"Resistant to household/industrial chemicals","Application Method":"Brush-on; no heating required","Available Sizes":"59 ml, 118 ml, 237 ml, 473 ml, 946 ml","MRP":"Rs. 165","Source":"https://www.makankidukan.com/building-product/apollo-cpvc-solvent-cement-tin"}'::jsonb, v_sub2, 100, true),
  ('Apollo PVC Solvent Cement Tube', 'Apollo Solvent Cement is a specially formulated adhesive designed for PVC, CPVC, or UPVC piping systems used in plumbing, agriculture, and industrial applications. It works by softening pipe and fitting surfaces, allowing them to fuse upon curing.

Available sizes/variants: 10 ml, 25 ml, 50 ml

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 29, 'https://www.makankidukan.com/uploads/products/1748691652_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748691652_0.webp'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Resin Base":"PVC or CPVC-based (type-dependent)","Solvents":"MEK (Methyl Ethyl Ketone), THF (Tetrahydrofuran), Cyclohexanone","Additives":"Stabilizers, viscosity modifiers, fillers","Bond Strength":"High, suitable for pressure and non-pressure applications","Set Time":"Initial set within minutes; full cure ~24 hours","Temperature Resistance":"High (especially CPVC versions for hot water)","Chemical Resistance":"Resistant to household and industrial chemicals","Application":"Brush-on; no heating or soldering needed","Available Sizes":"10 ml, 25 ml, 50 ml","MRP":"Rs. 29","Source":"https://www.makankidukan.com/building-product/apollo-pvc-solvent-cement-tube"}'::jsonb, v_sub2, 100, true),
  ('Apollo PVC Solvent Cement Tin', 'Specially formulated adhesive for PVC, CPVC, and UPVC piping in plumbing and industrial applications. It works by softening pipe surfaces to create fused joints upon curing, enabling strong, durable joints with rapid initial setting and full curing within 24 hours.

Available sizes/variants: 50 ml, 100 ml, 250 ml, 500 ml, 1 Ltr, 5 Ltr

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 90, 'https://www.makankidukan.com/uploads/products/1748691900_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1748691900_0.jpg'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Resins":"PVC or CPVC-based formulations","Solvents":"MEK (Methyl Ethyl Ketone), THF (Tetrahydrofuran), Cyclohexanone","Additives":"Stabilizers, viscosity modifiers, and fillers","Bond Strength":"High bond strength for pressure and non-pressure applications","Curing":"Quick-setting with fast initial cure","Thermal Resistance":"Especially CPVC versions for hot water","Chemical Resistance":"Chemical-resistant joints","Application":"Brush-on application requiring no heating","GST Inclusive Price":"Rs. 53.10","Return Policy":"7 days","Available Sizes":"50 ml, 100 ml, 250 ml, 500 ml, 1 Ltr, 5 Ltr","MRP":"Rs. 90","Source":"https://www.makankidukan.com/building-product/apollo-pvc-solvent-cement-tin"}'::jsonb, v_sub2, 100, true),
  ('Apollo uPVC Solvent Cement Tube', 'A specially formulated adhesive designed for PVC, CPVC, or UPVC piping systems used in plumbing, agriculture, and industrial applications. It softens pipe and fitting surfaces, enabling them to fuse upon curing, offering strong, durable joints for both pressure and non-pressure applications with fast curing—initial set within minutes, full cure typically within 24 hours.

Available sizes/variants: 25 ml; Types: UPVC (cold water piping), CPVC (hot water systems), PVC (drainage, waste, vent systems)

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 56, 'https://www.makankidukan.com/uploads/products/1748692106_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748692106_0.webp'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Size/Capacity":"25 ml","Resin Composition":"PVC or CPVC-based","Solvents":"MEK (Methyl Ethyl Ketone), THF (Tetrahydrofuran), Cyclohexanone","Additives":"Stabilizers, viscosity modifiers, fillers","Key Features":"High bond strength; leak-proof joints; chemical resistance; thermal resistance; easy brush-on application","GST Inclusive Price":"Rs. 33.04","Return Period":"7 days","Available Sizes":"25 ml; Types: UPVC (cold water piping), CPVC (hot water systems), PVC (drainage, waste, vent systems)","MRP":"Rs. 56","Source":"https://www.makankidukan.com/building-product/apollo-upvc-solvent-cement-tube"}'::jsonb, v_sub2, 100, true),
  ('Apollo uPVC Solvent Cement Tin', 'A specially formulated adhesive designed for PVC, CPVC, or UPVC piping systems. Works by softening the surfaces of the pipe and fitting, allowing them to fuse upon curing. Applications include plumbing, agriculture, and industrial uses.

Available sizes/variants: 59 ml, 118 ml, 237 ml, 473 ml, 946 ml; Types: UPVC (cold water piping), CPVC (hot water systems), PVC (drainage, waste, vent systems)

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 123, 'https://www.makankidukan.com/uploads/products/1748692352_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748692352_0.webp'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Resins":"PVC or CPVC-based","Solvents":"MEK (Methyl Ethyl Ketone), THF (Tetrahydrofuran), Cyclohexanone","Additives":"Stabilizers, viscosity modifiers, fillers","Bond Strength":"High bond strength for pressure and non-pressure applications","Curing":"Initial set within minutes; full cure in ~24 hours","Thermal Resistance":"Especially CPVC versions for hot water","Joint Quality":"Leak-proof, chemically fused joints","Chemical Resistance":"Chemical resistant","Application":"Brush-on application; no heating required","GST Inclusive Price":"Rs. 72.57","Available Sizes":"59 ml, 118 ml, 237 ml, 473 ml, 946 ml; Types: UPVC (cold water piping), CPVC (hot water systems), PVC (drainage, waste, vent systems)","MRP":"Rs. 123","Source":"https://www.makankidukan.com/building-product/apollo-upvc-solvent-cement-tin"}'::jsonb, v_sub2, 100, true),
  ('Apollo PVC Solvent Cement Plastic Bottle', 'Apollo Solvent Cement is a specially formulated adhesive designed for PVC, CPVC, or UPVC piping used in plumbing, agriculture, and industrial applications. It softens pipe and fitting surfaces to create fused joints upon curing, offering strong, durable connections suitable for both pressure and non-pressure systems, with rapid initial setting and full cure within 24 hours.

Available sizes/variants: 50 ml, 100 ml, 250 ml, 500 ml, 1 Ltr, 5 Ltr; Applications: UPVC (cold water piping), CPVC (hot water systems), PVC (drainage, waste, vent systems)

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 56, 'https://www.makankidukan.com/uploads/products/1748692577_0.webp', ARRAY['https://www.makankidukan.com/uploads/products/1748692577_0.webp'], '{"Brand":"APL Apollo","Category":"Solvent Cement","Resins":"PVC or CPVC-based (depending on type)","Solvents":"MEK (Methyl Ethyl Ketone), THF (Tetrahydrofuran), Cyclohexanone","Additives":"Stabilizers, viscosity modifiers, fillers","Bond Strength":"High bond strength with leak-proof joints","Curing":"Quick Setting: cures fast—initial set within minutes","Thermal Resistance":"Especially CPVC versions","Chemical Resistance":"Chemical resistance","Application":"Brush-on application; no heating required","GST Inclusive Price":"Rs. 33.04","Return Policy":"7 days","Available Sizes":"50 ml, 100 ml, 250 ml, 500 ml, 1 Ltr, 5 Ltr; Applications: UPVC (cold water piping), CPVC (hot water systems), PVC (drainage, waste, vent systems)","MRP":"Rs. 56","Source":"https://www.makankidukan.com/building-product/apollo-pvc-solvent-cement-plastic-bottle"}'::jsonb, v_sub2, 100, true),
  ('Apollo Life Water Tank 3 Layer', 'Apollo Life water tanks are high-quality storage tanks utilizing advanced technologies for durability, hygiene, and long-term reliability. The 3-layer construction features an outer UV-protective layer, middle insulating layer, and inner food-grade layer made from FDA-approved LLDPE.

Available sizes/variants: 2000 Ltr, 3000 Ltr, 5000 Ltr, 10,000 Ltr

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 19000, 'https://www.makankidukan.com/uploads/products/1747722613_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1747722613_0.jpg','https://www.makankidukan.com/uploads/products/1747722613_1.jpg'], '{"Brand":"APL Apollo","Category":"Water Tanks","Material":"LLDPE (Linear Low-Density Polyethylene)","Construction":"3-layer multi-layered design","Food-Grade":"Yes, FDA-approved","UV-Stabilized":"Yes","Leak-Proof":"Seamless design","Maintenance":"Low; smooth inner surface prevents algae","Eco-Friendly":"Recyclable","Return Policy":"7 days","Available Sizes":"2000 Ltr, 3000 Ltr, 5000 Ltr, 10,000 Ltr","MRP":"Rs. 19000","Source":"https://www.makankidukan.com/building-product/apollo-life-water-tank-3-layer"}'::jsonb, v_sub3, 100, true),
  ('Apollo Echo Water Tank 3 Layer', 'Multi-layered, UV-stabilized water tanks manufactured from virgin, food-grade LLDPE using roto-moulding technology. The ECHO series combines a sleek, modern appearance with robust functionality.

Available sizes/variants: 500 Ltr, 750 Ltr, 1000 Ltr, 1500 Ltr

Why choose APL Apollo:
- ISI/ASTM-compliant, extra strong and highly durable
- Corrosion, chemical and weather resistant
- Smooth bore for efficient flow
- Easy, leak-proof installation
- Long service life with minimal maintenance', 5100, 'https://www.makankidukan.com/uploads/products/1747723076_0.jpg', ARRAY['https://www.makankidukan.com/uploads/products/1747723076_0.jpg','https://www.makankidukan.com/uploads/products/1747723076_1.jpg','https://www.makankidukan.com/uploads/products/1747723076_2.jpg'], '{"Brand":"APL Apollo","Category":"Water Tanks","Material":"LLDPE (Linear Low-Density Polyethylene) - virgin, food-grade","Construction":"4-5 layer design with seamless, leak-proof construction","UV Protection":"Stabilized to prevent degradation and algae growth","Thermal Insulation":"Maintains cooler water temperatures in hot climates","Inner Layer":"Food-grade white layer for safe drinking water","Durability":"Resistant to cracks, corrosion, and environmental damage","Maintenance":"Smooth surfaces prevent dirt/microorganism buildup","Return Policy":"7 days","Available Sizes":"500 Ltr, 750 Ltr, 1000 Ltr, 1500 Ltr","MRP":"Rs. 5100","Source":"https://www.makankidukan.com/building-product/apollo-echo-water-tank-3-layer"}'::jsonb, v_sub3, 100, true);
END $$;
