// Validation for the Admin "Discounts" tab (cart-value discount tiers).
// Mirrors the table's constraints so mistakes are caught before a round trip:
//   min_subtotal     numeric(12,2)  > 0, unique
//   discount_percent numeric(5,2)   > 0 and <= 50
// This file has no imports so Node tests can load it directly.

export const MAX_TIER_PERCENT = 50;
// numeric(12,2): at most 10 digits before the decimal point.
export const MAX_TIER_MIN_SUBTOTAL = 9999999999.99;

export interface TierDraft {
  /** Text typed into the "Minimum cart value (₹)" box. */
  min: string;
  /** Text typed into the "Discount (%)" box. */
  percent: string;
}

export interface ExistingTier {
  id: string;
  min_subtotal: number | string;
}

export type TierValidation =
  | { ok: true; min_subtotal: number; discount_percent: number }
  | { ok: false; field: 'min' | 'percent'; error: string };

// Plain decimals only (no exponent, no sign), at most two decimal places.
const PLAIN_DECIMAL = /^(\d+(\.\d{0,2})?|\.\d{1,2})$/;

const parseDecimal = (text: string): number | null => {
  const cleaned = String(text ?? '').replace(/[₹,\s]/g, '');
  return PLAIN_DECIMAL.test(cleaned) ? Number(cleaned) : null;
};

const toPaise = (rupees: number) => Math.round(rupees * 100);

const rupeeText = (rupees: number) => `₹${rupees.toLocaleString('en-IN', { maximumFractionDigits: 2 })}`;

/**
 * Checks one tier. `editingId` is the tier being edited (null when adding), so a
 * row never counts as a duplicate of itself. Returns clean numbers, or the first
 * problem in plain words.
 */
export const validateTierInput = (
  draft: TierDraft,
  existing: readonly ExistingTier[],
  editingId: string | null = null,
): TierValidation => {
  const minText = String(draft.min ?? '').trim();
  if (minText === '') return { ok: false, field: 'min', error: 'Enter the minimum cart value.' };
  const min = parseDecimal(minText);
  if (min === null) {
    return { ok: false, field: 'min', error: 'Minimum cart value must be a plain number with at most 2 decimals, e.g. 3000 or 2499.50.' };
  }
  if (min <= 0) return { ok: false, field: 'min', error: 'Minimum cart value must be greater than ₹0.' };
  if (min > MAX_TIER_MIN_SUBTOTAL) return { ok: false, field: 'min', error: 'Minimum cart value is too large.' };

  const percentText = String(draft.percent ?? '').trim();
  if (percentText === '') return { ok: false, field: 'percent', error: 'Enter the discount percentage.' };
  const percent = parseDecimal(percentText.replace(/%/g, ''));
  if (percent === null) {
    return { ok: false, field: 'percent', error: 'Discount must be a plain number with at most 2 decimals, e.g. 1.4.' };
  }
  if (percent <= 0 || percent > MAX_TIER_PERCENT) {
    return { ok: false, field: 'percent', error: `Discount must be greater than 0% and at most ${MAX_TIER_PERCENT}%.` };
  }

  const duplicate = existing.some((tier) => tier.id !== editingId && toPaise(Number(tier.min_subtotal)) === toPaise(min));
  if (duplicate) return { ok: false, field: 'min', error: `A tier with a minimum of ${rupeeText(min)} already exists. Edit that one instead.` };

  return { ok: true, min_subtotal: min, discount_percent: percent };
};

/** Rupees saved on a cart of exactly `min` rupees at `percent`, e.g. 3000 at 1.4 -> 42. */
export const tierSavingAtMinimum = (min: number, percent: number): number =>
  Math.round(toPaise(min) * Math.round(percent * 100) / 10000) / 100;

/** True for "relation does not exist" (Postgres 42P01) and PostgREST's "not in the schema cache" (PGRST205). */
export const isMissingTableError = (error: unknown): boolean => {
  if (!error || typeof error !== 'object') return false;
  const { code, message } = error as { code?: unknown; message?: unknown };
  if (code === '42P01' || code === 'PGRST205') return true;
  return typeof message === 'string' && /discount_tiers/i.test(message) && /(does not exist|schema cache)/i.test(message);
};
