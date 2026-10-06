import assert from 'node:assert/strict';
import test from 'node:test';
import { formatProductCounts, getProductCounts } from '../src/lib/productCounts.ts';

const live = (id) => ({ id, is_active: true });
const draft = (id) => ({ id, is_active: false });

const assertInvariants = (counts) => {
  assert.ok(counts.shown <= counts.total, 'shown <= total');
  assert.ok(counts.live <= counts.total, 'live <= total');
  assert.ok(counts.draft <= counts.total, 'draft <= total');
  assert.equal(counts.live + counts.draft, counts.total, 'live + draft === total');
};

test('counts live and draft products and the filtered subset', () => {
  const all = [live(1), live(2), draft(3), live(4), draft(5)];
  const counts = getProductCounts(all, [all[0], all[2]]);
  assert.deepEqual(counts, { shown: 2, total: 5, live: 3, draft: 2 });
  assertInvariants(counts);
});

test('missing or null is_active counts as live, like the form, filter and badges', () => {
  const all = [{ id: 1 }, { id: 2, is_active: null }, { id: 3, is_active: undefined }, draft(4)];
  const counts = getProductCounts(all, all);
  assert.deepEqual(counts, { shown: 4, total: 4, live: 3, draft: 1 });
  assertInvariants(counts);
});

test('an unfiltered list shows everything and a fully filtered list shows nothing', () => {
  const all = [live(1), draft(2), live(3)];
  assert.equal(getProductCounts(all, all).shown, 3);
  assert.deepEqual(getProductCounts(all, []), { shown: 0, total: 3, live: 2, draft: 1 });
});

test('empty, null and undefined inputs give all zeros without throwing', () => {
  const zeros = { shown: 0, total: 0, live: 0, draft: 0 };
  assert.deepEqual(getProductCounts([], []), zeros);
  assert.deepEqual(getProductCounts(null, null), zeros);
  assert.deepEqual(getProductCounts(undefined, undefined), zeros);
  assert.deepEqual(getProductCounts(undefined, [live(1)]), zeros);
});

test('shown never exceeds total even if the caller passes a stale, larger list', () => {
  const all = [live(1), draft(2)];
  const counts = getProductCounts(all, [live(1), live(2), live(3), draft(4)]);
  assert.equal(counts.shown, 2);
  assertInvariants(counts);
});

test('stray null rows are ignored rather than counted or thrown on', () => {
  const all = [live(1), null, draft(2), undefined];
  const counts = getProductCounts(all, [null, live(1)]);
  assert.deepEqual(counts, { shown: 1, total: 2, live: 1, draft: 1 });
  assertInvariants(counts);
});

test('invariants hold across a spread of generated catalogues, including more than 1,000 rows', () => {
  for (const size of [0, 1, 7, 999, 1000, 1001, 2500]) {
    const all = Array.from({ length: size }, (_, index) => ({ id: index, is_active: index % 3 === 0 ? false : index % 3 === 1 ? true : null }));
    for (const shown of [[], all.slice(0, Math.floor(size / 2)), all]) {
      const counts = getProductCounts(all, shown);
      assertInvariants(counts);
      assert.equal(counts.total, size);
    }
  }
});

test('formatProductCounts renders the Product List title text', () => {
  const all = [live(1), live(2), draft(3)];
  assert.equal(formatProductCounts(getProductCounts(all, [all[1]])), '1 shown · 3 total · 2 live · 1 draft');
});
