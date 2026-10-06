// Product counts shown in Admin (Product List title and the "Live Products"
// dashboard card). One helper feeds both, so the numbers can never disagree.
//
// Rules:
//   live  = is_active !== false   (NULL / missing counts as live, exactly as the
//                                  product form, the filter and the badges treat it)
//   draft = is_active === false
//   live + draft === total, and shown / live / draft never exceed total.
// This file has no imports so Node tests can load it directly.

export interface CountableProduct {
  is_active?: boolean | null;
}

export interface ProductCounts {
  /** Products matching the current filters. */
  shown: number;
  /** Every product Admin loaded (live and draft). */
  total: number;
  live: number;
  draft: number;
}

// Rows can only be products when they are objects; a stray null never throws
// and is never counted.
const onlyProducts = (rows: readonly (CountableProduct | null | undefined)[] | null | undefined): CountableProduct[] =>
  Array.isArray(rows) ? rows.filter((row): row is CountableProduct => row !== null && typeof row === 'object') : [];

/**
 * @param allProducts   every product loaded in Admin (drafts included)
 * @param shownProducts the subset left after the list filters
 */
export const getProductCounts = (
  allProducts: readonly (CountableProduct | null | undefined)[] | null | undefined,
  shownProducts: readonly (CountableProduct | null | undefined)[] | null | undefined,
): ProductCounts => {
  const all = onlyProducts(allProducts);
  const draft = all.filter((product) => product.is_active === false).length;
  const total = all.length;
  return {
    // The filtered list is always a subset of the full list; clamp in case a
    // caller passes a stale or unrelated array.
    shown: Math.min(onlyProducts(shownProducts).length, total),
    total,
    live: total - draft,
    draft,
  };
};

/** "12 shown · 40 total · 31 live · 9 draft" */
export const formatProductCounts = (counts: ProductCounts): string =>
  `${counts.shown} shown · ${counts.total} total · ${counts.live} live · ${counts.draft} draft`;
