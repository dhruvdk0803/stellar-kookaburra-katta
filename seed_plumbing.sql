-- First, ensure the Plumbing category exists
INSERT INTO categories (name, parent_id) VALUES 
('Plumbing', NULL) 
ON CONFLICT (name) DO NOTHING;

-- Insert subcategories under Plumbing
INSERT INTO categories (name, parent_id) VALUES 
('CPVC-X', (SELECT id FROM categories WHERE name = 'Plumbing')),
('uPVC',   (SELECT id FROM categories WHERE name = 'Plumbing')),
('UPR-C',  (SELECT id FROM categories WHERE name = 'Plumbing'))
ON CONFLICT (name, parent_id) DO NOTHING;

-- Insert subcategories under CPVC-X
INSERT INTO categories (name, parent_id) VALUES 
('Pipes', (SELECT id FROM categories WHERE name = 'CPVC-X' AND parent_id = (SELECT id FROM categories WHERE name = 'Plumbing'))),
('Fittings', (SELECT id FROM categories WHERE name = 'CPVC-X' AND parent_id = (SELECT id FROM categories WHERE name = 'Plumbing')))
ON CONFLICT (name, parent_id) DO NOTHING;

-- CPVC Technical Specifications (common for all CPVC products)
-- We'll store this in a variable for reuse
DO $$
DECLARE
  cpvc_description TEXT := 'APL Apollo CPVC-X Plumbing Pipes are manufactured as per the standards given below:

Made With
TEMPRITE®
Technology From Lubrizol
ASTM D1784 - Standard specification for rigid PolyVinyl Chloride (PVC) Compounds and Chlorinated PolyVinyl Chloride (CPVC) Compounds.
ASTM D2846/IS:15778 - Specification for Chlorinated PolyVinyl Chloride, CPVC-X Plastic Pipes for hot & cold water distribution systems.
ASTM F493 - Standard specification for Solvent Cements for Chlorinated PolyVinyl Chloride, CPVC-X Plastic Pipe & Fittings.
ASTM F441 - Standard specification for Chlorinated PolyVinyl Chloride, CPVC-X Plastic Pipe, SCH 40 & 80.
ASTM F438 - Socket-Type Chlorinated PolyVinyl Chloride Plastic Pipe Fittings SCH 40.
ASTM F439 - Socket-Type Chlorinated PolyVinyl Chloride Plastic Pipe Fittings SCH 80.

WHY SHOULD YOU CHOOSE APL APOLLO
CPVC-X Extra Strong Plumbing System?

Manufactured with TEMPRITE® CPVC Resin from Lubrizol

Smooth Flow Hydraulics with Reduced Friction Loss

ISI Certified Product

Extra Strong and Highly Durable

Leak Proof Solvent Welded Joints

Superior Heat Resistance

Excellent Chlorine & Chemical Resistance

