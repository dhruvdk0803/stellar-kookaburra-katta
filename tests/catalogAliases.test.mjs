import assert from 'node:assert/strict';
import test from 'node:test';
import {
  categorySelectionFromParams,
  countProductsPerCategory,
  productBrowsingCategories,
  productCategoryLabel,
  productMatchesSelectedCategories,
  resolveLegacyCategoryAlias,
} from '../src/lib/categories.ts';
import { brandInitials } from '../src/lib/brands.ts';

test('retired category slugs resolve to the category they were merged into', () => {
  assert.equal(resolveLegacyCategoryAlias('ebco-hinges'), 'hinges');
  assert.equal(resolveLegacyCategoryAlias(' EBCO-Hinges '), 'hinges');
});

test('old CPVC labels resolve to the unchanged CPVC slug; current slugs and names pass through', () => {
  assert.equal(resolveLegacyCategoryAlias('CPVC Pipes & Fittings'), 'apollo-cpvc-fittings-pipes');
  assert.equal(resolveLegacyCategoryAlias('CPVC Fittings & Pipes'), 'apollo-cpvc-fittings-pipes');
  assert.equal(resolveLegacyCategoryAlias('apollo-cpvc-fittings-pipes'), 'apollo-cpvc-fittings-pipes');
  assert.equal(resolveLegacyCategoryAlias('apollo-upvc-pipes-fittings'), 'apollo-cpvc-fittings-pipes');
  assert.equal(resolveLegacyCategoryAlias('uPVC & SWR Pipes'), 'apollo-cpvc-fittings-pipes');
  assert.equal(resolveLegacyCategoryAlias('astral-cpvc-pipes-fittings'), 'astral-cpvc-pipes-fittings');
  assert.equal(resolveLegacyCategoryAlias('CPVC and UPVC Fittings'), 'CPVC and UPVC Fittings');
  assert.equal(resolveLegacyCategoryAlias('Plywood'), 'Plywood');
  assert.equal(resolveLegacyCategoryAlias(''), '');
});

test('shop URL category values are resolved one by one and keep their order', () => {
  const params = new URLSearchParams('category=ebco-hinges&category=lift-up&brand=ebco&category=CPVC%20Pipes%20%26%20Fittings');
  assert.deepEqual(categorySelectionFromParams(params), ['hinges', 'lift-up', 'apollo-cpvc-fittings-pipes']);
  assert.deepEqual(categorySelectionFromParams(new URLSearchParams('brand=ebco')), []);
});

test('the renamed CPVC category keeps its label and brand names stay out of category labels', () => {
  assert.equal(productCategoryLabel('CPVC and UPVC Fittings'), 'CPVC and UPVC Fittings');
  assert.equal(productCategoryLabel('1.3mm – Thermoluxe'), '1.3mm');
  assert.equal(productCategoryLabel('Apollo'), '');
});

test('brand-named parents are hidden and the renamed CPVC category is promoted under its own label', () => {
  const categories = [
    { id: 'apollo', name: 'Apollo', parent_id: null },
    { id: 'cpvc', name: 'CPVC and UPVC Fittings', parent_id: 'apollo' },
    { id: 'upvc', name: 'uPVC Pipes & Fittings', parent_id: 'apollo' },
  ];
  const visible = productBrowsingCategories(categories);
  assert.deepEqual(visible.map((c) => [c.id, c.name, c.parent_id]), [
    ['cpvc', 'CPVC and UPVC Fittings', null],
    ['upvc', 'uPVC Pipes & Fittings', null],
  ]);
});

// The Furniture Fitting tree as it stands after 20261001000000: Ebco's hinges
// were moved into "hinges" and Ebco's drawer slides were re-parented.
const furnitureTree = [
  { id: 'ebco', name: 'Ebco', slug: 'ebco', parent_id: null },
  { id: 'ff', name: 'Furniture Fitting', slug: 'furniture-fitting', parent_id: null },
  { id: 'hinges', name: 'Hinges', slug: 'hinges', parent_id: 'ff' },
  { id: 'slides', name: 'Drawer Slides', slug: 'ebco-drawer-slides', parent_id: 'ff' },
  { id: 'lift', name: 'Lift Up', slug: 'lift-up', parent_id: 'ff' },
  { id: 'locks', name: 'Digital Locks', slug: 'ebco-digital-locks', parent_id: 'ebco' },
];
const furnitureProducts = [
  { id: 'p1', category_id: 'hinges' },
  { id: 'p2', category_id: 'hinges' },
  { id: 'p3', category_id: 'slides' },
  { id: 'p4', category_id: 'lift' },
  { id: 'p5', category_id: 'locks' },
];

test('selecting Furniture Fitting lists each descendant product exactly once', () => {
  const byId = new Map(furnitureTree.map((c) => [c.id, c]));
  const listed = furnitureProducts.filter((p) => productMatchesSelectedCategories(p, ['furniture-fitting'], byId));
  assert.deepEqual(listed.map((p) => p.id), ['p1', 'p2', 'p3', 'p4']);
  assert.equal(new Set(listed.map((p) => p.id)).size, listed.length);
});

test('the old Ebco Hinges link lists the merged hinges, and selecting both slugs does not repeat a product', () => {
  const byId = new Map(furnitureTree.map((c) => [c.id, c]));
  const params = new URLSearchParams('category=ebco-hinges');
  const viaOldLink = furnitureProducts.filter((p) => productMatchesSelectedCategories(p, categorySelectionFromParams(params), byId));
  assert.deepEqual(viaOldLink.map((p) => p.id), ['p1', 'p2']);

  const both = furnitureProducts.filter((p) => productMatchesSelectedCategories(p, ['hinges', 'furniture-fitting'], byId));
  assert.deepEqual(both.map((p) => p.id), ['p1', 'p2', 'p3', 'p4']);
});

test('category counts roll up once: Furniture Fitting equals the sum of its children', () => {
  const counts = countProductsPerCategory(furnitureTree, furnitureProducts.map((p) => p.category_id));
  assert.equal(counts.get('hinges'), 2);
  assert.equal(counts.get('ff'), 4);
  assert.equal(counts.get('ebco'), 1);
});

test('brand initials stand in for a missing logo', () => {
  assert.equal(brandInitials('Ebco'), 'EB');
  assert.equal(brandInitials('Birla White'), 'BW');
  assert.equal(brandInitials('APL Apollo'), 'AA');
  assert.equal(brandInitials('  gloirio  '), 'GL');
  assert.equal(brandInitials('X'), 'X');
  assert.equal(brandInitials(''), '?');
  assert.equal(brandInitials(null), '?');
});
