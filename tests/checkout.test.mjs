import assert from 'node:assert/strict';
import test from 'node:test';
import {
  buildCheckoutPayload,
  buildShippingAddress,
  classifyCheckoutFailure,
  EMPTY_CHECKOUT_FORM,
  getCartSubtotal,
  getDiscountBanner,
  isValidPhone,
  isValidPin,
  MAX_ADDRESS_LENGTH,
  normalizePhone,
  validateCheckoutForm,
} from '../src/lib/checkout.ts';
import { calculateOrderTotals } from '../src/lib/discounts.ts';

const FORM = {
  name: 'Asha Verma',
  phone: '+91 98765 43210',
  houseNo: 'Shop 12',
  street: 'MI Road',
  landmark: 'Ajmeri Gate',
  city: 'Jaipur',
  state: 'Rajasthan',
  pin: '302001',
};

// ---------------------------------------------------------------- address

test('buildShippingAddress joins all parts with ", " and writes the landmark as "Near …"', () => {
  assert.equal(
    buildShippingAddress(FORM),
    'Asha Verma, Shop 12, MI Road, Near Ajmeri Gate, Jaipur, Rajasthan 302001',
  );
});

test('buildShippingAddress skips blank parts (optional landmark omitted)', () => {
  assert.equal(
    buildShippingAddress({ ...FORM, landmark: '   ' }),
    'Asha Verma, Shop 12, MI Road, Jaipur, Rajasthan 302001',
  );
  assert.equal(buildShippingAddress({ ...EMPTY_CHECKOUT_FORM, city: 'Jaipur', pin: '302001' }), 'Jaipur, 302001');
  assert.equal(buildShippingAddress(EMPTY_CHECKOUT_FORM), '');
});

test('buildShippingAddress trims and collapses whitespace, and never doubles "Near"', () => {
  assert.equal(
    buildShippingAddress({ ...FORM, name: '  Asha   Verma ', street: 'MI\n Road ', landmark: 'near  Ajmeri Gate' }),
    'Asha Verma, Shop 12, MI Road, Near Ajmeri Gate, Jaipur, Rajasthan 302001',
  );
  assert.equal(buildShippingAddress({ ...FORM, landmark: 'Nearby Mall' }).includes('Near Nearby Mall'), true);
  assert.equal(buildShippingAddress({ ...FORM, landmark: 'Near' }).includes('Near'), false);
});

// ---------------------------------------------------------------- PIN / phone

test('isValidPin accepts exactly six digits', () => {
  assert.equal(isValidPin('302001'), true);
  assert.equal(isValidPin(' 302001 '), true);
  for (const bad of ['', '30200', '3020011', '30200a', '302 001', '३०२००१']) {
    assert.equal(isValidPin(bad), false, bad);
  }
});

test('normalizePhone strips non-digits and a leading 91 / 0 before 10 digits', () => {
  assert.equal(normalizePhone('98765 43210'), '9876543210');
  assert.equal(normalizePhone('+91 98765-43210'), '9876543210');
  assert.equal(normalizePhone('919876543210'), '9876543210');
  assert.equal(normalizePhone('09876543210'), '9876543210');
  // A 10-digit number that merely starts with 91 or 0 is kept as typed.
  assert.equal(normalizePhone('9198765432'), '9198765432');
  assert.equal(normalizePhone('12345'), '12345');
  assert.equal(isValidPhone('+91 98765 43210'), true);
  assert.equal(isValidPhone('98765'), false);
  assert.equal(isValidPhone('0919876543210'), false);
});

// ---------------------------------------------------------------- form validation

test('validateCheckoutForm accepts a complete form and reports the first problem otherwise', () => {
  assert.equal(validateCheckoutForm(FORM), null);
  assert.equal(validateCheckoutForm({ ...FORM, landmark: '' }), null);
  assert.match(validateCheckoutForm({ ...FORM, name: ' ' }), /full name/);
  assert.match(validateCheckoutForm({ ...FORM, phone: '12345' }), /10-digit/);
  assert.match(validateCheckoutForm({ ...FORM, houseNo: '' }), /house/);
  assert.match(validateCheckoutForm({ ...FORM, street: '' }), /street/);
  assert.match(validateCheckoutForm({ ...FORM, city: '' }), /city/);
  assert.match(validateCheckoutForm({ ...FORM, state: '' }), /state/);
  assert.match(validateCheckoutForm({ ...FORM, pin: '30200' }), /PIN/);
  assert.match(validateCheckoutForm({ ...FORM, street: 'x'.repeat(MAX_ADDRESS_LENGTH) }), /too long/);
});

test('a valid form always composes an address the server accepts (10..500 chars)', () => {
  const address = buildShippingAddress({ ...FORM, name: 'A', houseNo: '1', street: 'B', landmark: '', city: 'C', state: 'D' });
  assert.equal(validateCheckoutForm({ ...FORM, name: 'A', houseNo: '1', street: 'B', landmark: '', city: 'C', state: 'D' }), null);
  assert.ok(address.length >= 10 && address.length <= MAX_ADDRESS_LENGTH, address);
});

// ---------------------------------------------------------------- subtotal + payload

test('getCartSubtotal sums in whole paise (no float drift)', () => {
  assert.equal(getCartSubtotal([]), 0);
  assert.equal(getCartSubtotal([{ price: 0.1, quantity: 3 }, { price: 0.2, quantity: 1 }]), 0.5);
  assert.equal(getCartSubtotal([{ price: 666.67, quantity: 3 }]), 2000.01);
});

