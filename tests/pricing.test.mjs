import assert from 'node:assert/strict';
import test from 'node:test';
import {
  calculateTierDiscount,
  matchesExpectedTotal,
  normalizeDiscountTiers,
  orderSummary,
  priceCart,
  SHIPPING_PAISE,
  staleTotalBody,
} from '../supabase/functions/_shared/pricing.ts';
import { parseCheckoutRequest, parseDeliveryLocation } from '../supabase/functions/_shared/checkout.ts';
import { calculateDiscount, getActiveTier, sortTiers } from '../src/lib/discounts.ts';

const A = '11111111-1111-4111-8111-111111111111';
const B = '22222222-2222-4222-8222-222222222222';
const C = '33333333-3333-4333-8333-333333333333';

// Tier rows as PostgREST returns them (numeric may arrive as number or string).
const TIER_ROWS = [
  { min_subtotal: 2000, discount_percent: 1, is_active: true },
  { min_subtotal: '3000.00', discount_percent: '1.40', is_active: true },
  { min_subtotal: 4000, discount_percent: 1.7, is_active: true },
];

const product = (id, overrides = {}) => ({
  id,
  price: 500,
  variants: null,
  is_active: true,
  stock: 100,
  ...overrides,
});

const PRODUCTS = [
  product(A, { price: 1000 }),
  product(B, {
    price: 250,
    variants: [
      { label: '1/2 inch', price: 120.5 },
      { label: '3/4 inch', price: 199.99 },
      { label: 'No price' },
    ],
  }),
  product(C, { price: 49.99, stock: 3 }),
];

const price = (items, products = PRODUCTS, tiers = TIER_ROWS) => priceCart({ items, products, tiers });

test('prices a simple cart from DB prices and applies the whole-subtotal tier', () => {
  const result = price([{ product_id: A, quantity: 3 }]);
  assert.equal(result.ok, true);
  assert.equal(result.subtotalPaise, 300000);
  assert.equal(result.discountPercent, 1.4);
  assert.equal(result.discountPaise, 4200);
  assert.equal(result.shippingPaise, SHIPPING_PAISE);
  assert.equal(SHIPPING_PAISE, 0);
  assert.equal(result.totalPaise, 300000 - 4200);
  assert.deepEqual(result.tier, { min_subtotal: 3000, discount_percent: 1.4 });
  assert.deepEqual(result.orderItems, [{ product_id: A, quantity: 3, price: 1000, variant_label: null }]);
  assert.deepEqual(orderSummary(result), {
    subtotal: 3000, discountPercent: 1.4, discountAmount: 42, shipping: 0, total: 2958,
  });
});

test('there is no minimum order value any more', () => {
  const result = price([{ product_id: C, quantity: 1 }]);
  assert.equal(result.ok, true);
  assert.equal(result.subtotalPaise, 4999);
  assert.equal(result.discountPaise, 0);
  assert.equal(result.tier, null);
  assert.equal(result.totalPaise, 4999);
});

test('variant suffix ":vN" prices from the DB variant and records its label', () => {
  const result = price([
    { product_id: `${B}:v0`, quantity: 2 },
    { product_id: `${B}:v1`, quantity: 1 },
    { product_id: `${B}:v2`, quantity: 1 }, // no variant price -> base price
  ]);
  assert.equal(result.ok, true);
  assert.deepEqual(result.orderItems, [
    { product_id: B, quantity: 2, price: 120.5, variant_label: '1/2 inch' },
    { product_id: B, quantity: 1, price: 199.99, variant_label: '3/4 inch' },
    { product_id: B, quantity: 1, price: 250, variant_label: 'No price' },
  ]);
  assert.equal(result.subtotalPaise, 24100 + 19999 + 25000);
});

test('bad variants are rejected', () => {
  assert.deepEqual(price([{ product_id: `${B}:v3`, quantity: 1 }]), { ok: false, status: 400, error: `Invalid variant for ${B}` });
  assert.deepEqual(price([{ product_id: `${A}:v0`, quantity: 1 }]), { ok: false, status: 400, error: `Invalid variant for ${A}` });
  assert.deepEqual(price([{ product_id: `${B}:vx`, quantity: 1 }]), { ok: false, status: 400, error: 'Invalid cart item' });
  assert.deepEqual(price([{ product_id: `${B}:v1:v2`, quantity: 1 }]), { ok: false, status: 400, error: 'Invalid cart item' });
});

