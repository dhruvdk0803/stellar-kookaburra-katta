export interface CategoryNode {
  id: string;
  name: string;
  parent_id?: string | null;
}

// Top-level categories that are themselves a brand (their products' first word
// may be a sub-brand, e.g. Ebco -> Sync-Pro/Crest/Regalia/Imperia locks).
// For these, the brand is the category name, not the first word of the name.
const BRAND_CATEGORIES = new Set(['Apollo', 'Astral', 'Ebco', 'Jivanjor']);

/**
 * Walks a product's category up the parent_id chain and returns the top-level
 * (root) category name — e.g. "Sunmica" for a Rockstar sheet, "Ebco" for a lock.
 */
export function rootCategoryName(
  categoryId: string | null | undefined,
  categories: CategoryNode[],
): string | null {
  if (!categoryId) return null;
  const byId = new Map(categories.map((c) => [c.id, c]));
  let cur = byId.get(categoryId);
  let guard = 0;
  while (cur && cur.parent_id && guard++ < 20) {
    const parent = byId.get(cur.parent_id);
    if (!parent) break;
    cur = parent;
  }
  return cur ? cur.name : null;
}

/**
 * Resolves the brand for a product. Brand-named root categories win; otherwise
 * the first word of the product name is the brand (owner rule).
 */
export function productBrand(
  product: { name?: string | null; category_id?: string | null },
  categories: CategoryNode[],
): string {
  const root = rootCategoryName(product.category_id, categories);
  if (root && BRAND_CATEGORIES.has(root)) return root;
  const first = (product.name || '').trim().split(/\s+/)[0];
  return first || 'Other';
}

/**
 * Distinct brands present in a set of products, in first-seen order.
 */
export function brandsIn(products: any[], categories: CategoryNode[]): string[] {
  const seen: string[] = [];
  const set = new Set<string>();
  for (const p of products) {
    const b = productBrand(p, categories);
    if (!set.has(b)) {
      set.add(b);
      seen.push(b);
    }
  }
  return seen;
}