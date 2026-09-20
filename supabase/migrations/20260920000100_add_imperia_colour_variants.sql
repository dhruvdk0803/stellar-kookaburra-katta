-- Give each two-finish Imperia digital lock an explicit, selectable colour.
-- The linked image is used by the storefront when the customer changes colour.
UPDATE products
SET variants = '[
  {"label":"Black","price":53198,"image":"/images/ebco/ebco-10b.jpg","is_default":true,"type":"color"},
  {"label":"Anthracite","price":53198,"image":"/images/ebco/ebco-10c.jpg","is_default":false,"type":"color"}
]'::jsonb
WHERE name = 'Imperia Digital Lock IM07 | IM08'
  AND specs->>'Source' = 'ebco-digital-locks-september-2026';

UPDATE products
SET variants = '[
  {"label":"Black","price":46525,"image":"/images/ebco/ebco-11c.jpg","is_default":true,"type":"color"},
  {"label":"Anthracite","price":46525,"image":"/images/ebco/ebco-11b.jpg","is_default":false,"type":"color"}
]'::jsonb
WHERE name = 'Imperia Digital Lock IM05 | IM06'
  AND specs->>'Source' = 'ebco-digital-locks-september-2026';

UPDATE products
SET variants = '[
  {"label":"Black","price":38100,"image":"/images/ebco/ebco-13b.jpg","is_default":true,"type":"color"},
  {"label":"Copper","price":38100,"image":"/images/ebco/ebco-13c.jpg","is_default":false,"type":"color"}
]'::jsonb
WHERE name = 'Imperia Digital Lock IM01 | IM02'
  AND specs->>'Source' = 'ebco-digital-locks-september-2026';
