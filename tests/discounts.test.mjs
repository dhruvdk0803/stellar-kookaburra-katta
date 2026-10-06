import assert from 'node:assert/strict';
import test from 'node:test';
import {
  calculateDiscount,
  calculateOrderTotals,
  formatDiscountPercent,
  getActiveTier,
  getNextTier,
  SHIPPING_FEE,
  sortTiers,
} from '../src/lib/discounts.ts';

const TIERS = [
  { min_subtotal: 2000, discount_percent: 1 },
  { min_subtotal: 3000, discount_percent: 1.4 },
  { min_subtotal: 4000, discount_percent: 1.7 },
];

test('shipping is a flat ₹100', () => {
  assert.equal(SHIPPING_FEE, 100);
});

test('tier boundaries: a tier applies from exactly its threshold', () => {
  assert.equal(getActiveTier(1999.99, TIERS), null);
  assert.deepEqual(getActiveTier(2000, TIERS), { min_subtotal: 2000, discount_percent: 1 });
  assert.deepEqual(getActiveTier(2999.99, TIERS), { min_subtotal: 2000, discount_percent: 1 });
  assert.deepEqual(getActiveTier(3000, TIERS), { min_subtotal: 3000, discount_percent: 1.4 });
  assert.deepEqual(getActiveTier(3999.99, TIERS), { min_subtotal: 3000, discount_percent: 1.4 });
  assert.deepEqual(getActiveTier(4000, TIERS), { min_subtotal: 4000, discount_percent: 1.7 });
  assert.deepEqual(getActiveTier(250000, TIERS), { min_subtotal: 4000, discount_percent: 1.7 });
});

test('the percent applies to the whole subtotal, never marginally or stacked', () => {
  assert.deepEqual(calculateDiscount(1999.99, TIERS), { percent: 0, amount: 0, tier: null });
  assert.deepEqual(calculateDiscount(2000, TIERS), { percent: 1, amount: 20, tier: TIERS[0] });
  assert.deepEqual(calculateDiscount(3000, TIERS), { percent: 1.4, amount: 42, tier: TIERS[1] });
  assert.deepEqual(calculateDiscount(4000, TIERS), { percent: 1.7, amount: 68, tier: TIERS[2] });
  // 1.7% of 5000 = 85 (a marginal scheme would give 20 + 14 + 17 = 51).
  assert.equal(calculateDiscount(5000, TIERS).amount, 85);
});

test('no tiers, empty or invalid input means no discount', () => {
  for (const tiers of [[], null, undefined]) {
    assert.deepEqual(calculateDiscount(5000, tiers), { percent: 0, amount: 0, tier: null });
    assert.equal(getActiveTier(5000, tiers), null);
    assert.equal(getNextTier(5000, tiers), null);
  }
  for (const subtotal of [0, -10, Number.NaN, Number.POSITIVE_INFINITY]) {
    assert.deepEqual(calculateDiscount(subtotal, TIERS), { percent: 0, amount: 0, tier: null });
  }
});

test('sortTiers sorts ascending and drops inactive, invalid and out-of-range tiers', () => {
  const messy = [
    { min_subtotal: 4000, discount_percent: 1.7 },
    { min_subtotal: 2000, discount_percent: 1 },
    { min_subtotal: 0, discount_percent: 5 },
    { min_subtotal: -100, discount_percent: 5 },
    { min_subtotal: 1000, discount_percent: 0 },
    { min_subtotal: 1500, discount_percent: 50.01 },
    { min_subtotal: 1600, discount_percent: Number.NaN },
    { min_subtotal: Number.NaN, discount_percent: 2 },
    { min_subtotal: 2500, discount_percent: 3, is_active: false },
    null,
    'junk',
    { min_subtotal: 3000, discount_percent: 1.4 },
  ];
  assert.deepEqual(sortTiers(messy), TIERS);
  // A 50% tier is the maximum allowed and is kept.
  assert.deepEqual(sortTiers([{ min_subtotal: 100, discount_percent: 50 }]), [{ min_subtotal: 100, discount_percent: 50 }]);
});