test('bad ids, unknown or hidden products are rejected', () => {
  const invalid = { ok: false, status: 400, error: 'Invalid cart item' };
  for (const id of ['not-a-uuid', '', 42, null, undefined, `${A}x`, `${A.slice(0, 35)}:v1`]) {
    assert.deepEqual(price([{ product_id: id, quantity: 1 }]), invalid, String(id));
  }
  assert.deepEqual(price([null]), invalid);
  assert.deepEqual(price(['x']), invalid);
  const unknown = '44444444-4444-4444-8444-444444444444';
  assert.deepEqual(price([{ product_id: unknown, quantity: 1 }]), { ok: false, status: 400, error: `Unavailable product: ${unknown}` });
  assert.deepEqual(
    price([{ product_id: A, quantity: 1 }], [product(A, { is_active: false })]),
    { ok: false, status: 400, error: `Unavailable product: ${A}` },
  );
  // Upper-case ids resolve to the same product.
  assert.equal(price([{ product_id: A.toUpperCase(), quantity: 1 }]).ok, true);
});

test('cart size limits', () => {
  assert.deepEqual(price([]), { ok: false, status: 400, error: 'Cart is empty' });
  assert.deepEqual(price('nope'), { ok: false, status: 400, error: 'Cart is empty' });
  const tooMany = Array.from({ length: 51 }, () => ({ product_id: A, quantity: 1 }));
  assert.deepEqual(price(tooMany), { ok: false, status: 400, error: 'Too many cart items' });
  const fifty = Array.from({ length: 50 }, () => ({ product_id: A, quantity: 1 }));
  assert.equal(price(fifty, [product(A, { stock: 50 })]).ok, true);
});

test('quantity bounds are 1..100 whole units', () => {
  for (const quantity of [0, -1, 101, 1.5, 'abc', null, undefined, Number.NaN]) {
    assert.deepEqual(
      price([{ product_id: A, quantity }], [product(A, { stock: 1000 })]),
      { ok: false, status: 400, error: `Invalid quantity for ${A}` },
      String(quantity),
    );
  }
  assert.equal(price([{ product_id: A, quantity: 100 }], [product(A, { stock: 1000 })]).ok, true);
  assert.equal(price([{ product_id: A, quantity: 1 }]).ok, true);
});

test('stock is checked per product across lines', () => {
  assert.deepEqual(price([{ product_id: C, quantity: 4 }]), { ok: false, status: 409, error: `Insufficient stock for ${C}` });
  assert.deepEqual(
    price([{ product_id: C, quantity: 2 }, { product_id: C, quantity: 2 }]),
    { ok: false, status: 409, error: `Insufficient stock for ${C}` },
  );
  assert.equal(price([{ product_id: C, quantity: 3 }]).ok, true);
  for (const stock of [null, undefined, 'x', 1.5]) {
    assert.equal(price([{ product_id: A, quantity: 1 }], [product(A, { stock })]).status, 409, String(stock));
  }
});

test('prices must be positive and exact to the paisa', () => {
  for (const bad of [0, -5, 'abc', null, Number.POSITIVE_INFINITY]) {
    assert.deepEqual(
      price([{ product_id: A, quantity: 1 }], [product(A, { price: bad })]),
      { ok: false, status: 400, error: `Invalid price for ${A}` },
      String(bad),
    );
  }
  assert.deepEqual(
    price([{ product_id: A, quantity: 1 }], [product(A, { price: 10.005 })]),
    { ok: false, status: 400, error: `Invalid price precision for ${A}` },
  );
  // Numeric strings from PostgREST and typical float prices are fine.
  const result = price([{ product_id: A, quantity: 3 }], [product(A, { price: '0.1' })]);
  assert.equal(result.subtotalPaise, 30);
});

test('client-supplied discounts and prices are ignored', () => {
  const result = price([{ product_id: A, quantity: 1, price: 1, discount_percent: 50 }]);
  assert.equal(result.subtotalPaise, 100000);
  assert.equal(result.discountPaise, 0);
  assert.equal(result.orderItems[0].price, 1000);
  const request = parseCheckoutRequest({
    items: [{ product_id: A, quantity: 2 }],
    address: '12 MG Road, Jaipur 302001',
    phone: '98290 12345',
    discount_percent: 5,
    expected_total_paise: 198000,
  });
  assert.equal(request.ok, true);
  assert.equal('discountPercent' in request, false);
  const priced = price(request.items);
  assert.equal(priced.discountPercent, 1);
  assert.equal(priced.totalPaise, 200000 - 2000);
  assert.equal(matchesExpectedTotal(request.expectedTotalPaise, priced), true);
});

