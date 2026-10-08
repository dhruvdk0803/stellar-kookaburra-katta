// Validation for the Admin "Discounts" card (Automatic Random Discount settings).
// Mirrors public.discount_settings: 0 < min_percent <= max_percent <= 5, 2 decimals.
// This file has no imports so Node tests can load it directly.

export const RANDOM_DISCOUNT_MAX_PERCENT = 5;

export interface RandomDiscountDraft {
  /** Text typed into the "Minimum %" box. */
  min: string;
  /** Text typed into the "Maximum %" box. */
  max: string;
}

export type RandomDiscountValidation =
  | { ok: true; min_percent: number; max_percent: number }
  | { ok: false; field: 'min' | 'max'; error: string };

// Plain decimals only (no exponent, no sign), at most two decimal places.
const PLAIN_DECIMAL = /^(\d+(\.\d{0,2})?|\.\d{1,2})$/;

const parsePercent = (text: string): number | null => {
  const cleaned = String(text ?? '').replace(/[%\s]/g, '');
  return PLAIN_DECIMAL.test(cleaned) ? Number(cleaned) : null;
};

/** Checks the min/max boxes. Returns clean numbers, or the first problem in plain words. */
export const validateRandomDiscountInput = (draft: RandomDiscountDraft): RandomDiscountValidation => {
  const minText = String(draft.min ?? '').trim();
  if (minText === '') return { ok: false, field: 'min', error: 'Enter the minimum discount %.' };
  const min = parsePercent(minText);
  if (min === null) {
    return { ok: false, field: 'min', error: 'Minimum must be a plain number with at most 2 decimals, e.g. 0.5.' };
  }
  if (min <= 0 || min > RANDOM_DISCOUNT_MAX_PERCENT) {
    return { ok: false, field: 'min', error: `Minimum must be greater than 0% and at most ${RANDOM_DISCOUNT_MAX_PERCENT}%.` };
  }

  const maxText = String(draft.max ?? '').trim();
  if (maxText === '') return { ok: false, field: 'max', error: 'Enter the maximum discount %.' };
  const max = parsePercent(maxText);
  if (max === null) {
    return { ok: false, field: 'max', error: 'Maximum must be a plain number with at most 2 decimals, e.g. 5.' };
  }
  if (max <= 0 || max > RANDOM_DISCOUNT_MAX_PERCENT) {
    return { ok: false, field: 'max', error: `Maximum must be greater than 0% and at most ${RANDOM_DISCOUNT_MAX_PERCENT}%.` };
  }
  if (min > max) return { ok: false, field: 'min', error: 'Minimum cannot be higher than the maximum.' };

  return { ok: true, min_percent: min, max_percent: max };
};

/** True for "relation does not exist" (Postgres 42P01) and PostgREST's "not in the schema cache" (PGRST205). */
export const isMissingTableError = (error: unknown): boolean => {
  if (!error || typeof error !== 'object') return false;
  const { code, message } = error as { code?: unknown; message?: unknown };
  if (code === '42P01' || code === 'PGRST205') return true;
  return typeof message === 'string' && /discount_settings/i.test(message) && /(does not exist|schema cache)/i.test(message);
};
