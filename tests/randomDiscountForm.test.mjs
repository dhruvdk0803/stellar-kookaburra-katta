import assert from 'node:assert/strict';
import test from 'node:test';
import { isMissingTableError, validateRandomDiscountInput } from '../src/lib/randomDiscountForm.ts';

test('accepts a valid range and returns clean numbers', () => {
  assert.deepEqual(validateRandomDiscountInput({ min: '0.5', max: '5' }), { ok: true, min_percent: 0.5, max_percent: 5 });
  assert.deepEqual(validateRandomDiscountInput({ min: ' 1.25% ', max: ' 3.5 % ' }), { ok: true, min_percent: 1.25, max_percent: 3.5 });
  assert.deepEqual(validateRandomDiscountInput({ min: '2', max: '2' }), { ok: true, min_percent: 2, max_percent: 2 });
  assert.deepEqual(validateRandomDiscountInput({ min: '.5', max: '5.00' }), { ok: true, min_percent: 0.5, max_percent: 5 });
});

test('minimum must be above 0, at most 5, plain with 2 decimals', () => {
  for (const min of ['', '  ', 'abc', '0', '0.00', '-1', '1e1', '1.234', '5.01', '6', '--1']) {
    const result = validateRandomDiscountInput({ min, max: '5' });
    assert.equal(result.ok, false, `min "${min}" should be rejected`);
    assert.equal(result.field, 'min');
  }
});

test('maximum must be above 0, at most 5, plain with 2 decimals', () => {
  for (const max of ['', 'x', '0', '-2', '5.01', '10', '2.999']) {
    const result = validateRandomDiscountInput({ min: '1', max });
    assert.equal(result.ok, false, `max "${max}" should be rejected`);
    assert.equal(result.field, 'max');
  }
});

test('minimum cannot exceed the maximum', () => {
  const result = validateRandomDiscountInput({ min: '3', max: '2' });
  assert.equal(result.ok, false);
  assert.equal(result.field, 'min');
  assert.match(result.error, /cannot be higher/);
});

test('isMissingTableError recognises a table that is not there yet', () => {
  assert.equal(isMissingTableError({ code: '42P01', message: 'x' }), true);
  assert.equal(isMissingTableError({ code: 'PGRST205', message: 'x' }), true);
  assert.equal(isMissingTableError({ message: 'relation "public.discount_settings" does not exist' }), true);
  assert.equal(isMissingTableError({ code: '42501', message: 'permission denied' }), false);
  assert.equal(isMissingTableError(null), false);
});