test('inactive, invalid and unsorted tiers from the database', () => {
  const tiers = [
    { min_subtotal: 4000, discount_percent: 1.7, is_active: true },
    { min_subtotal: 2000, discount_percent: 1, is_active: true },
    { min_subtotal: 3500, discount_percent: 9, is_active: false },
    { min_subtotal: 2500, discount_percent: 60 },
    { min_subtotal: null, discount_percent: 3 },
  ];
  assert.deepEqual(normalizeDiscountTiers(tiers), [
    { min_subtotal: 2000, discount_percent: 1 },
    { min_subtotal: 4000, discount_percent: 1.7 },
  ]);
  assert.equal(calculateTierDiscount(370000, tiers).discountPercent, 1);
  assert.deepEqual(calculateTierDiscount(370000, []), { tier: null, discountPercent: 0, discountPaise: 0 });
  assert.deepEqual(calculateTierDiscount(370000, null), { tier: null, discountPercent: 0, discountPaise: 0 });
});

test('stale total guard returns the server figures', () => {
  const priced = price([{ product_id: A, quantity: 3 }]);
  assert.equal(matchesExpectedTotal(295800, priced), true);
  assert.equal(matchesExpectedTotal('295800', priced), true);
  for (const stale of [295801, undefined, null, 'abc', 0]) {
    assert.equal(matchesExpectedTotal(stale, priced), false, String(stale));
  }
  assert.deepEqual(staleTotalBody(priced), {
    error: 'Your order total has changed. Please review the updated total and try again.',
    serverTotalPaise: 295800,
    discountPercent: 1.4,
    discountAmount: 42,
  });
});

test('checkout request validation', () => {
  const base = { items: [{ product_id: A, quantity: 1 }], address: '12 MG Road, Jaipur 302001', phone: '9829012345' };
  assert.deepEqual(parseCheckoutRequest(null), { ok: false, status: 400, error: 'Invalid checkout request' });
  assert.deepEqual(parseCheckoutRequest([]), { ok: false, status: 400, error: 'Invalid checkout request' });
  assert.deepEqual(parseCheckoutRequest({ ...base, items: [] }), { ok: false, status: 400, error: 'Cart is empty' });
  assert.deepEqual(parseCheckoutRequest({ ...base, address: 'short' }), { ok: false, status: 400, error: 'Enter a valid shipping address' });
  assert.deepEqual(parseCheckoutRequest({ ...base, address: 'x'.repeat(501) }), { ok: false, status: 400, error: 'Enter a valid shipping address' });
  assert.deepEqual(parseCheckoutRequest({ ...base, phone: '12345' }), { ok: false, status: 400, error: 'Enter a valid 10-digit phone number' });
  assert.deepEqual(parseCheckoutRequest({ ...base, items: [{ product_id: 'x', quantity: 1 }] }), { ok: false, status: 400, error: 'Invalid cart item' });
  const ok = parseCheckoutRequest({ ...base, address: '  12 MG Road, Jaipur 302001  ', phone: '98290-12345' });
  assert.equal(ok.ok, true);
  assert.equal(ok.address, '12 MG Road, Jaipur 302001');
  assert.equal(ok.phoneDigits, '9829012345');
  assert.deepEqual(ok.productIds, [A]);
  assert.deepEqual(ok.location, { latitude: null, longitude: null, label: null });
});

