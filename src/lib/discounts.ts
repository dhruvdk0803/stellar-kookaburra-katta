/**
 * Automatic Random Discount, as shown in the cart and at checkout.
 *
 * Rule: every cart gets a random percent from a small minimum up to
 * MAX_DISCOUNT_PERCENT (5%), applied to the WHOLE subtotal. There are no tiers
 * and no minimum order, and shipping (SHIPPING_FEE) is free. The percent is
 * decided by the SERVER (RPC get_cart_discount_percent; the order edge
 * functions recompute it) and is stable for an identical cart. This file only
 * turns that percent into rupees, in whole paise, with the same rounding the
 * server uses (tests/pricing.test.mjs proves they agree).
 *
 * This file has no imports so Node tests can load it directly.
 */

/** Flat shipping per order in rupees (never discounted). */
export const SHIPPING_FEE = 0; // shipping is free on every order

/** Highest percent the storefront will ever apply (also the admin cap). */
export const MAX_DISCOUNT_PERCENT = 5;

const MAX_PERCENT_HUNDREDTHS = MAX_DISCOUNT_PERCENT * 100;

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

/** Percent -> whole hundredths of a percent, clamped to [0, 5%]. Bad input is 0. */
const toPercentHundredths = (percent: unknown): number => {
  const hundredths = toHundredths(percent);
  if (hundredths === null || hundredths <= 0) return 0;
  return Math.min(hundredths, MAX_PERCENT_HUNDREDTHS);
};

/** Discount for a subtotal (rupees) at `percent`: `amount` is in rupees, exact to the paisa. */
export const calculateDiscount = (
  subtotal: number,
  percent: number,
): { percent: number; amount: number } => {
  const subtotalPaise = toSubtotalPaise(subtotal);
  const hundredths = toPercentHundredths(percent);
  if (subtotalPaise === 0 || hundredths === 0) return { percent: hundredths / 100, amount: 0 };
  return {
    percent: hundredths / 100,
    amount: Math.round(subtotalPaise * hundredths / 10000) / 100,
  };
};

/**
 * Full order breakdown in rupees plus `totalPaise`, computed exactly as the
 * server does. Send `totalPaise` as `expected_total_paise` when placing an order.
 */
export const calculateOrderTotals = (subtotal: number, percent: number) => {
  const subtotalPaise = toSubtotalPaise(subtotal);
  const discount = calculateDiscount(subtotalPaise / 100, percent);
  const totalPaise = subtotalPaise - Math.round(discount.amount * 100) + SHIPPING_FEE * 100;
  return {
    subtotal: subtotalPaise / 100,
    discountPercent: discount.percent,
    discountAmount: discount.amount,
    shipping: SHIPPING_FEE,
    total: totalPaise / 100,
    totalPaise,
  };
};

export type OrderTotals = ReturnType<typeof calculateOrderTotals>;

/** 5 -> "5%", 2.37 -> "2.37%", 2.5 -> "2.5%" (two decimals at most, trailing zeros trimmed). */
export const formatDiscountPercent = (percent: number): string => {
  const hundredths = toHundredths(percent);
  return `${hundredths === null ? 0 : hundredths / 100}%`;
};
