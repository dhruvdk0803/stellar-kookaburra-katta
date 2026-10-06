/**
 * Pure checkout helpers shared by the cart and checkout pages.
 *
 * No React / Supabase imports (only sibling pure modules with explicit `.ts`
 * specifiers) so tests/checkout.test.mjs can load this file directly in Node.
 * The order edge functions stay authoritative for prices, discount and total:
 * nothing here decides what the customer pays, it only mirrors the server and
 * validates input the same way supabase/functions/_shared/checkout.ts does.
 */
import { getActiveTier, getNextTier, formatDiscountPercent, type DiscountTier } from './discounts.ts';
import { isValidCoordinate, type DeliveryLocation } from './location.ts';
import { formatRupees } from './money.ts';

/** Same bounds as the server (supabase/functions/_shared/checkout.ts). */
export const MIN_ADDRESS_LENGTH = 10;
export const MAX_ADDRESS_LENGTH = 500;
export const MAX_LOCATION_LABEL_LENGTH = 500;

/** Per-field input limits; together they keep the composed address under MAX_ADDRESS_LENGTH. */
export const ADDRESS_FIELD_MAX_LENGTH = {
  name: 60,
  houseNo: 60,
  street: 160,
  landmark: 80,
  city: 50,
  state: 50,
} as const;

export interface CheckoutFormFields {
  name: string;
  phone: string;
  houseNo: string;
  street: string;
  landmark: string;
  city: string;
  state: string;
  pin: string;
}

export const EMPTY_CHECKOUT_FORM: CheckoutFormFields = {
  name: '',
  phone: '',
  houseNo: '',
  street: '',
  landmark: '',
  city: '',
  state: '',
  pin: '',
};

export type ShippingAddressFields = Pick<
  CheckoutFormFields,
  'name' | 'houseNo' | 'street' | 'landmark' | 'city' | 'state' | 'pin'
>;

/** Trim and collapse runs of whitespace (including newlines) to single spaces. */
const clean = (value: string | null | undefined): string =>
  typeof value === 'string' ? value.replace(/\s+/g, ' ').trim() : '';

/** Indian PIN code: exactly six digits. */
export const isValidPin = (pin: string): boolean => /^\d{6}$/.test(clean(pin));

/**
 * Digits only, accepting the common "+91 98765 43210" and "09876543210" forms.
 * The server requires exactly 10 digits after stripping non-digits.
 */
export const normalizePhone = (phone: string): string =>
  (typeof phone === 'string' ? phone : '').replace(/\D/g, '').replace(/^(91|0)(?=\d{10}$)/, '');

export const isValidPhone = (phone: string): boolean => normalizePhone(phone).length === 10;

/**
 * One shipping-address string for the order, e.g.
 * "Asha Verma, Shop 12, MI Road, Near Ajmeri Gate, Jaipur, Rajasthan 302001".
 * Parts are joined with ", " and blanks are skipped; the optional landmark is
 * written as "Near <landmark>". The recipient name leads so the delivery team
 * knows who to hand the order to (the order row has no separate name field).
 */
export const buildShippingAddress = (fields: ShippingAddressFields): string => {
  const landmark = clean(fields.landmark).replace(/^near\b[\s,:-]*/i, '');
  const statePin = [clean(fields.state), clean(fields.pin)].filter(Boolean).join(' ');
  return [
    clean(fields.name),
    clean(fields.houseNo),
    clean(fields.street),
    landmark ? `Near ${landmark}` : '',
    clean(fields.city),
    statePin,
  ]
    .filter(Boolean)
    .join(', ');
};

/** First problem with the checkout form as a customer-facing message, or null when it can be submitted. */
export const validateCheckoutForm = (fields: CheckoutFormFields): string | null => {
  if (!clean(fields.name)) return 'Please enter your full name.';
  if (!isValidPhone(fields.phone)) return 'Please enter a valid 10-digit mobile number.';
  if (!clean(fields.houseNo)) return 'Please enter your house, flat or shop number.';
  if (!clean(fields.street)) return 'Please enter your street or area.';
  if (!clean(fields.city)) return 'Please enter your city.';
  if (!clean(fields.state)) return 'Please enter your state.';
  if (!isValidPin(fields.pin)) return 'Please enter a valid 6-digit PIN code.';
  const address = buildShippingAddress(fields);
  if (address.length < MIN_ADDRESS_LENGTH) return 'Please enter your complete shipping address.';
  if (address.length > MAX_ADDRESS_LENGTH) return 'Your address is too long. Please shorten it a little.';
  return null;
};

/** Cart subtotal in rupees, summed in whole paise exactly as the server does (no float drift). */
export const getCartSubtotal = (cart: ReadonlyArray<{ price: number; quantity: number }>): number =>
  cart.reduce((sum, item) => sum + Math.round(item.price * 100) * item.quantity, 0) / 100;

