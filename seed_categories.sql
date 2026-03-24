-- 1. Insert Main Categories
INSERT INTO public.categories (id, name, slug, parent_id) VALUES 
('11111111-1111-1111-1111-111111111111', 'Sunmica', 'sunmica', NULL),
('22222222-2222-2222-2222-222222222222', 'Louvers/Panels', 'louvers-panels', NULL),
('33333333-3333-3333-3333-333333333333', 'Acrylic', 'acrylic', NULL);

-- 2. Insert Sunmica Subcategories
INSERT INTO public.categories (id, name, slug, parent_id) VALUES 
(gen_random_uuid(), 'Thermoluxe', 'thermoluxe', '11111111-1111-1111-1111-111111111111'),
(gen_random_uuid(), 'Rockstar', 'rockstar', '11111111-1111-1111-1111-111111111111'),
(gen_random_uuid(), 'Doorskin', 'doorskin', '11111111-1111-1111-1111-111111111111'),
(gen_random_uuid(), 'Pastel', 'pastel', '11111111-1111-1111-1111-111111111111');

-- 3. Insert Louvers/Panels Subcategories
INSERT INTO public.categories (id, name, slug, parent_id) VALUES 
(gen_random_uuid(), 'Charcoal Louvers', 'charcoal-louvers', '22222222-2222-2222-2222-222222222222'),
(gen_random_uuid(), 'Flexible Interlocking', 'flexible-interlocking', '22222222-2222-2222-2222-222222222222'),
(gen_random_uuid(), 'MDF Louvers', 'mdf-louvers', '22222222-2222-2222-2222-222222222222'),
(gen_random_uuid(), 'Pastel Louvers', 'pastel-louvers', '22222222-2222-2222-2222-222222222222');

-- 4. Insert Acrylic Subcategories
INSERT INTO public.categories (id, name, slug, parent_id) VALUES 
(gen_random_uuid(), 'Fluted Acrylic', 'fluted-acrylic', '33333333-3333-3333-3333-333333333333');