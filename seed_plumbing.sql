INSERT INTO categories (name, parent_id) VALUES 
('Plumbing', NULL) 
RETURNING id;  -- this will give us the newly created category id (we’ll use it below)

-- -------------------------------------------------
-- 1️⃣  Insert the sub‑categories under “Plumbing”
-- -------------------------------------------------
INSERT INTO categories (name, parent_id) VALUES 
('CPVC-X', (SELECT id FROM categories WHERE name = 'Plumbing')),
('uPVC',   (SELECT id FROM categories WHERE name = 'Plumbing')),
('UPR-C',  (SELECT id FROM categories WHERE name = 'Plumbing'))
RETURNING id, name;

-- -------------------------------------------------
-- 2️⃣  Insert sample products under the CPVC‑X sub‑category
-- -------------------------------------------------
-- First, find the id of the CPVC‑X sub‑category we just created
INSERT INTO categories (name, parent_id) 
SELECT 'CPVC-X', id FROM categories WHERE name = 'Plumbing' 
LIMIT 1;

-- Now insert a handful of CPVC‑X products.
-- Replace the placeholder image URLs with the real ones you have in the
-- `public/images/products/...` folder (they’re already in your repo).

INSERT INTO products (
    name,
    category_id,
    subcategory,          -- free‑form text you can use for filtering
    price,
    description,
    specs,
    images,
    image_url,
    is_active
) VALUES
-- Product 1
('CPVC-X 1/2" 6‑ft Pipe', 
 (SELECT id FROM categories WHERE name = 'CPVC-X' AND parent_id = (SELECT id FROM categories WHERE name = 'Plumbing')),
 'CPVC-X',
 120,
 'High‑pressure rated CPVC pipe, 1/2" diameter, 6 ft length.',
 jsonb_build_object(
   'Material', 'CPVC',
   'Temperature Rating', '200°F',
   'Pressure Rating', '150 psi',
   'Color', 'Grey'
 ),
 '["https://via.placeholder.com/400x400.png?text=CPVC-X-1"]',
 'https://via.placeholder.com/400x400.png?text=CPVC-X-1',
 true),

-- Product 2
('CPVC-X 3/4" 8‑ft Pipe', 
 (SELECT id FROM categories WHERE name = 'CPVC-X' AND parent_id = (SELECT id FROM categories WHERE name = 'Plumbing')),
 'CPVC-X',
 180,
 'Heavy‑duty CPVC pipe, 3/4" diameter, 8 ft length.',
 jsonb_build_object(
   'Material', 'CPVC',
   'Temperature Rating', '200°F',
   'Pressure Rating', '200 psi',
   'Color', 'Grey'
 ),
 '["https://via.placeholder.com/400x400.png?text=CPVC-X-2"]',
 'https://via.placeholder.com/400x400.png?text=CPVC-X-2',
 true),

-- Product 3
('CPVC-X 1" 10‑ft Pipe', 
 (SELECT id FROM categories WHERE name = 'CPVC-X' AND parent_id = (SELECT id FROM categories WHERE name = 'Plumbing')),
 'CPVC-X',
 260,
 'Large‑diameter CPVC pipe, 1" diameter, 10 ft length.',
 jsonb_build_object(
   'Material', 'CPVC',
   'Temperature Rating', '200°F',
   'Pressure Rating', '250 psi',
   'Color', 'Grey'
 ),
 '["https://via.placeholder.com/400x400.png?text=CPVC-X-3"]',
 'https://via.placeholder.com/400x400.png?text=CPVC-X-3',
 true)

ON CONFLICT (id) DO NOTHING;  -- safety net if you run the script again