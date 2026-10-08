/**
 * Pure checkout helpers shared by the cart and checkout pages.
 *
 * No React / Supabase imports (only sibling pure modules with explicit `.ts`
 * specifiers) so tests/checkout.test.mjs can load this file directly in Node.
 * The order edge functions stay authoritative for prices, discount and total:
 * nothing here decides what the customer pays, it only mirrors the server and
 * validates input the same way supabase/functions/_shared/checkout.ts does.
 */
import { formatDiscountPercent } from './discounts.ts';
import { isValidCoordinate, type DeliveryLocation } from './location.ts';

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
 * functions. Never carries a discount: the server decides the
 * random percent from the cart and answers HTTP 409 when `expected_total_paise` no longer matches.
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
 * means the total the page showed is stale (the random discount or prices changed);
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

export type DiscountBanner =
  | { status: 'loading'; message: string; hint: null; percent: number }
  | { status: 'applied'; message: string; hint: string; percent: number };

export const DISCOUNT_LOADING_MESSAGE = 'Calculating your automatic random discount…';
export const DISCOUNT_CHANGE_HINT = 'Your discount can change when you change your cart';

/**
 * Copy for the Automatic Random Discount banner. `percent` is the server-decided
 * value from useCartDiscount. Returns null when there is nothing to say (empty
 * cart, no discount, or the feature is off / unavailable): never an "add more to
 * unlock" nudge, because there are no tiers and no minimum order.
 */
export const getDiscountBanner = (
  percent: number,
  { isLoading, hasItems }: { isLoading: boolean; hasItems: boolean },
): DiscountBanner | null => {
  if (!hasItems) return null;
  if (isLoading) return { status: 'loading', message: DISCOUNT_LOADING_MESSAGE, hint: null, percent };
  if (!Number.isFinite(percent) || percent <= 0) return null;
  return {
    status: 'applied',
    message: `You got ${formatDiscountPercent(percent)} automatic random discount on this order!`,
    hint: DISCOUNT_CHANGE_HINT,
    percent,
  };
};
