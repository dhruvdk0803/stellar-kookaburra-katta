/**
 * Progressive cart-value discount, as shown in the cart and at checkout.
 *
 * Rule: the HIGHEST active tier whose `min_subtotal` is <= the cart subtotal
 * applies its percent to the WHOLE subtotal (₹3,000 at 1.4% saves ₹42; tiers
 * never stack and are not marginal). Shipping (SHIPPING_FEE) is never
 * discounted. All maths is done in whole paise.
 *
 * The server is authoritative: the order edge functions apply the same
 * algorithm from supabase/functions/_shared/pricing.ts (tests/pricing.test.mjs
 * proves the two agree; change both together). This file has no imports so
 * Node tests can load it directly.
 */

export interface DiscountTier {
  /** Rupees, e.g. 3000. */
  min_subtotal: number;
  /** Percent, e.g. 1.4. */
  discount_percent: number;
}

/** Flat shipping per order in rupees (never discounted). */
export const SHIPPING_FEE = 100;

const MAX_DISCOUNT_PERCENT_HUNDREDTHS = 5000; // 50%, as enforced by the database

type TierUnits = { minPaise: number; percentHundredths: number };

/** Rupees -> paise or percent -> hundredths; null when not a finite number. */
const toHundredths = (value: unknown): number | null => {
  const n = typeof value === 'number'
    ? value
    : typeof value === 'string' && value.trim() !== ''
      ? Number(value)
      : NaN;
  if (!Number.isFinite(n)) return null;
  return Math.round(n * 100);
};

const toSubtotalPaise = (subtotal: number): number => {
  const paise = toHundredths(subtotal);
  return paise !== null && paise > 0 && Number.isSafeInteger(paise) ? paise : 0;
};

/** Drop inactive/invalid rows, keep the best percent per threshold, sort ascending. */
const normalizeTierUnits = (rows: readonly unknown[] | null | undefined): TierUnits[] => {
  const bestByMin = new Map<number, number>();
  for (const row of rows ?? []) {
    if (!row || typeof row !== 'object') continue;
    const tier = row as { min_subtotal?: unknown; discount_percent?: unknown; is_active?: unknown };
    if (tier.is_active === false) continue;
    const minPaise = toHundredths(tier.min_subtotal);
    const percentHundredths = toHundredths(tier.discount_percent);
    if (minPaise === null || minPaise <= 0 || !Number.isSafeInteger(minPaise)) continue;
    if (
      percentHundredths === null || percentHundredths <= 0 ||
      percentHundredths > MAX_DISCOUNT_PERCENT_HUNDREDTHS
    ) continue;
    const existing = bestByMin.get(minPaise);
    if (existing === undefined || percentHundredths > existing) bestByMin.set(minPaise, percentHundredths);
  }
  return [...bestByMin.entries()]
    .sort((a, b) => a[0] - b[0])
    .map(([minPaise, percentHundredths]) => ({ minPaise, percentHundredths }));
};

const toTier = (tier: TierUnits): DiscountTier => ({
  min_subtotal: tier.minPaise / 100,
  discount_percent: tier.percentHundredths / 100,
});

const findActive = (subtotalPaise: number, tiers: TierUnits[]): TierUnits | null => {
  let active: TierUnits | null = null;
  for (const tier of tiers) {
    if (tier.minPaise > subtotalPaise) break;
    active = tier;
  }
  return active;
};

/**
 * Valid tiers in ascending order of `min_subtotal`. Drops rows with a
 * non-positive/non-numeric threshold, a percent outside (0, 50], or
 * `is_active === false`; for duplicate thresholds the higher percent wins.
 */
export const sortTiers = (tiers: DiscountTier[]): DiscountTier[] => normalizeTierUnits(tiers).map(toTier);

/** The tier that applies to this subtotal (rupees), or null. */
export const getActiveTier = (subtotal: number, tiers: DiscountTier[]): DiscountTier | null => {
  if (subtotal <= 0) return null;
  const active = findActive(toSubtotalPaise(subtotal), normalizeTierUnits(tiers));
  return active ? toTier(active) : null;
};

/** The next higher tier and how many rupees more unlock it, or null at the top tier. */
export const getNextTier = (
  subtotal: number,
  tiers: DiscountTier[],
): { tier: DiscountTier; amountToUnlock: number } | null => {
  const subtotalPaise = toSubtotalPaise(subtotal);
  const next = normalizeTierUnits(tiers).find((tier) => tier.minPaise > subtotalPaise);
  if (!next) return null;
  return { tier: toTier(next), amountToUnlock: (next.minPaise - subtotalPaise) / 100 };
};

/** Discount for a subtotal (rupees): `amount` is in rupees, exact to the paisa. */
export const calculateDiscount = (
  subtotal: number,
  tiers: DiscountTier[],
): { percent: number; amount: number; tier: DiscountTier | null } => {
  const subtotalPaise = toSubtotalPaise(subtotal);
  const active = subtotalPaise > 0 ? findActive(subtotalPaise, normalizeTierUnits(tiers)) : null;
  if (!active) return { percent: 0, amount: 0, tier: null };
  return {
    percent: active.percentHundredths / 100,
    amount: Math.round(subtotalPaise * active.percentHundredths / 10000) / 100,
    tier: toTier(active),
  };
};

/**
 * Full order breakdown in rupees plus `totalPaise`, computed exactly as the
 * server does. Send `totalPaise` as `expected_total_paise` when placing an order.
 */
export const calculateOrderTotals = (subtotal: number, tiers: DiscountTier[]) => {
  const subtotalPaise = toSubtotalPaise(subtotal);
  const discount = calculateDiscount(subtotalPaise / 100, tiers);
  const totalPaise = subtotalPaise - Math.round(discount.amount * 100) + SHIPPING_FEE * 100;
  return {
    subtotal: subtotalPaise / 100,
    discountPercent: discount.percent,
    discountAmount: discount.amount,
    shipping: SHIPPING_FEE,
    total: totalPaise / 100,
    totalPaise,
    tier: discount.tier,
  };
};

/** 1 -> "1%", 1.4 -> "1.4%", 1.75 -> "1.75%". */
export const formatDiscountPercent = (percent: number): string => {
  const hundredths = toHundredths(percent);
  return `${hundredths === null ? 0 : hundredths / 100}%`;
};
