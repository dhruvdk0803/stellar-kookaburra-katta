-- Plumbing visibility + name corrections for the Apollo / Astral catalogue.
--
-- WHAT THIS DOES
--   1. Fixes 138 product names: the earlier seeding prefixed "SWR" onto uPVC
--      AGRICULTURE / PRESSURE fittings (IS:7834). Those are pressure fittings, not SWR
--      drainage (IS:14735), so the "SWR" token is removed and "uPVC" used instead.
--   2. Drafts every Apollo/Astral product (is_active = false), then re-activates ONLY the
--      CPVC and uPVC pressure pipes & fittings -- 454 products.
--      Hidden: SWR/drainage, solvent cements & adhesives, water tanks, tank connectors,
--      sanitary/concealed valves and their parts, and installation tools.
--
-- SCOPE GUARD: every statement is restricted to categories inside the Apollo and Astral
-- trees, so Sunmica / Louvers / Acrylic / Plywood products are NEVER touched.
-- Safe to re-run.

DO $BODY$
DECLARE
  v_apollo UUID;
  v_astral UUID;
  v_cats   UUID[];
  v_live   INT;
  v_draft  INT;
BEGIN
  SELECT id INTO v_apollo FROM categories WHERE slug = 'apollo' OR lower(name) = 'apollo' LIMIT 1;
  SELECT id INTO v_astral FROM categories WHERE slug = 'astral' OR lower(name) = 'astral' LIMIT 1;

  SELECT array_agg(id) INTO v_cats
    FROM categories
   WHERE id IN (v_apollo, v_astral)
      OR parent_id IN (v_apollo, v_astral);

  IF v_cats IS NULL THEN
    RAISE EXCEPTION 'Apollo/Astral categories not found - aborting without changes';
  END IF;

  -- 1) Correct mislabelled uPVC pressure fitting names (keyed by Item Code).
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 4"x3" (110x75mm)' WHERE specs->>'Item Code' = 'PMN0308042V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Agriculture Tee 3/4" (20mm)' WHERE specs->>'Item Code' = 'PM03740V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Female Threaded Adaptor (Fta) PN6 1-1/2" (40mm)' WHERE specs->>'Item Code' = 'PMN03111U' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Tee 8" (200x140mm)' WHERE specs->>'Item Code' = 'PM03830805' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN6 1-1/2" (40mm)' WHERE specs->>'Item Code' = 'PM03211U' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Agriculture Coupler 1" (25mm)' WHERE specs->>'Item Code' = 'PM03300W' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN4 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PMN030403' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Coupler 6 KG 4" (110mm)' WHERE specs->>'Item Code' = 'PMN32804' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN4 4" (110mm)' WHERE specs->>'Item Code' = 'PMN030404' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee 8" (200mm)' WHERE specs->>'Item Code' = 'PMN030608' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow Regular 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PMN030203' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN4 2-1/2" (63mm)' WHERE specs->>'Item Code' = 'PMN030102' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tail Piece Grey 3" (75mm)' WHERE specs->>'Item Code' = 'PT01062V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Male Adaptor Plastic Threaded 8" (200mm)' WHERE specs->>'Item Code' = 'PMN031608' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee 4 KG/CM2 W/o Collar Extra Strong 3" (75mm)' WHERE specs->>'Item Code' = 'PM03852V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Elbow 4"x3-1/2" (110X90mm)' WHERE specs->>'Item Code' = 'PMN03100403' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN4 6" (160mm)' WHERE specs->>'Item Code' = 'PMN32106' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee 6" (160mm)' WHERE specs->>'Item Code' = 'PMN030606' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Male Threaded Adaptor PN10 3/4" (20mm)' WHERE specs->>'Item Code' = 'PM03220V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Tee 8"x4" (200x110mm)' WHERE specs->>'Item Code' = 'PT01030804' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 6" (160mm)' WHERE specs->>'Item Code' = 'PT010606' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Female Threaded Adaptor PN10 3/4" (20mm)' WHERE specs->>'Item Code' = 'PM03250V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 10" (250mm)' WHERE specs->>'Item Code' = 'PT010610' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN6 ISI 2-1/2" (63mm)' WHERE specs->>'Item Code' = 'PM030602' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Female Threaded Adaptor (Fta) PN6 2-1/2" (63mm)' WHERE specs->>'Item Code' = 'PMN31102' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Female Threaded Adaptor (Fta) PN6 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PMN031103' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Male Adaptor Plastic Threaded 6" (160mm)' WHERE specs->>'Item Code' = 'PM031606' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN6 ISI 1-1/2" (40mm)' WHERE specs->>'Item Code' = 'PMN03031U' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Tee 10"x6" (250x160mm)' WHERE specs->>'Item Code' = 'PM03831006' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN6 ISI 1-1/2" (40mm)' WHERE specs->>'Item Code' = 'PMN03061U' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee (140mm)' WHERE specs->>'Item Code' = 'PMN030605' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee 4 KG/CM2 W/o Collar Extra Strong 2-1/2" (63mm)' WHERE specs->>'Item Code' = 'PM038502' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN10 3/4" (20mm)' WHERE specs->>'Item Code' = 'PM03310V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Bush 4"x3-1/2" (110x90mm)' WHERE specs->>'Item Code' = 'PMN3270403' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Pipe Clamp 3" (75mm)' WHERE specs->>'Item Code' = 'PMN03122V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Coupler 6 KG 6" (160mm)' WHERE specs->>'Item Code' = 'PMN032806' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN6 ISI 4" (110mm)' WHERE specs->>'Item Code' = 'PMN030304' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Agriculture Ball Valve 1" (25mm)' WHERE specs->>'Item Code' = 'PM03730W' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee 4 KG/CM2 W/o Collar Extra Strong 4" (110mm)' WHERE specs->>'Item Code' = 'PM038504' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 3"x3/4" (75X20mm)' WHERE specs->>'Item Code' = 'PM03152V0V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 4" (140x110mm)' WHERE specs->>'Item Code' = 'PMN3080504' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN6 ISI 3" (75mm)' WHERE specs->>'Item Code' = 'PMN03062V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Coupler 6 KG 2-1/2" (63mm)' WHERE specs->>'Item Code' = 'PMN32802' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee Regular 3" (75mm)' WHERE specs->>'Item Code' = 'PMN03052V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Agriculture Tee 1-1/4" (32mm)' WHERE specs->>'Item Code' = 'PM037401' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Coupler 6 KG 1-1/2" (40mm)' WHERE specs->>'Item Code' = 'PM03281U' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 3"x1" (75X25mm)' WHERE specs->>'Item Code' = 'PM03152V0W' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Male Threaded Adaptor (Mta) PN6 1-1/2" (40mm)' WHERE specs->>'Item Code' = 'PM03121U' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN10 4" (110mm)' WHERE specs->>'Item Code' = 'PMN37404' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow 4 KG/CM W/o Collar Extra Strong 4" (110mm)' WHERE specs->>'Item Code' = 'PM039603' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Female Threaded Adaptor PN10 1" (25mm)' WHERE specs->>'Item Code' = 'PM03250W' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Tee 2-1/2"x1-1/4" (63X32mm)' WHERE specs->>'Item Code' = 'PM03820201' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN10 1" (25mm)' WHERE specs->>'Item Code' = 'PM03310W' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 2-1/2"x3/4" (63X20mm)' WHERE specs->>'Item Code' = 'PM0315020V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Ball Valve 8" (200mm)' WHERE specs->>'Item Code' = 'PT010208' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN6 ISI 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PMN030303' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 2-1/2"x1-1/4" (63X32mm)' WHERE specs->>'Item Code' = 'PM03150201' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 4"x2-1/2" (110x63mm)' WHERE specs->>'Item Code' = 'PMN3080402' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC PN4 End Cap (140mm)' WHERE specs->>'Item Code' = 'PMN32105' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Agriculture Coupler 3/4" (20mm)' WHERE specs->>'Item Code' = 'PM03300V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Ball Valve (180mm)' WHERE specs->>'Item Code' = 'PM030307' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Female Threaded Adaptor (Fta) PN6 1-1/4" (32mm)' WHERE specs->>'Item Code' = 'PM031101' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 3"x2-1/2" (75x63mm)' WHERE specs->>'Item Code' = 'PMN03082V02' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee Regular 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PMN030503' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN6 ISI 3" (75mm)' WHERE specs->>'Item Code' = 'PMN03032V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN4 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PMN030103' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN6 6" (160mm)' WHERE specs->>'Item Code' = 'PT010506' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Female Threaded Adaptor (Fta) PN6 4" (110mm)' WHERE specs->>'Item Code' = 'PMN031104' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN6 2-1/2" (63mm)' WHERE specs->>'Item Code' = 'PMN32902' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow 4 KG/CM W/o Collar Extra Strong 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PM03962V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 2-1/2"x1" (63X25mm)' WHERE specs->>'Item Code' = 'PM0315020W' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN6 ISI 2" (50mm)' WHERE specs->>'Item Code' = 'PMN03031V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Bush 4" (110mm)' WHERE specs->>'Item Code' = 'PT010704' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Coupler 6 KG 3" (75mm)' WHERE specs->>'Item Code' = 'PMN03282V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN10 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PMN37403' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Tee 1-1/2"x3/4" (40X20mm)' WHERE specs->>'Item Code' = 'PM03821U0V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN4 2-1/2" (63mm)' WHERE specs->>'Item Code' = 'PMN32102' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 3-1/2"x2-1/2" (90x63mm)' WHERE specs->>'Item Code' = 'PMN3080302' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Female Threaded Adaptor (Fta) PN6 3" (75mm)' WHERE specs->>'Item Code' = 'PMN03112V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN10 1-1/4" (32mm)' WHERE specs->>'Item Code' = 'PM033101' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN6 ISI 2-1/2" (63mm)' WHERE specs->>'Item Code' = 'PM030302' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN4 1-1/2" (40mm)' WHERE specs->>'Item Code' = 'PMN03041U' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN4 3" (75mm)' WHERE specs->>'Item Code' = 'PMN03042V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tail Piece Grey 4" (110mm)' WHERE specs->>'Item Code' = 'PT010604' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN4 2" (50mm)' WHERE specs->>'Item Code' = 'PMN03041V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN4 8" (200mm)' WHERE specs->>'Item Code' = 'PMN32108' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Coupler 6 KG 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PMN32803' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN4 3" (75mm)' WHERE specs->>'Item Code' = 'PMN03012V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN4 2" (50mm)' WHERE specs->>'Item Code' = 'PMN03011V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN10 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PMN37303' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 4"x3-1/2" (110x90mm)' WHERE specs->>'Item Code' = 'PMN3080403' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Bush 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PT010703' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN4 4" (110mm)' WHERE specs->>'Item Code' = 'PMN032104' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Male Threaded Adaptor PN10 1-1/4" (32mm)' WHERE specs->>'Item Code' = 'PM032201' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Ball Valve 1-1/4" (32mm)' WHERE specs->>'Item Code' = 'PM037301' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN6 2" (50mm)' WHERE specs->>'Item Code' = 'PM03211V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee 10" (250mm)' WHERE specs->>'Item Code' = 'PM030610' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Elbow 3-1/2"x2-1/2" (90X63mm)' WHERE specs->>'Item Code' = 'PM03800302' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Tee 8"x6" (200x160mm)' WHERE specs->>'Item Code' = 'PT01030806' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN4 1-1/2" (40mm)' WHERE specs->>'Item Code' = 'PMN03011U' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC PN4 End Cap (180mm)' WHERE specs->>'Item Code' = 'PM032107' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap (225mm)' WHERE specs->>'Item Code' = 'PMN32109' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN6 ISI 4" (110mm)' WHERE specs->>'Item Code' = 'PMN030604' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow Regular 4" (110mm)' WHERE specs->>'Item Code' = 'PMN030204' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Tee 1-1/2"x1" (40X25mm)' WHERE specs->>'Item Code' = 'PM03821U0W' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN4 2-1/2" (63mm)' WHERE specs->>'Item Code' = 'PMN030402' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 3-1/2"x3" (90x75mm)' WHERE specs->>'Item Code' = 'PMN0308032V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN4 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PMN32103' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Agriculture Coupler 1-1/4" (32mm)' WHERE specs->>'Item Code' = 'PM033001' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Male Threaded Adaptor PN10 1" (25mm)' WHERE specs->>'Item Code' = 'PM03220W' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Male Adaptor Plastic Threaded (140mm)' WHERE specs->>'Item Code' = 'PM031605' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Elbow 6"x4" (160X110mm)' WHERE specs->>'Item Code' = 'PM03800604' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Tee 1" (25mm)' WHERE specs->>'Item Code' = 'PM0379010W' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN6 3" (75mm)' WHERE specs->>'Item Code' = 'PMN03292V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Male Threaded Adaptor (Mta) PN6 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PMN31203' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Ball Valve 10" (250mm)' WHERE specs->>'Item Code' = 'PM030310' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN10 4" (110mm)' WHERE specs->>'Item Code' = 'PMN37304' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Tee 4"x2-1/2" (110x63mm)' WHERE specs->>'Item Code' = 'PMN03090402' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tail Piece Grey 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PT010603' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Bush 6"x4" (160x110mm)' WHERE specs->>'Item Code' = 'PMN3270604' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Elbow 4"x2-1/2" (110X63mm)' WHERE specs->>'Item Code' = 'PM03800402' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Male Threaded Adaptor (Mta) PN6 2-1/2" (63mm)' WHERE specs->>'Item Code' = 'PMN31202' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN6 ISI 2" (50mm)' WHERE specs->>'Item Code' = 'PMN03061V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 6"x4" (160x110mm)' WHERE specs->>'Item Code' = 'PMN03080604' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee PN6 ISI 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PMN030603' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN4 5" (125mm)' WHERE specs->>'Item Code' = 'PMN03214V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow Regular 3" (75mm)' WHERE specs->>'Item Code' = 'PMN03022V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Coupler 6 KG 2" (50mm)' WHERE specs->>'Item Code' = 'PM03281V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Female Threaded Adaptor (Fta) PN6 2" (50mm)' WHERE specs->>'Item Code' = 'PMN03111V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow 4 KG/CM W/o Collar Extra Strong 3" (75mm)' WHERE specs->>'Item Code' = 'PM039602' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Male Threaded Adaptor (Mta) PN6 4" (110mm)' WHERE specs->>'Item Code' = 'PMN031204' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Coupler 3"x1-1/4" (75X32mm)' WHERE specs->>'Item Code' = 'PM03152V01' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC End Cap PN4 3" (75mm)' WHERE specs->>'Item Code' = 'PMN03212V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Tee 4 KG/CM2 W/o Collar Extra Strong 3-1/2" (90mm)' WHERE specs->>'Item Code' = 'PM038503' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Elbow PN4 4" (110mm)' WHERE specs->>'Item Code' = 'PMN030104' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Agriculture Ball Valve 3/4" (20mm)' WHERE specs->>'Item Code' = 'PM03730V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Reducing Tee PN4 4"x3" (110x75mm)' WHERE specs->>'Item Code' = 'PMN0309042V' AND category_id = ANY(v_cats);
  UPDATE products SET name = 'Apollo uPVC Agriculture Tee 1" (25mm)' WHERE specs->>'Item Code' = 'PM03740W' AND category_id = ANY(v_cats);

  -- 2) Draft the whole plumbing tree.
  UPDATE products SET is_active = false WHERE category_id = ANY(v_cats);

  -- 3) Re-activate the CPVC / uPVC pressure products by Item Code.
  UPDATE products SET is_active = true
   WHERE category_id = ANY(v_cats)
     AND specs->>'Item Code' IN (
      'PMN0308042V',
      'CMN02281U',
      'PM03740V',
      'UM01010W',
      'CMN02290W0V',
      'CMN0207010W',
      'UM0111042V',
      'UM01021U',
      'UM010404',
      'UM01192V',
      'PMN03111U',
      'CMN02042V',
      'UM0112021V',
      'UM011901',
      'PM03830805',
      'PM03211U',
      'UM01082V',
      'UM010103',
      'PM03300W',
      'PMN030403',
      'PMN32804',
      'UMN01150W0V',
      'UM010104',
      'CM023301',
      'PMN030404',
      'PMN030608',
      'UM01121V01',
      'PMN030203',
      'PMN030102',
      'PT01062V',
      'CMN02050W0V',
      'UM0111010W',
      'CM02311U',
      'CMN02070W0V',
      'UM01120W0V',
      'CMN02040W',
      'CMN02270W0V',
      'PMN031608',
      'UM01031U',
      'UM01112V02',
      'PM03852V',
      'PMN03100403',
      'CM02082V',
      'CMN02040V',
      'CMN02062V02',
      'PMN32106',
      'UM010703',
      'CMN02061U0W',
      'CM02312V',
      'UM01062V',
      'CMN02030V',
      'CMN02010V',
      'UM01060V',
      'PMN030606',
      'PM03220V',
      'PT01030804',
      'PT010606',
      'UM010204',
      'UM012004',
      'UM01080V',
      'CMN0205010W',
      'PMN32604',
      'UM010403',
      'UM01191U',
      'CMN020401',
      'CMN02032V',
      'PM03250V',
      'PT010610',
      'CMN020201',
      'UM01072V',
      'UM01111U01',
      'UMN0115010V',
      'PM030602',
      'PMN31102',
      'UM01040V',
      'PMN031103',
      'CM0246010V',
      'PM031606',
      'PMN03031U',
      'CMN02061U01',
      'UM010302',
      'UM01021V',
      'UM010301',
      'PM03831006',
      'CM023101',
      'PMN03061U',
      'PMN030605',
      'CM23300V',
      'CMN0206010W',
      'UM01202V',
      'PM038502',
      'CM02311V',
      'UTP012203',
      'PM03310V',
      'PMN3270403',
      'CMN02060403',
      'UMN011501W0W',
      'UM01040W',
      'UM010704',
      'UM0111021V',
      'PMN03122V',
      'UMN01160101',
      'UM01120201',
      'PMN032806',
      'CM023102',
      'CMN0206042V',
      'PMN030304',
      'CM23300W',
      'PM03730W',
      'UM01191V',
      'CM023103',
      'PM038504',
      'UM01011V',
      'UM0110010W',
      'PM03152V0V',
      'UM01030W',
      'PMN3080504',
      'UM010801',
      'PMN03062V',
      'CMN02071U01',
      'CMN02061V0W',
      'CMN02282V',
      'PMN32802',
      'CMN0246010W',
      'UM01190W',
      'PMN03052V',
      'UM01110201',
      'CCMN02071V0W',
      'CMN022803',
      'UMN01140W0V',
      'PM037401',
      'PM03281U',
      'UM010804',
      'PM03152V0W',
      'PM03121U',
      'PMN37404',
      'CMN022801',
      'PM039603',
      'PM03250W',
      'PM03820201',
      'PM03310W',
      'PM0315020V',
      'PT010208',
      'CMN02130V',
      'PMN030303',
      'PM03150201',
      'UM01110402',
      'UMN01160W0W',
      'UM010603',
      'CMN02060W0V',
      'PMN3080402',
      'UM01081V',
      'UM010604',
      'PMN32105',
      'PM03300V',
      'UM0112010V',
      'CM02332V',
      'PMN03262V',
      'PM030307',
      'UM01042V',
      'UM01022V',
      'UM01121V0W',
      'UM0109010W',
      'CMN02012V',
      'PM031101',
      'PMN03082V02',
      'UM01032V',
      'UM01070V',
      'UM010202',
      'PMN030503',
      'UM01110403',
      'UM0112010W',
      'CMN02460101',
      'PMN03032V',
      'UM010101',
      'PMN030103',
      'UM01090W0V',
      'UM01182V',
      'UM01190V',
      'UMN012201',
      'PT010506',
      'PMN031104',
      'PMN32902',
      'UM01231U',
      'CTP02302V',
      'CM02331U',
      'CMN02051U0W',
      'PM03962V',
      'CMN0221010W',
      'PM0315020W',
      'PMN03031V',
      'UM0111032V',
      'PT010704',
      'CMN02071U0W',
      'UM01060W',
      'UM0110010V',
      'UMN01160W0V',
      'PMN03282V',
      'UM01011U',
      'UMN01140W',
      'CMN02200W',
      'CMN020301',
      'PMN37403',
      'PM03821U0V',
      'CMN02010W',
      'CM02220V',
      'PMN32102',
      'CMN02060402',
      'CM02180V',
      'UM01080W',
      'PMN3080302',
      'PMN03112V',
      'UM01012V',
      'PM033101',
      'CMN0206010V',
      'PM030302',
      'UM010201',
      'PMN03041U',
      'UM01030V',
      'PMN03042V',
      'UM0109010V',
      'CMN02190W0V',
      'UM01020W',
      'UMN01220V',
      'PT010604',
      'UM01081U',
      'CMN02280W',
      'PMN03041V',
      'PMN32108',
      'CMN02220W',
      'PMN32803',
      'PMN03012V',
      'PMN03011V',
      'PMN37303',
      'CMN020803',
      'UM01111V01',
      'PMN3080403',
      'CMN02020W',
      'UMN0116010V',
      'UTP01222V',
      'PT010703',
      'PMN032104',
      'PM032201',
      'PM037301',
      'CMN021003',
      'UM011804',
      'CMN020101',
      'CMN02102V',
      'CM023303',
      'UM012301',
      'PM03211V',
      'PM030610',
      'PM03800302',
      'CMN02020V',
      'PT01030806',
      'UMN01150101',
      'UM011904',
      'CMN02230W0V',
      'UM010303',
      'PMN03011U',
      'PM032107',
      'PMN32109',
      'PMN32603',
      'PMN030604',
      'UM010203',
      'UM010803',
      'UM01020V',
      'UM01110302',
      'CMN021401',
      'UM010304',
      'CMN02022V',
      'PMN030204',
      'PM03821U0W',
      'PMN030402',
      'CMN02060302',
      'PMN0308032V',
      'CM233001',
      'PMN32103',
      'PM033001',
      'UM01100W0V',
      'CMN020403',
      'PM03220W',
      'CMN0206032V',
      'CMN02260W',
      'PM031605',
      'PM03800604',
      'PM0379010W',
      'PMN03292V',
      'UTP012204',
      'PMN31203',
      'PM030310',
      'PMN37304',
      'PMN03090402',
      'CMN02140W',
      'PT010603',
      'PMN3270604',
      'PM03800402',
      'UM010802',
      'CMN02051U01',
      'CMN020103',
      'UMN01150V',
      'PMN31202',
      'PMN03061V',
      'UMN01220W',
      'PMN03080604',
      'UM011903',
      'UM01031V',
      'PMN030603',
      'CMN021001',
      'PMN03214V',
      'UM01091U01',
      'UM010102',
      'UM0111010V',
      'CMN020801',
      'UM01110W0V',
      'PMN03022V',
      'PM03281V',
      'PMN03111V',
      'CMN020303',
      'UM011902',
      'CMN0227010W',
      'PM039602',
      'PMN031204',
      'PM03152V01',
      'UM01010V',
      'PMN03212V',
      'PM038503',
      'CMN02030W',
      'CTP023003',
      'UMN01160V',
      'PMN030104',
      'PM03730V',
      'PMN0309042V',
      'PM03740W'
     );

  -- 4) Re-activate the remaining CPVC / uPVC products that carry no Item Code.
  UPDATE products SET is_active = true
   WHERE category_id = ANY(v_cats)
     AND name IN (
      'Astral Pipe Brass Fpt X Soc Elbow 90 Degree',
      'Astral True Union Ind Ball Check Soc Epdm CPVC',
      'Apollo CPVC Pipe SCH-80, 4" (100mm) — 5 Meter',
      'Apollo CPVC Pipe SDR-13.5, 1/2" (15mm) — 3 meter',
      'Astral Pipe Elbow 45 Degree - Soc CPVC Pipes Fittings',
      'Apollo CPVC Pipe SCH-40, 2-1/2" (65mm) — 5 Meter',
      'Astral Pipe Tee Holder CPVC Pipes Fitting',
      'Astral Pipe Male Ext. Brass- Thd X Soc Elbow 90 Degree',
      'Astral Female Adaptor Brass Thd X Soc CPVC Schedule - 80',
      'Astral End Cap Schedule-40',
      'Astral Pipe Wheel Type Valve CPVC Pipes Fitting',
      'Astral Pipe Tee - Soc CPVC Pipes Fittings',
      'Astral Pipe Ball Valve Long Handle Cts Socket CPVC Pipes Fitting',
      'Astral Pipe Brass Fpt - Soc Tee',
      'Astral End Cap - Soc CPVC Schedule - 80',
      'Astral Pipe SDR - 13.5 CPVC Pipes',
      'Astral Pipe Male Adaptor (brass Thd X Soc)',
      'Astral Reducer Coupler Schedule-40',
      'Astral Pipe End Cap - Soc CPVC Pipes Fittings',
      'Astral True Union Ball Valve Soc Epdm CPVC Schedule - 80',
      'Astral Pipe Reducer Male Adapter CPVC (thd*soc)',
      'Apollo CPVC Pipe SDR-11, 1-1/2" (40mm) — 3 meter',
      'Astral Flange - Soc One Piece CPVC Schedule - 80',
      'Astral NRV - Soc CPVC Schedule - 80',
      'Apollo CPVC Pipe SDR-11, 2" (50mm) 3 meter',
      'Astral Pipe Union - Soc CPVC Pipes Fitting',
      'Astral Pipe Brass- Thd X Soc Elbow With Clamp',
      'Apollo CPVC Pipe SDR-11, 1-1/4" (32mm) — 3 meter',
      'Astral Pipe Reducer Coupler (brass Thd X Soc)',
      'Astral Pipe Male Brass Tee - Thd X Soc',
      'Apollo CPVC Pipe SCH-80, 3" (80mm) —5 Meter',
      'Astral Male Union (brass Thd X Soc)',
      'Astral Pipe Cross - Soc CPVC Pipes Fittings',
      'Astral Pipe Reducer Male Adaptor (brass Thd X Soc)',
      'Apollo CPVC Pipe SCH-80, 2-1/2" (65mm) — 3 Meter',
      'Astral Pipe Reducer Tee -soc(ips*cts)',
      'Astral Pipe Reducer Bushing Spg X Soc CPVC Schedule-40 Pipes Fitting',
      'Astral Long Radius Bend Socket',
      'Astral Pipe Female Adapter CPVC (thd*soc)',
      'Astral Water Butterfly Valve Viton With Handle CPVC',
      'Astral Flange Hub - Soc CPVC Schedule - 80',
      'Astral Male Adaptor Brass Thd X Soc CPVC Schedule - 80',
      'Astral Pipe End Plug Threaded CPVC Pipes Fitting',
      'Astral Tee - Soc CPVC Schedule - 80',
      'Astral Pipe Transition Coupler - Soc (ips X Cts)',
      'Apollo Pipe Double Socket Type B uPVC Pipe',
      'Astral Pipe Elbow 90 Degree - Soc CPVC Pipes Fittings',
      'Astral Pipe Brass Pipe (c.p.) Long CPVC Pipes Fitting',
      'Apollo CPVC Pipe SDR-11, 1/2" (15mm) — 3 meter',
      'Astral Pipe Female Adaptor (brass Thd X Soc)',
      'Astral Reducer Tee Soc Schedule-40',
      'Astral Reducer Tee - Soc CPVC Schedule - 80',
      'Astral Pipe Male Adapter CPVC (thd*soc)',
      'Astral Pipe Schedule 80 CPVC Pipes',
      'Astral Pipe Elbow 90 Degree 3-way - Soc',
      'Apollo CPVC Pipe SCH-40, 4" (100mm) — 5 Meter',
      'Astral Pipe Schedule 40 CPVC Pipes',
      'Astral Pipe Coupler - Soc CPVC Pipes Fittings',
      'Astral Pipe Ball Valve Handle CPVC Pipes Fitting',
      'Astral Flange Ring - Soc CPVC Schedule - 80',
      'Astral Pipe Brass Pipe (c.p.) Short CPVC Pipes Fitting',
      'Astral Reducer Coupler - Soc CPVC Schedule - 80',
      'Astral Coupler -soc CPVC Schedule - 80',
      'Apollo CPVC Pipe SCH-40 4" (100mm) — 3 meter',
      'Astral Ball Valve Cts Socket',
      'Astral Elbow 90° Soc Schedule-40',
      'Apollo Pipe Double Socket Type A uPVC Pipe',
      'Apollo CPVC Pipe SDR-13.5, 2" (50mm) — 3 meter',
      'Astral Elbow 90 Degree - Soc CPVC Schedule - 80',
      'Apollo CPVC Pipe SCH-80, 2-1/2" (65mm) — 5 Meter',
      'Apollo CPVC Pipe SDR-11, 1" (25mm) —3 meter',
      'Astral Pipe Vanstone Flange - Soc',
      'Astral Pipe SDR - 11 CPVC Pipes',
      'Astral Flange Hub - Spg CPVC Schedule - 80',
      'Astral Step Over Bend',
      'Apollo NRV (non Returnable Valve) SDR CPVC Fitting',
      'Astral Pipe Reducer Tee - Soc',
      'Astral Union - Soc CPVC Schedule - 80',
      'Apollo CPVC Pipe SCH-80, 3" (80mm) — 3 Meter',
      'Astral Pipe Reducer Coupler - Soc',
      'Astral Pipe Transition Bushing- Spg*soc(ips*cts)',
      'Astral Pipe Coupler Soc CPVC Schedule-40 Pipes Fitting',
      'Astral Pipe Elbow 90 Degree 4-way - Soc',
      'Astral Female Union (brass Thd X Soc)',
      'Astral Pipe Female Ext. Brass- Thd X Soc Elbow 90 Degree',
      'Astral Pipe Reducer Bushing (spg*soc)',
      'Apollo CPVC Pipe SDR-11, 3/4" (20mm) — 3 meter',
      'Astral Pipe Transition Reducer Coupler - Soc (ips X Cts)',
      'Astral Long Radius Bend',
      'Astral Pipe Wye Strainer CPVC Pipes Fitting',
      'Astral True Union Ind Ball Valve Soc Epdm CPVC',
      'Astral Pipe Reducer Elbow 90 Degree - Soc',
      'Astral Male Adaptor Thd X Soc CPVC Schedule - 80',
      'Astral Pipe Ball Valve Long Handle CPVC Pipes Fitting',
      'Apollo CPVC Pipe SDR-13.5, 1" (25mm) — 3 meter',
      'Apollo CPVC Pipe SDR-13.5, 1-1/2" (40mm) — 3 meter',
      'Apollo CPVC Pipe SDR-13.5, 1-1/4" (32mm) — 3 meter',
      'Astral Vanstone Flange Spg CPVC Schedule - 80',
      'Astral Pipe Reducer Female Adapter CPVC (thd*soc)',
      'Astral Reducer Bushing Spg X Soc CPVC Schedule - 80',
      'Astral Pipe Sweep Bend With Both Side Socket CPVC Pipes Fitting',
      'Apollo CPVC Pipe SCH-40, 3" (80mm) — 3 meter',
      'Apollo CPVC Pipe SCH-80, 4" (100mm) — 3 Meter',
      'Astral Pipe Tee Soc CPVC Schedule-40 Pipes Fitting',
      'Astral Long Radius Bend - Soc CPVC Schedule - 80',
      'Apollo CPVC Pipe SCH-40, 2-1/2" (65mm) — 3 meter',
      'Apollo CPVC Pipe SCH-40, 3" (80mm) — 5 Meter',
      'Apollo CPVC Pipe SDR-13.5, 3/4" (20mm) — 3 meter',
      'Astral Pipe Step Over Bend L CPVC Pipes Fitting',
      'Astral Female Adaptor Thd X Soc CPVC Schedule - 80',
      'Astral Hex Nipple Thd X Thd CPVC Schedule - 80',
      'Astral Blind Flange CPVC Schedule - 80',
      'Astral Pipe Elbow Holder CPVC Pipes Fitting',
      'Astral Water Butterfly Valve Epdm With Handle CPVC',
      'Astral Pipe S.s. Flange With Rubber Gromet CPVC Pipes Fitting',
      'Astral Cross - Soc CPVC Schedule - 80',
      'Astral Elbow 45 Degree - Soc CPVC Schedule - 80',
      'Astral Flange Rubber Gasket CPVC Schedule - 80',
      'Astral Vanstone Flange - Soc CPVC Schedule - 80'
     );

  SELECT count(*) INTO v_live  FROM products WHERE category_id = ANY(v_cats) AND is_active;
  SELECT count(*) INTO v_draft FROM products WHERE category_id = ANY(v_cats) AND NOT is_active;
  RAISE NOTICE 'Plumbing visibility: % live, % draft', v_live, v_draft;
END $BODY$;