test('buildCheckoutPayload omits the location when none is set and never sends a discount', () => {
  const cart = [{ id: 'a', name: 'x', price: 1500, quantity: 2, image: '' }, { id: 'b:v1', name: 'y', price: 250, quantity: 1, image: '' }];
  const totals = calculateOrderTotals(getCartSubtotal(cart), 1.4);
  const payload = buildCheckoutPayload({ cart, expectedTotalPaise: totals.totalPaise, address: buildShippingAddress(FORM), phone: FORM.phone, location: null });
  assert.deepEqual(payload, {
    items: [{ product_id: 'a', quantity: 2 }, { product_id: 'b:v1', quantity: 1 }],
    // ₹3,250 subtotal at a 1.4% random discount (₹45.50 off); shipping is free.
    expected_total_paise: 325_000 - 4_550,
    address: 'Asha Verma, Shop 12, MI Road, Near Ajmeri Gate, Jaipur, Rajasthan 302001',
    phone: '9876543210',
  });
  for (const key of ['latitude', 'longitude', 'location_label', 'discount_percent']) {
    assert.equal(key in payload, false, key);
  }
  assert.equal(JSON.stringify(payload).includes('discount'), false);
});

test('buildCheckoutPayload includes latitude/longitude (and a trimmed label) only for a valid pin', () => {
  const base = { cart: [{ id: 'a', quantity: 1 }], expectedTotalPaise: 10100, address: 'x'.repeat(12), phone: '9876543210' };
  assert.deepEqual(
    buildCheckoutPayload({ ...base, location: { latitude: 26.9124, longitude: 75.7873, label: '  MI Road, Jaipur  ' } }),
    {
      items: [{ product_id: 'a', quantity: 1 }],
      expected_total_paise: 10100,
      address: 'x'.repeat(12),
      phone: '9876543210',
      latitude: 26.9124,
      longitude: 75.7873,
      location_label: 'MI Road, Jaipur',
    },
  );
  const noLabel = buildCheckoutPayload({ ...base, location: { latitude: 0, longitude: 0, label: null } });
  assert.equal(noLabel.latitude, 0);
  assert.equal(noLabel.longitude, 0);
  assert.equal('location_label' in noLabel, false);

  const longLabel = buildCheckoutPayload({ ...base, location: { latitude: 1, longitude: 2, label: 'y'.repeat(800) } });
  assert.equal(longLabel.location_label.length, 500);

  for (const bad of [{ latitude: NaN, longitude: 1 }, { latitude: 91, longitude: 1 }, { latitude: '26.9', longitude: '75.7' }]) {
    const payload = buildCheckoutPayload({ ...base, location: bad });
    assert.equal('latitude' in payload || 'longitude' in payload || 'location_label' in payload, false, JSON.stringify(bad));
  }
});

// ---------------------------------------------------------------- server errors

test('classifyCheckoutFailure detects a stale total only for 409 + serverTotalPaise', () => {
  assert.deepEqual(
    classifyCheckoutFailure(409, { error: 'Your order total has changed.', serverTotalPaise: 306_480, discountPercent: 1.4, discountAmount: 42 }, 'fallback'),
    { kind: 'stale_total', message: 'Your order total has changed.', serverTotalPaise: 306_480 },
  );
  // Stock conflict: 409 without serverTotalPaise keeps the server's message.
  assert.deepEqual(
    classifyCheckoutFailure(409, { error: 'Insufficient stock for abc' }, 'fallback'),
    { kind: 'error', message: 'Insufficient stock for abc' },
  );
  assert.deepEqual(classifyCheckoutFailure(400, { error: 'Enter a valid shipping address' }, 'fallback'), { kind: 'error', message: 'Enter a valid shipping address' });
  assert.deepEqual(classifyCheckoutFailure(500, null, 'fallback'), { kind: 'error', message: 'fallback' });
  assert.deepEqual(classifyCheckoutFailure(null, 'not json', 'fallback'), { kind: 'error', message: 'fallback' });
  assert.deepEqual(classifyCheckoutFailure(200, { serverTotalPaise: 1 }, 'fallback'), { kind: 'error', message: 'fallback' });
  assert.deepEqual(classifyCheckoutFailure(409, { serverTotalPaise: null }, 'fallback'), { kind: 'error', message: 'fallback' });
});

// ---------------------------------------------------------------- discount banner

test('getDiscountBanner: nothing for an empty cart', () => {
  assert.equal(getDiscountBanner(2.37, { isLoading: false, hasItems: false }), null);
  assert.equal(getDiscountBanner(0, { isLoading: true, hasItems: false }), null);
});

test('getDiscountBanner: calculating message while the server decides', () => {
  const banner = getDiscountBanner(1.2, { isLoading: true, hasItems: true });
  assert.equal(banner.status, 'loading');
  assert.equal(banner.message, 'Calculating your automatic random discount…');
  assert.equal(banner.hint, null);
});

test('getDiscountBanner: friendly message with the percent and the change-with-cart hint', () => {
  const banner = getDiscountBanner(2.37, { isLoading: false, hasItems: true });
  assert.equal(banner.status, 'applied');
  assert.equal(banner.message, 'You got 2.37% automatic random discount on this order!');
  assert.equal(banner.hint, 'Your discount can change when you change your cart');
  assert.equal(getDiscountBanner(5, { isLoading: false, hasItems: true }).message, 'You got 5% automatic random discount on this order!');
});

test('getDiscountBanner: silent when there is no discount and never an "unlock" nudge', () => {
  for (const percent of [0, -1, NaN]) {
    assert.equal(getDiscountBanner(percent, { isLoading: false, hasItems: true }), null);
  }
  const text = JSON.stringify([
    getDiscountBanner(3, { isLoading: false, hasItems: true }),
    getDiscountBanner(3, { isLoading: true, hasItems: true }),
  ]);
  assert.equal(/unlock|add ₹|more to/i.test(text), false);
});
