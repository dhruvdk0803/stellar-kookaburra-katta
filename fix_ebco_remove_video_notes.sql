-- Remove "Demo Video" and "Special Notes" from Ebco product specs (owner request, 2026-09-03).
-- Applies to the live September Batch 1 locks AND SeptemberBatch2 hinges (if already inserted).
-- Safe to re-run: removing an absent key is a no-op in jsonb.

UPDATE products
SET specs = specs - 'Demo Video' - 'Special Notes'
WHERE specs->>'Source' IN (
  'ebco-digital-locks-september-2026',
  'ebco-hinges-septemberbatch2'
);

-- Verify (should list 0 rows both times):
-- SELECT name FROM products WHERE specs ? 'Demo Video' AND specs->>'Source' LIKE 'ebco-%';
-- SELECT name FROM products WHERE specs ? 'Special Notes';