Low Bacteria Free';
BEGIN
  -- Insert CPVC-X Pipe Products
  INSERT INTO products (
    name,
    category_id,
    subcategory,
    price,
    description,
    specs,
    images,
    image_url,
    is_active
  ) VALUES
  ('CPVC-X 1/2" 6-ft Pipe', 
   (SELECT id FROM categories WHERE name = 'Pipes' AND parent_id = (SELECT id FROM categories WHERE name = 'CPVC-X' AND parent_id = (SELECT id FROM categories WHERE name = 'Plumbing'))),
   'CPVC-X Pipes',
   120,
   cpvc_description || ' - 1/2" diameter, 6 ft length.',
   jsonb_build_object(
     'Material', 'CPVC',
     'Temperature Rating', '200°F',
     'Pressure Rating', '150 psi',
     'Color', 'Grey',
     'Diameter', '1/2"',
     'Length', '6 ft'
   ),
   '["https://via.placeholder.com/400x400.png?text=CPVC-X-Pipe-1"]',
   'https://via.placeholder.com/400x400.png?text=CPVC-X-Pipe-1',
   true),
   
  ('CPVC-X 3/4" 8-ft Pipe', 
   (SELECT id FROM categories WHERE name = 'Pipes' AND parent_id = (SELECT id FROM categories WHERE name = 'CPVC-X' AND parent_id = (SELECT id FROM categories WHERE name = 'Plumbing'))),
   'CPVC-X Pipes',
   180,
   cpvc_description || ' - 3/4" diameter, 8 ft length.',
   jsonb_build_object(
     'Material', 'CPVC',
     'Temperature Rating', '200°F',
     'Pressure Rating', '200 psi',
     'Color', 'Grey',
     'Diameter', '3/4"',
     'Length', '8 ft'
   ),
   '["https://via.placeholder.com/400x400.png?text=CPVC-X-Pipe-2"]',
   'https://via.placeholder.com/400x400.png?text=CPVC-X-Pipe-2',
   true),
   
  ('CPVC-X 1" 10-ft Pipe', 
   (SELECT id FROM categories WHERE name = 'Pipes' AND parent_id = (SELECT id FROM categories WHERE name = 'CPVC-X' AND parent_id = (SELECT id FROM categories WHERE name = 'Plumbing'))),
   'CPVC-X Pipes',
   260,
   cpvc_description || ' - 1" diameter, 10 ft length.',
   jsonb_build_object(
     'Material', 'CPVC',
     'Temperature Rating', '200°F',
     'Pressure Rating', '250 psi',
     'Color', 'Grey',
     'Diameter', '1"',
     'Length', '10 ft'
   ),
   '["https://via.placeholder.com/400x400.png?text=CPVC-X-Pipe-3"]',
   'https://via.placeholder.com/400x400.png?text=CPVC-X-Pipe-3',
   true);

  -- Insert CPVC-X Fitting Products
  INSERT INTO products (
    name,
    category_id,
    subcategory,
    price,
    description,
    specs,
    images,
    image_url,
    is_active
  ) VALUES
  ('CPVC-X 90° Elbow 1/2"', 
   (SELECT id FROM categories WHERE name = 'Fittings' AND parent_id = (SELECT id FROM categories WHERE name = 'CPVC-X' AND parent_id = (SELECT id FROM categories WHERE name = 'Plumbing'))),
   'CPVC-X Fittings',
   45,
   cpvc_description || ' - 90° elbow, 1/2" diameter.',
   jsonb_build_object(
     'Material', 'CPVC',
     'Temperature Rating', '200°F',
     'Pressure Rating', '150 psi',
     'Color', 'Grey',
     'Type', '90° Elbow',
     'Diameter', '1/2"'
   ),
   '["https://via.placeholder.com/400x400.png?text=CPVC-X-Fitting-1"]',
   'https://via.placeholder.com/400x400.png?text=CPVC-X-Fitting-1',
   true),
   
  ('CPVC-X Tee 3/4"', 
   (SELECT id FROM categories WHERE name = 'Fittings' AND parent_id = (SELECT id FROM categories WHERE name = 'CPVC-X' AND parent_id = (SELECT id FROM categories WHERE name = 'Plumbing'))),
   'CPVC-X Fittings',
   60,
   cpvc_description || ' - Tee connector, 3/4" diameter.',
   jsonb_build_object(
     'Material', 'CPVC',
     'Temperature Rating', '200°F',
     'Pressure Rating', '200 psi',
     'Color', 'Grey',
     'Type', 'Tee',
     'Diameter', '3/4"'
   ),
   '["https://via.placeholder.com/400x400.png?text=CPVC-X-Fitting-2"]',
   'https://via.placeholder.com/400x400.png?text=CPVC-X-Fitting-2',
   true),
   
  ('CPVC-X Coupling 1"', 
   (SELECT id FROM categories WHERE name = 'Fittings' AND parent_id = (SELECT id FROM categories WHERE name = 'CPVC-X' AND parent_id = (SELECT id FROM categories WHERE name = 'Plumbing'))),
   'CPVC-X Fittings',
   35,
   cpvc_description || ' - Coupling connector, 1" diameter.',
   jsonb_build_object(
     'Material', 'CPVC',
     'Temperature Rating', '200°F',
     'Pressure Rating', '250 psi',
     'Color', 'Grey',
     'Type', 'Coupling',
     'Diameter', '1"'
   ),
   '["https://via.placeholder.com/400x400.png?text=CPVC-X-Fitting-3"]',
   'https://via.placeholder.com/400x400.png?text=CPVC-X-Fitting-3',
   true);
END $$;