export interface CheckoutPayload {
  items: { product_id: string; quantity: number }[];
  expected_total_paise: number;
  address: string;
  phone: string;
  latitude?: number;
  longitude?: number;
  location_label?: string;
}

/**
 * Request body for the 'razorpay-create-order' and 'place-upi-order' edge
 * functions. Never carries a discount: the server computes it from the active
 * tiers and answers HTTP 409 when `expected_total_paise` no longer matches.
 * The map pin is included only when a valid location was chosen.
 */
export const buildCheckoutPayload = ({
  cart,
  expectedTotalPaise,
  address,
  phone,
  location,
}: {
  cart: ReadonlyArray<{ id: string; quantity: number }>;
  expectedTotalPaise: number;
  address: string;
  phone: string;
  location?: DeliveryLocation | null;
}): CheckoutPayload => {
  const payload: CheckoutPayload = {
    items: cart.map((item) => ({ product_id: item.id, quantity: item.quantity })),
    expected_total_paise: expectedTotalPaise,
    address,
    phone: normalizePhone(phone),
  };
  if (location && isValidCoordinate(location.latitude, location.longitude)) {
    payload.latitude = location.latitude;
    payload.longitude = location.longitude;
    const label = clean(location.label);
    if (label) payload.location_label = label.slice(0, MAX_LOCATION_LABEL_LENGTH);
  }
  return payload;
};

export type CheckoutFailure =
  | { kind: 'stale_total'; message: string; serverTotalPaise: number }
  | { kind: 'error'; message: string };

/**
 * Classify an edge-function error response. HTTP 409 WITH `serverTotalPaise`
 * means the total the page showed is stale (discount tiers or prices changed);
 * a 409 without it is a stock conflict and keeps the server's own message.
 */
export const classifyCheckoutFailure = (status: number | null, body: unknown, fallback: string): CheckoutFailure => {
  const record = body && typeof body === 'object' ? (body as Record<string, unknown>) : null;
  const serverMessage = record && typeof record.error === 'string' && record.error.trim() ? record.error : null;
  const serverTotal = record ? Number(record.serverTotalPaise) : NaN;
  if (status === 409 && record && record.serverTotalPaise !== undefined && record.serverTotalPaise !== null && Number.isFinite(serverTotal)) {
    return { kind: 'stale_total', message: serverMessage ?? fallback, serverTotalPaise: serverTotal };
  }
  return { kind: 'error', message: serverMessage ?? fallback };
};

export const STALE_TOTAL_TOAST = 'Your cart total changed (discount or price update). Please review the new total and try again.';

export interface DiscountNudge {
  /** locked: no tier yet; unlocked: a tier applies and a better one exists; top: best tier reached. */
  status: 'locked' | 'unlocked' | 'top';
  headline: string;
  /** "Add ₹Y more to unlock Z%." while a better tier exists after one is unlocked. */
  nextStep: string | null;
  /** 0..1 progress of the subtotal toward the next tier's threshold (1 at the top tier). */
  progress: number;
  activePercent: number | null;
  nextPercent: number | null;
  amountToUnlock: number | null;
}

/** ₹1,500 or ₹1,499.50: paise only when the amount has them. */
const formatAmount = (amount: number): string => `₹${formatRupees(amount, !Number.isInteger(amount))}`;

/**
 * Cart-value discount incentive copy. Every number comes from `tiers`
 * (admin-editable); with no tiers or an empty cart there is nothing to show.
 */
export const getDiscountNudge = (subtotal: number, tiers: DiscountTier[]): DiscountNudge | null => {
  if (!Number.isFinite(subtotal) || subtotal <= 0) return null;
  const active = getActiveTier(subtotal, tiers);
  const next = getNextTier(subtotal, tiers);
  if (!active && !next) return null;

  const progress = next ? Math.min(1, Math.max(0, subtotal / next.tier.min_subtotal)) : 1;
  const nextPercent = next ? next.tier.discount_percent : null;
  const amountToUnlock = next ? next.amountToUnlock : null;

  if (!active && next) {
    return {
      status: 'locked',
      headline: `Add ${formatAmount(next.amountToUnlock)} more to unlock ${formatDiscountPercent(next.tier.discount_percent)} off your entire order.`,
      nextStep: null,
      progress,
      activePercent: null,
      nextPercent,
      amountToUnlock,
    };
  }

  const activePercent = active!.discount_percent;
  if (next) {
    return {
      status: 'unlocked',
      headline: `You've unlocked ${formatDiscountPercent(activePercent)} off your entire order.`,
      nextStep: `Add ${formatAmount(next.amountToUnlock)} more to unlock ${formatDiscountPercent(next.tier.discount_percent)}.`,
      progress,
      activePercent,
      nextPercent,
      amountToUnlock,
    };
  }
  return {
    status: 'top',
    headline: `You've unlocked our best discount (${formatDiscountPercent(activePercent)}).`,
    nextStep: null,
    progress: 1,
    activePercent,
    nextPercent: null,
    amountToUnlock: null,
  };
};
