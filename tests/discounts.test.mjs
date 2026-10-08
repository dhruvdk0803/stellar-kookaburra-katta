import assert from 'node:assert/strict';
import test from 'node:test';
import {
  calculateDiscount,
  calculateOrderTotals,
  formatDiscountPercent,
  MAX_DISCOUNT_PERCENT,
  SHIPPING_FEE,
} from '../src/lib/discounts.ts';

test('shipping is free and the cap is 5%', () => {
  assert.equal(SHIPPING_FEE, 0);
  assert.equal(MAX_DISCOUNT_PERCENT, 5);
});

test('calculateDiscount applies the percent to the whole subtotal, no minimum order', () => {
  assert.deepEqual(calculateDiscount(3000, 2.37), { percent: 2.37, amount: 71.1 });
  assert.deepEqual(calculateDiscount(100, 5), { percent: 5, amount: 5 });
  // No minimum order: even a tiny cart gets its percent.
  assert.deepEqual(calculateDiscount(10, 3), { percent: 3, amount: 0.3 });
});

test('calculateDiscount rounds the amount to the nearest paisa (half up in paise)', () => {
  // 1234.56 * 2.37% = 29.259... -> 29.26
  assert.equal(calculateDiscount(1234.56, 2.37).amount, 29.26);
  // 0.5 paise rounds up: 10.10 at 2.5% = 25.25 paise -> 25 paise; 10.30 at 2.5% = 25.75 -> 26
  assert.equal(calculateDiscount(10.1, 2.5).amount, 0.25);
  assert.equal(calculateDiscount(10.3, 2.5).amount, 0.26);
  // no float drift: 0.1 + 0.2 style subtotals
  assert.equal(calculateDiscount(0.1 + 0.2, 5).amount, 0.02);
});

test('calculateDiscount clamps the percent to [0, 5] and ignores bad input', () => {
  assert.deepEqual(calculateDiscount(1000, 50), { percent: 5, amount: 50 });
  assert.deepEqual(calculateDiscount(1000, -3), { percent: 0, amount: 0 });
  for (const bad of [NaN, Infinity, undefined, null, 'abc']) {
    assert.deepEqual(calculateDiscount(1000, bad), { percent: 0, amount: 0 }, String(bad));
  }
  assert.deepEqual(calculateDiscount(1000, '2.5'), { percent: 2.5, amount: 25 });
});

test('calculateDiscount gives nothing on an empty or invalid subtotal', () => {
  assert.equal(calculateDiscount(0, 3).amount, 0);
  assert.equal(calculateDiscount(-100, 3).amount, 0);
  assert.equal(calculateDiscount(NaN, 3).amount, 0);
});

test('calculateOrderTotals: discount comes off the subtotal and shipping is free', () => {
  const totals = calculateOrderTotals(3250, 2.37);
  assert.deepEqual(totals, {
    subtotal: 3250,
    discountPercent: 2.37,
    discountAmount: 77.03, // 325000 * 237 / 10000 = 7702.5 paise -> 7703
    shipping: 0,
    total: 3172.97,
    totalPaise: 317_297,
  });
  assert.equal('tier' in totals, false);
});

test('calculateOrderTotals at 0% is just the subtotal', () => {
  assert.deepEqual(calculateOrderTotals(1999.99, 0), {
    subtotal: 1999.99,
    discountPercent: 0,
    discountAmount: 0,
    shipping: 0,
    total: 1999.99,
    totalPaise: 199_999,
  });
  assert.equal(calculateOrderTotals(0, 4).totalPaise, 0);
});

test('totalPaise is an integer and always subtotal - discount', () => {
  for (const [subtotal, percent] of [[0.01, 5], [99.99, 1.01], [123456.78, 4.99], [5, 0.01]]) {
    const t = calculateOrderTotals(subtotal, percent);
    assert.ok(Number.isInteger(t.totalPaise));
    assert.equal(t.totalPaise, Math.round(subtotal * 100) - Math.round(t.discountAmount * 100));
    assert.ok(t.discountAmount <= subtotal * 0.05 + 0.01);
  }
});

test('formatDiscountPercent keeps at most 2 decimals and trims trailing zeros', () => {
  assert.equal(formatDiscountPercent(5), '5%');
  assert.equal(formatDiscountPercent(2.37), '2.37%');
  assert.equal(formatDiscountPercent(2.5), '2.5%');
  assert.equal(formatDiscountPercent(1.4), '1.4%');
  assert.equal(formatDiscountPercent(2.3749), '2.37%');
  assert.equal(formatDiscountPercent(0), '0%');
  assert.equal(formatDiscountPercent(NaN), '0%');
});
