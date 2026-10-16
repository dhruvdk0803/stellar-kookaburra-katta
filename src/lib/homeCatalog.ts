// Pure selection rules for the landing page. Everything the homepage shows is
// derived from live rows, so a category, brand or product the admin adds appears
// on the next visit with no code change.

export interface HomeCategoryRow {
  id: string;
  name: string;
  slug: string;
  parent_id?: string | null;
  image_url?: string | null;
  thumbnail_url?: string | null;
  display_order?: number | null;
  product_count: number;
  root_id: string;
  root_name: string;
}

export interface HomeCategory {
  id: string;
  name: string;
  slug: string;
  image: string | null;
  productCount: number;
}

export interface HomeProductRow {
  id: string;
  name: string;
  price: number;
  image_url?: string | null;
  images?: string[] | null;
  created_at: string;
  category_id?: string | null;
  variants?: { price?: number | string | null }[] | null;
  // PostgREST returns a to-one embed as an object; guard against an array anyway.
  brands?: { name: string } | { name: string }[] | null;
}

// Friendlier shop-window names for a few database names. Unknown slugs keep
// the name the admin typed.
const CATEGORY_LABELS: Record<string, string> = {
  sunmica: 'Laminates & Sunmica',
  'louvers-panels': 'Louvers & Panels',
  'digital-lock': 'Digital Locks',
};

// Used when a category's automatically picked product photo is not representative.
// A photo the admin sets on the category itself always wins over these.
const CATEGORY_COVERS: Record<string, string> = {
  'furniture-fitting': '/images/categories/furniture-fitting.jpg',
  sunmica: '/images/products/rockstar_premium/1659-sf-mochoa.png',
  'apollo-cpvc-fittings-pipes': 'https://jcqqepifotecmrjdyeup.supabase.co/storage/v1/object/public/product-images/products/f32046ae-a4f3-4280-9b6b-a1b394193865.png',
};

const normalise = (value: string) =>
  value.toLowerCase().replace(/[^a-z0-9]/g, '').replace(/s$/, '');

/**
 * The shoppable categories for the homepage grid.
 *
 * Some top-level categories are really brand folders (Apollo, Ebco, Jivanjor…),
 * so for a root whose name is a brand we show its children instead. Categories
 * with the same name under different roots ("Digital Lock" / "Digital Locks")
 * collapse into the one with more products.
 */
export function pickHomeCategories(rows: HomeCategoryRow[], brandNames: string[]): HomeCategory[] {
  const brands = new Set(brandNames.map(normalise));
  const isBrandFolder = (row: Pick<HomeCategoryRow, 'name'>) => brands.has(normalise(row.name));

  const shoppable = rows.filter((row) => {
    if (!row.parent_id) return !isBrandFolder(row);
    return row.parent_id === row.root_id && brands.has(normalise(row.root_name));
  });

  const byName = new Map<string, HomeCategoryRow>();
  shoppable.forEach((row) => {
    const key = normalise(CATEGORY_LABELS[row.slug] || row.name);
    const existing = byName.get(key);
    if (!existing || row.product_count > existing.product_count) byName.set(key, row);
  });

  return [...byName.values()]
    .sort((a, b) =>
      (a.display_order ?? 0) - (b.display_order ?? 0) ||
      b.product_count - a.product_count ||
      a.name.localeCompare(b.name))
    .map((row) => {
      const childPhoto = rows.find((child) => child.parent_id === row.id && child.thumbnail_url)?.thumbnail_url;
      return {
        id: row.id,
        name: CATEGORY_LABELS[row.slug] || row.name.trim(),
        slug: row.slug,
        image: row.image_url || CATEGORY_COVERS[row.slug] || row.thumbnail_url || childPhoto || null,
        productCount: row.product_count,
      };
    });
}

/**
 * Newest products, newest first, but at most one per category until every
 * category in the recent batch has a slot; remaining slots fill by recency.
 * A big upload of one product line therefore cannot take over the whole row.
 */
export function pickNewArrivals(rows: HomeProductRow[], limit = 8): HomeProductRow[] {
  const sorted = [...rows].sort((a, b) => b.created_at.localeCompare(a.created_at));
  const picks: HomeProductRow[] = [];
  const seen = new Set<string>();

  sorted.forEach((row) => {
    const key = row.category_id || row.id;
    if (picks.length < limit && !seen.has(key)) {
      picks.push(row);
      seen.add(key);
    }
  });
  sorted.forEach((row) => {
    if (picks.length < limit && !picks.includes(row)) picks.push(row);
  });

  return picks.sort((a, b) => b.created_at.localeCompare(a.created_at));
}

export const NEW_PRODUCT_DAYS = 30;

export const isNewProduct = (createdAt: string, now = Date.now()) =>
  now - new Date(createdAt).getTime() < NEW_PRODUCT_DAYS * 24 * 60 * 60 * 1000;

export const productBrand = (row: Pick<HomeProductRow, 'brands'>): string | undefined =>
  (Array.isArray(row.brands) ? row.brands[0]?.name : row.brands?.name) || undefined;

/**
 * The price to show on a card: the lowest of the base and variant prices, and
 * whether other options cost more (shown as "From ₹…").
 */
export function cardPrice(row: Pick<HomeProductRow, 'price' | 'variants'>): { amount: number; from: boolean } | null {
  const prices = [row.price, ...(Array.isArray(row.variants) ? row.variants.map((variant) => variant?.price) : [])]
    .map(Number)
    .filter((value) => Number.isFinite(value) && value > 0);
  if (!prices.length) return null;
  const amount = Math.min(...prices);
  return { amount, from: prices.some((value) => value !== amount) };
}
