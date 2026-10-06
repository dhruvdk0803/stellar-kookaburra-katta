export interface CategoryRow {
  id: string;
  name: string;
  parent_id?: string | null;
}

// These names identify manufacturers or product ranges. They can appear in
// legacy category labels, but customers should find them through Brand filters.
// Thermoluxe and IRIS are Gloirio ranges, not brands any more. They stay in
// this list on purpose: category rows such as "1.3mm - Thermoluxe" still exist,
// and listing the names here is what keeps them out of the customer-facing label.
const BRAND_LABELS = [
  'Thermoluxe', 'Astral', 'Astra', 'Apollo', 'Ebco', 'Jivanjor',
  'Rockstar', 'Gloirio', 'Glorio', 'IRIS', 'Rang',
];

const brandLabelPattern = new RegExp(`\\b(?:${BRAND_LABELS.join('|')})\\b`, 'gi');

export const productCategoryLabel = (name: string): string =>
  name
    .replace(brandLabelPattern, ' ')
    .replace(/[–—|]+/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();

// Old shop links that must keep landing on the right products after a category
// was merged or renamed. Keys are lower-case; values are the current category
// slug. Slugs never change when a category is renamed, so only a retired slug
// or the old *label* (links built from the name) needs an entry here.
const LEGACY_CATEGORY_ALIASES: ReadonlyMap<string, string> = new Map([
  // Ebco's own "Hinges" category was merged into Furniture Fitting > Hinges.
  ['ebco-hinges', 'hinges'],
  // "CPVC Fittings & Pipes" (Apollo) and "CPVC Pipes & Fittings" (Astral, and
  // the old homepage card) were renamed "CPVC and UPVC Fittings". The Apollo
  // row is the stocked one, so name-based links resolve to its (unchanged) slug.
  ['cpvc fittings & pipes', 'apollo-cpvc-fittings-pipes'],
  ['cpvc pipes & fittings', 'apollo-cpvc-fittings-pipes'],
]);

/** Maps a retired category slug or label from an old link to the current slug; anything else is returned unchanged. */
export const resolveLegacyCategoryAlias = (value: string): string =>
  LEGACY_CATEGORY_ALIASES.get(String(value ?? '').trim().toLowerCase()) ?? value;

/** The `category` values of a shop URL, with retired slugs and labels resolved to current ones. */
export const categorySelectionFromParams = (params: URLSearchParams): string[] =>
  params.getAll('category').map(resolveLegacyCategoryAlias);

export const normalizeFilterValue = (value: unknown): string => String(value || '').toLowerCase().trim();

export interface ProductCategoryFacet {
  id: string;
  name: string;
  slug?: string | null;
  parent_id?: string | null;
}

interface ProductFacetRow {
  category_id?: string | null;
  categories?: ProductCategoryFacet | null;
}

/**
 * Every name and slug on the product's category path (its own category, then
 * each ancestor). A product matches a selected category when that category is
 * anywhere on this path, so choosing a parent includes all of its descendants.
 */
export const getProductCategoryTokens = (
  product: ProductFacetRow,
  categoriesById: Map<string, ProductCategoryFacet>,
): Set<string> => {
  const tokens = new Set<string>();
  let category = categoriesById.get(product.category_id as string) || product.categories;
  let guard = 0;
  while (category && guard++ < 20) {
    if (category.name) tokens.add(normalizeFilterValue(category.name));
    if (category.slug) tokens.add(normalizeFilterValue(category.slug));
    category = category.parent_id ? categoriesById.get(category.parent_id) : null;
  }
  return tokens;
};

export const productMatchesSelectedCategories = (
  product: ProductFacetRow,
  selectedCategories: string[],
  categoriesById: Map<string, ProductCategoryFacet>,
): boolean => {
  if (!selectedCategories.length) return true;
  const productTokens = getProductCategoryTokens(product, categoriesById);
  return selectedCategories.some((category) => productTokens.has(normalizeFilterValue(category)));
};

/**
 * Presents only product categories. If a legacy brand-only category sits
 * between a product category and one of its children, promote that child to
 * the nearest visible parent while preserving its original id and slug.
 */
export const productBrowsingCategories = <T extends CategoryRow>(categories: T[]): T[] => {
  const byId = new Map(categories.map((category) => [category.id, category]));
  const labels = new Map(categories.map((category) => [category.id, productCategoryLabel(category.name)]));
  const visibleIds = new Set(categories.filter((category) => labels.get(category.id)).map((category) => category.id));

  return categories
    .filter((category) => visibleIds.has(category.id))
    .map((category) => {
      let parentId = category.parent_id || null;
      let guard = 0;
      while (parentId && !visibleIds.has(parentId) && guard++ < 20) {
        parentId = byId.get(parentId)?.parent_id || null;
      }

      return {
        ...category,
        name: labels.get(category.id) || category.name,
        parent_id: parentId,
      };
    });
};

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
