// Shared checkout request validation for razorpay-create-order and
// place-upi-order. PURE TypeScript (no Deno globals, no URL imports) so the
// Node tests can import it with --experimental-strip-types.
//
// Any `discount_percent` sent by the browser is ignored: the server computes
// the discount via get_cart_discount_percent() (see pricing.ts).
import {
  type CartLine,
  MAX_CART_LINES,
  parseCartItems,
  type PricingFailure,
} from "./pricing.ts";

export const MAX_ADDRESS_LENGTH = 500;
export const MIN_ADDRESS_LENGTH = 10;
export const MAX_LOCATION_LABEL_LENGTH = 500;

export type DeliveryLocationInput = {
  latitude: number | null;
  longitude: number | null;
  label: string | null;
};

export type CheckoutRequest = {
  ok: true;
  items: unknown[];
  lines: CartLine[];
  productIds: string[];
  address: string;
  phoneDigits: string;
  location: DeliveryLocationInput;
  expectedTotalPaise: unknown;
};

const fail = (error: string): PricingFailure => ({ ok: false, status: 400, error });

const isAbsent = (value: unknown) => value === undefined || value === null;

/**
 * Optional map pin: `latitude` + `longitude` (finite numbers, both or
 * neither) and an optional `location_label` (e.g. a reverse-geocoded address).
 */
export function parseDeliveryLocation(
  latitude: unknown,
  longitude: unknown,
  label: unknown,
): PricingFailure | { ok: true; location: DeliveryLocationInput } {
  let lat: number | null = null;
  let lng: number | null = null;
  if (!isAbsent(latitude) || !isAbsent(longitude)) {
    if (
      typeof latitude !== "number" || typeof longitude !== "number" ||
      !Number.isFinite(latitude) || !Number.isFinite(longitude) ||
      latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180
    ) {
      return fail("Invalid delivery location");
    }
    lat = latitude;
    lng = longitude;
  }

  let cleanLabel: string | null = null;
  if (!isAbsent(label)) {
    if (typeof label !== "string") return fail("Invalid delivery location");
    const trimmed = label.trim();
    if (trimmed.length > MAX_LOCATION_LABEL_LENGTH) return fail("Delivery location description is too long");
    cleanLabel = trimmed === "" ? null : trimmed;
  }
  return { ok: true, location: { latitude: lat, longitude: lng, label: cleanLabel } };
}

export function parseCheckoutRequest(body: unknown): PricingFailure | CheckoutRequest {
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return fail("Invalid checkout request");
  }
  const {
    items,
    address,
    phone,
    expected_total_paise,
    latitude,
    longitude,
    location_label,
  } = body as Record<string, unknown>;

  if (!Array.isArray(items) || items.length === 0) return fail("Cart is empty");
  if (items.length > MAX_CART_LINES) return fail("Too many cart items");
  if (typeof address !== "string" || address.trim().length < MIN_ADDRESS_LENGTH || address.length > MAX_ADDRESS_LENGTH) {
    return fail("Enter a valid shipping address");
  }
  const phoneDigits = typeof phone === "string" ? phone.replace(/\D/g, "") : "";
  if (phoneDigits.length !== 10) return fail("Enter a valid 10-digit phone number");

  const cart = parseCartItems(items);
  if (!cart.ok) return cart;

  const location = parseDeliveryLocation(latitude, longitude, location_label);
  if (!location.ok) return location;

  return {
    ok: true,
    items,
    lines: cart.lines,
    productIds: cart.productIds,
    address: address.trim(),
    phoneDigits,
    location: location.location,
    expectedTotalPaise: expected_total_paise,
  };
}