test('unsorted and duplicate tiers: the highest threshold applies; a duplicate keeps the higher percent', () => {
  const unsorted = [TIERS[2], TIERS[0], TIERS[1]];
  assert.equal(calculateDiscount(3500, unsorted).percent, 1.4);
  const duplicates = [
    { min_subtotal: 2000, discount_percent: 1 },
    { min_subtotal: 2000, discount_percent: 1.2 },
    { min_subtotal: 3000, discount_percent: 1.4 },
  ];
  assert.deepEqual(sortTiers(duplicates), [
    { min_subtotal: 2000, discount_percent: 1.2 },
    { min_subtotal: 3000, discount_percent: 1.4 },
  ]);
  assert.equal(calculateDiscount(2500, duplicates).amount, 30);
});

test('inactive tiers are ignored even when passed in', () => {
  const tiers = [...TIERS, { min_subtotal: 5000, discount_percent: 10, is_active: false }];
  assert.equal(calculateDiscount(6000, tiers).percent, 1.7);
  assert.equal(getNextTier(4500, tiers), null);
});

test('next-tier hint: what to add to unlock the next tier', () => {
  assert.deepEqual(getNextTier(0, TIERS), { tier: TIERS[0], amountToUnlock: 2000 });
  assert.deepEqual(getNextTier(1500, TIERS), { tier: TIERS[0], amountToUnlock: 500 });
  assert.deepEqual(getNextTier(1999.99, TIERS), { tier: TIERS[0], amountToUnlock: 0.01 });
  assert.deepEqual(getNextTier(2000, TIERS), { tier: TIERS[1], amountToUnlock: 1000 });
  assert.deepEqual(getNextTier(2999.99, TIERS), { tier: TIERS[1], amountToUnlock: 0.01 });
  assert.deepEqual(getNextTier(3210.55, TIERS), { tier: TIERS[2], amountToUnlock: 789.45 });
  assert.equal(getNextTier(4000, TIERS), null);
  assert.equal(getNextTier(10000, TIERS), null);
});

test('discounts are exact to the paisa with half-up rounding', () => {
  // 1% of 2000.50 = 20.005 -> 20.01
  assert.equal(calculateDiscount(2000.5, TIERS).amount, 20.01);
  // 1% of 2000.49 = 20.0049 -> 20.00
  assert.equal(calculateDiscount(2000.49, TIERS).amount, 20);
  // 1.4% of 3333.33 = 46.66662 -> 46.67
  assert.equal(calculateDiscount(3333.33, TIERS).amount, 46.67);
  // 1.7% of 4567.89 = 77.65413 -> 77.65
  assert.equal(calculateDiscount(4567.89, TIERS).amount, 77.65);
  // Float noise from summing cart prices does not change the result.
  assert.equal(calculateDiscount(0.1 * 3 * 10000, TIERS).amount, calculateDiscount(3000, TIERS).amount);
  // Amounts are always whole paise.
  for (let rupees = 1990; rupees < 4100; rupees += 7.37) {
    const { amount } = calculateDiscount(rupees, TIERS);
    assert.equal(Math.round(amount * 100) / 100, amount);
  }
});

test('order totals: discount on the subtotal only, shipping added after', () => {
  assert.deepEqual(calculateOrderTotals(3000, TIERS), {
    subtotal: 3000,
    discountPercent: 1.4,
    discountAmount: 42,
    shipping: 100,
    total: 3058,
    totalPaise: 305800,
    tier: TIERS[1],
  });
  assert.equal(calculateOrderTotals(500, TIERS).totalPaise, 60000);
  assert.equal(calculateOrderTotals(1999.99, []).totalPaise, 209999);
});

test('formatDiscountPercent', () => {
  assert.equal(formatDiscountPercent(1), '1%');
  assert.equal(formatDiscountPercent(1.4), '1.4%');
  assert.equal(formatDiscountPercent(1.7), '1.7%');
  assert.equal(formatDiscountPercent(1.75), '1.75%');
  assert.equal(formatDiscountPercent(1.5), '1.5%');
  assert.equal(formatDiscountPercent(0), '0%');
  assert.equal(formatDiscountPercent(Number.NaN), '0%');
});