test('delivery location validation', () => {
  const okLocation = (lat, lng, label) => parseDeliveryLocation(lat, lng, label);
  assert.deepEqual(okLocation(26.9124, 75.7873, '  Near City Palace, Jaipur '), {
    ok: true, location: { latitude: 26.9124, longitude: 75.7873, label: 'Near City Palace, Jaipur' },
  });
  assert.deepEqual(okLocation(0, 0, undefined), { ok: true, location: { latitude: 0, longitude: 0, label: null } });
  assert.deepEqual(okLocation(-90, 180, ''), { ok: true, location: { latitude: -90, longitude: 180, label: null } });
  assert.deepEqual(okLocation(null, null, 'Landmark only'), { ok: true, location: { latitude: null, longitude: null, label: 'Landmark only' } });
  const bad = { ok: false, status: 400, error: 'Invalid delivery location' };
  for (const [lat, lng] of [[91, 0], [-91, 0], [0, 181], [0, -181], [26.9, null], [null, 75.7], ['26.9', '75.7'], [Number.NaN, 1], [1, Number.POSITIVE_INFINITY]]) {
    assert.deepEqual(okLocation(lat, lng, undefined), bad, `${lat},${lng}`);
  }
  assert.deepEqual(okLocation(1, 1, 42), bad);
  assert.deepEqual(okLocation(1, 1, 'x'.repeat(501)), { ok: false, status: 400, error: 'Delivery location description is too long' });
  const request = parseCheckoutRequest({
    items: [{ product_id: A, quantity: 1 }], address: '12 MG Road, Jaipur 302001', phone: '9829012345',
    latitude: 200, longitude: 75,
  });
  assert.deepEqual(request, bad);
});

test('PARITY: storefront discounts match server pricing for every subtotal', () => {
  const tierSets = [
    TIER_ROWS,
    [],
    [{ min_subtotal: 2000, discount_percent: 1 }],
    [
      { min_subtotal: 4000, discount_percent: 1.7 },
      { min_subtotal: 2000, discount_percent: 1.2 },
      { min_subtotal: 2000, discount_percent: 1 },
      { min_subtotal: 999.99, discount_percent: 0.33 },
      { min_subtotal: 3000, discount_percent: 2.25, is_active: false },
      { min_subtotal: 0, discount_percent: 5 },
      { min_subtotal: 5000, discount_percent: 51 },
    ],
  ];
  const subtotals = [
    0, 0.01, 1, 999.98, 999.99, 1000, 1999.99, 2000, 2000.01, 2000.5, 2999.99, 3000, 3000.01,
    3333.33, 3999.99, 4000, 4000.01, 4567.89, 9999.99, 123456.78,
  ];
  for (let paise = 0; paise <= 600000; paise += 37) subtotals.push(paise / 100);

  for (const tiers of tierSets) {
    const clientTiers = tiers.map((tier) => ({ ...tier, min_subtotal: Number(tier.min_subtotal), discount_percent: Number(tier.discount_percent) }));
    assert.deepEqual(sortTiers(clientTiers), normalizeDiscountTiers(tiers));
    for (const subtotal of subtotals) {
      const subtotalPaise = Math.round(subtotal * 100);
      const server = calculateTierDiscount(subtotalPaise, tiers);
      const client = calculateDiscount(subtotal, clientTiers);
      assert.equal(client.percent, server.discountPercent, `percent @ ${subtotal}`);
      assert.equal(Math.round(client.amount * 100), server.discountPaise, `amount @ ${subtotal}`);
      assert.deepEqual(client.tier, server.tier, `tier @ ${subtotal}`);
      assert.deepEqual(getActiveTier(subtotal, clientTiers), server.tier, `active tier @ ${subtotal}`);
    }
  }
});

test('PARITY: a priced cart total equals what the storefront would send', () => {
  const carts = [
    [{ product_id: C, quantity: 1 }],
    [{ product_id: A, quantity: 2 }],
    [{ product_id: `${B}:v1`, quantity: 10 }],
    [{ product_id: A, quantity: 2 }, { product_id: `${B}:v1`, quantity: 5 }, { product_id: C, quantity: 3 }],
    [{ product_id: A, quantity: 3 }, { product_id: `${B}:v0`, quantity: 7 }],
  ];
  for (const items of carts) {
    const priced = price(items, [...PRODUCTS.slice(0, 2), product(C, { price: 49.99, stock: 100 })]);
    assert.equal(priced.ok, true);
    // Storefront: subtotal summed in paise, then the lib's discount, then shipping.
    const subtotal = priced.subtotalPaise / 100;
    const discount = calculateDiscount(subtotal, TIER_ROWS.map((t) => ({ min_subtotal: Number(t.min_subtotal), discount_percent: Number(t.discount_percent) })));
    const expectedTotalPaise = priced.subtotalPaise - Math.round(discount.amount * 100);
    assert.equal(matchesExpectedTotal(expectedTotalPaise, priced), true, JSON.stringify(items));
  }
});
