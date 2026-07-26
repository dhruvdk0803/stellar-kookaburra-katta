-- Plumbing visibility: ONLY APL Apollo CPVC fittings & pipes stay live.
--
-- WHAT THIS DOES
--   1. Fixes 138 product names: the earlier seeding prefixed "SWR" onto uPVC
--      AGRICULTURE / PRESSURE fittings (IS:7834), which are not SWR drainage (IS:14735).
--      Kept so the data stays correct if these ranges are re-enabled later.
--   2. Drafts EVERY Apollo and Astral product (is_active = false), then re-activates only
--      the Apollo CPVC fittings & pipes -- 117 products live, 575 drafted.
--      Drafted: all Astral products, all Apollo SWR / uPVC pipes & fittings, solvent
--      cements, water tanks and tank connectors, and sanitary / concealed valves.
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

  -- 2) Draft the whole plumbing tree (Apollo + Astral).
  UPDATE products SET is_active = false WHERE category_id = ANY(v_cats);

  -- 3) Re-activate ONLY the Apollo CPVC fittings & pipes, by Item Code.
  UPDATE products SET is_active = true
   WHERE category_id = ANY(v_cats)
     AND specs->>'Item Code' IN (
      'CMN02290W0V',
      'CMN0207010W',
      'CMN02042V',
      'UM01082V',
      'CM023301',
      'CMN02050W0V',
      'CM02311U',
      'CMN02070W0V',
      'CMN02040W',
      'CMN02270W0V',
      'CM02082V',
      'CMN02040V',
      'CMN02062V02',
      'CMN02061U0W',
      'CM02312V',
      'CMN02030V',
      'CMN02010V',
      'UM01080V',
      'CMN0205010W',
      'PMN32604',
      'CMN020401',
      'CMN02032V',
      'CMN020201',
      'CM0246010V',
      'CMN02061U01',
      'CM023101',
      'CM23300V',
      'CMN0206010W',
      'CM02311V',
      'CMN02060403',
      'CM023102',
      'CMN0206042V',
      'CM23300W',
      'CM023103',
      'UM010801',
      'CMN02071U01',
      'CMN02061V0W',
      'CMN0246010W',
      'CCMN02071V0W',
      'UM010804',
      'CMN02130V',
      'CMN02060W0V',
      'UM01081V',
      'CM02332V',
      'PMN03262V',
      'CMN02012V',
      'CMN02460101',
      'UM01231U',
      'CTP02302V',
      'CM02331U',
      'CMN02051U0W',
      'CMN0221010W',
      'CMN02071U0W',
      'CMN02200W',
      'CMN020301',
      'CMN02010W',
      'CM02220V',
      'CMN02060402',
      'CM02180V',
      'UM01080W',
      'CMN0206010V',
      'CMN02190W0V',
      'UM01081U',
      'CMN02220W',
      'CMN020803',
      'CMN02020W',
      'CMN021003',
      'CMN020101',
      'CMN02102V',
      'CM023303',
      'UM012301',
      'CMN02020V',
      'CMN02230W0V',
      'UM010803',
      'CMN021401',
      'CMN02022V',
      'CMN02060302',
      'CM233001',
      'CMN020403',
      'CMN0206032V',
      'CMN02260W',
      'CMN02140W',
      'UM010802',
      'CMN02051U01',
      'CMN020103',
      'CMN021001',
      'CMN020801',
      'CMN020303',
      'CMN0227010W',
      'CMN02030W',
      'CTP023003'
     );

  -- 4) Re-activate the Apollo CPVC products that carry no Item Code.
  UPDATE products SET is_active = true
   WHERE category_id = ANY(v_cats)
     AND name IN (
      'Apollo CPVC Pipe SCH-80, 4" (100mm) — 5 Meter',
      'Apollo CPVC Pipe SDR-13.5, 1/2" (15mm) — 3 meter',
      'Apollo CPVC Pipe SCH-40, 2-1/2" (65mm) — 5 Meter',
      'Apollo CPVC Pipe SDR-11, 1-1/2" (40mm) — 3 meter',
      'Apollo CPVC Pipe SDR-11, 2" (50mm) 3 meter',
      'Apollo CPVC Pipe SDR-11, 1-1/4" (32mm) — 3 meter',
      'Apollo CPVC Pipe SCH-80, 3" (80mm) —5 Meter',
      'Apollo CPVC Pipe SCH-80, 2-1/2" (65mm) — 3 Meter',
      'Apollo CPVC Pipe SDR-11, 1/2" (15mm) — 3 meter',
      'Apollo CPVC Pipe SCH-40, 4" (100mm) — 5 Meter',
      'Apollo CPVC Pipe SCH-40 4" (100mm) — 3 meter',
      'Apollo CPVC Pipe SDR-13.5, 2" (50mm) — 3 meter',
      'Apollo CPVC Pipe SCH-80, 2-1/2" (65mm) — 5 Meter',
      'Apollo CPVC Pipe SDR-11, 1" (25mm) —3 meter',
      'Apollo NRV (non Returnable Valve) SDR CPVC Fitting',
      'Apollo CPVC Pipe SCH-80, 3" (80mm) — 3 Meter',
      'Apollo CPVC Pipe SDR-11, 3/4" (20mm) — 3 meter',
      'Apollo CPVC Pipe SDR-13.5, 1" (25mm) — 3 meter',
      'Apollo CPVC Pipe SDR-13.5, 1-1/2" (40mm) — 3 meter',
      'Apollo CPVC Pipe SDR-13.5, 1-1/4" (32mm) — 3 meter',
      'Apollo CPVC Pipe SCH-40, 3" (80mm) — 3 meter',
      'Apollo CPVC Pipe SCH-80, 4" (100mm) — 3 Meter',
      'Apollo CPVC Pipe SCH-40, 2-1/2" (65mm) — 3 meter',
      'Apollo CPVC Pipe SCH-40, 3" (80mm) — 5 Meter',
      'Apollo CPVC Pipe SDR-13.5, 3/4" (20mm) — 3 meter'
     );

  SELECT count(*) INTO v_live  FROM products WHERE category_id = ANY(v_cats) AND is_active;
  SELECT count(*) INTO v_draft FROM products WHERE category_id = ANY(v_cats) AND NOT is_active;
  RAISE NOTICE 'Plumbing visibility: % live, % draft', v_live, v_draft;
END $BODY$;
