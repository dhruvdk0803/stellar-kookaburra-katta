export interface CategoryRow {
  id: string;
  name: string;
  parent_id?: string | null;
}

/**
 * Counts the active products sitting in each category, rolling subcategory
 * counts up into their parent.
 *
 * A main category like "Sunmica" holds no products directly — they all live in
 * its subcategories — so counting only direct hits would wrongly mark it empty.
 */
export const countProductsPerCategory = (
  categories: CategoryRow[],
  productCategoryIds: (string | null | undefined)[],
): Map<string, number> => {
  const direct = new Map<string, number>();
  for (const id of productCategoryIds) {
    if (id) direct.set(id, (direct.get(id) || 0) + 1);
  }

  const childrenOf = new Map<string, CategoryRow[]>();
  for (const cat of categories) {
    if (!cat.parent_id) continue;
    const siblings = childrenOf.get(cat.parent_id) || [];
    siblings.push(cat);
    childrenOf.set(cat.parent_id, siblings);
  }

  const totals = new Map<string, number>();
  // `visiting` guards against a category tree that somehow loops back on
  // itself, which would otherwise recurse forever.
  const visiting = new Set<string>();

  const totalFor = (id: string): number => {
    const cached = totals.get(id);
    if (cached !== undefined) return cached;
    if (visiting.has(id)) return direct.get(id) || 0;

    visiting.add(id);
    const total =
      (direct.get(id) || 0) +
      (childrenOf.get(id) || []).reduce((sum, child) => sum + totalFor(child.id), 0);
    visiting.delete(id);

    totals.set(id, total);
    return total;
  };

  for (const cat of categories) totalFor(cat.id);
  return totals;
};

/**
 * Drops categories that contain no active products, so empty ones never render
 * as dead filter rows or menu entries that lead to an empty product listing.
 */
export const filterNonEmptyCategories = <T extends CategoryRow>(
  categories: T[],
  productCategoryIds: (string | null | undefined)[],
): T[] => {
  const totals = countProductsPerCategory(categories, productCategoryIds);
  return categories.filter((cat) => (totals.get(cat.id) || 0) > 0);
};
