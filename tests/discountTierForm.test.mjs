import assert from 'node:assert/strict';
import test from 'node:test';
import { isMissingTableError, tierSavingAtMinimum, validateTierInput } from '../src/lib/discountTierForm.ts';

const existing = [
  { id: 'a', min_subtotal: 2000 },
  { id: 'b', min_subtotal: '3000.00' },
];

test('accepts a valid tier and returns clean numbers', () => {
  assert.deepEqual(validateTierInput({ min: '5000', percent: '2' }, existing), { ok: true, min_subtotal: 5000, discount_percent: 2 });
  assert.deepEqual(validateTierInput({ min: ' ₹2,499.50 ', percent: ' 1.75% ' }, existing), { ok: true, min_subtotal: 2499.5, discount_percent: 1.75 });
  assert.deepEqual(validateTierInput({ min: '0.01', percent: '50' }, existing), { ok: true, min_subtotal: 0.01, discount_percent: 50 });
});

test('minimum must be a positive plain number with at most 2 decimals', () => {
  for (const min of ['', '  ', 'abc', '0', '0.00', '-5', '1e3', '12.345', '1,2,3.4x', '--1']) {
    const result = validateTierInput({ min, percent: '1' }, existing);
    assert.equal(result.ok, false, `min "${min}" should be rejected`);
    assert.equal(result.field, 'min');
  }
  assert.equal(validateTierInput({ min: '10000000000', percent: '1' }, []).ok, false, 'beyond numeric(12,2)');
});

test('percent must be above 0 and at most 50, with at most 2 decimals', () => {
  for (const percent of ['', 'x', '0', '0.00', '-1', '50.01', '51', '100', '1.234', '1e1']) {
    const result = validateTierInput({ min: '5000', percent }, existing);
    assert.equal(result.ok, false, `percent "${percent}" should be rejected`);
    assert.equal(result.field, 'percent');
  }
  assert.equal(validateTierInput({ min: '5000', percent: '50' }, existing).ok, true);
});

test('a duplicate minimum is rejected, but a row may keep its own minimum while editing', () => {
  const duplicate = validateTierInput({ min: '3000', percent: '1.5' }, existing);
  assert.equal(duplicate.ok, false);
  assert.equal(duplicate.field, 'min');
  assert.match(duplicate.error, /already exists/);
  assert.equal(validateTierInput({ min: '3000.0', percent: '1.5' }, existing).ok, false, 'same value written differently');
  assert.equal(validateTierInput({ min: '3000', percent: '1.5' }, existing, 'b').ok, true, 'editing tier b itself');
  assert.equal(validateTierInput({ min: '2000', percent: '1.5' }, existing, 'b').ok, false, 'editing b into a\'s minimum');
});

test('the first problem is reported (minimum before percent)', () => {
  const result = validateTierInput({ min: '', percent: '' }, existing);
  assert.equal(result.ok, false);
  assert.equal(result.field, 'min');
});

test('saving example matches the storefront rule (3000 at 1.4% = 42)', () => {
  assert.equal(tierSavingAtMinimum(3000, 1.4), 42);
  assert.equal(tierSavingAtMinimum(2000, 1), 20);
  assert.equal(tierSavingAtMinimum(2499.5, 1.75), 43.74);
});

test('recognises a missing discount_tiers table', () => {
  assert.equal(isMissingTableError({ code: '42P01', message: 'relation "public.discount_tiers" does not exist' }), true);
  assert.equal(isMissingTableError({ code: 'PGRST205', message: "Could not find the table 'public.discount_tiers' in the schema cache" }), true);
  assert.equal(isMissingTableError({ message: "Could not find the table 'public.discount_tiers' in the schema cache" }), true);
  assert.equal(isMissingTableError({ code: '42501', message: 'permission denied for table discount_tiers' }), false);
  assert.equal(isMissingTableError(null), false);
  assert.equal(isMissingTableError('boom'), false);
});
