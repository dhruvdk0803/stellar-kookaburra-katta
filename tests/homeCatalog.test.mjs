import assert from 'node:assert/strict';
import test from 'node:test';
import { isNewProduct, pickHomeCategories, pickNewArrivals } from '../src/lib/homeCatalog.ts';

const row = (over) => ({ parent_id: null, image_url: null, thumbnail_url: null, display_order: 0, product_count: 1, ...over });

// A slice of the live tree: real roots, brand-folder roots and their children.
const tree = [
  row({ id: 'sun', name: 'Sunmica', slug: 'laminates', root_id: 'sun', root_name: 'Sunmica', product_count: 323 }),
  row({ id: 'sun-08', name: '0.8mm – Rockstar', slug: '0-8mm-rockstar', parent_id: 'sun', root_id: 'sun', root_name: 'Sunmica', product_count: 259, thumbnail_url: '/rock.jpg' }),
  row({ id: 'apollo', name: 'Apollo', slug: 'apollo', root_id: 'apollo', root_name: 'Apollo', product_count: 86 }),
  row({ id: 'cpvc', name: 'CPVC & UPVC Fittings', slug: 'apollo-cpvc-fittings-pipes', parent_id: 'apollo', root_id: 'apollo', root_name: 'Apollo', product_count: 86 }),
  row({ id: 'ebco', name: 'Ebco', slug: 'ebco', root_id: 'ebco', root_name: 'Ebco', product_count: 13 }),
  row({ id: 'ebco-locks', name: 'Digital Locks', slug: 'ebco-digital-locks', parent_id: 'ebco', root_id: 'ebco', root_name: 'Ebco', product_count: 13 }),
  row({ id: 'lock', name: 'Digital Lock', slug: 'digital-lock', root_id: 'lock', root_name: 'Digital Lock', product_count: 15 }),
  row({ id: 'cement', name: 'Cement', slug: 'cement', root_id: 'cement', root_name: 'Cement', product_count: 1, created_at: '2026-10-03' }),
];
const brands = ['Apollo', 'Ebco', 'Rockstar'];

test('brand-folder roots are replaced by their children', () => {
  const slugs = pickHomeCategories(tree, brands).map((c) => c.slug);
  assert.ok(slugs.includes('apollo-cpvc-fittings-pipes'));
  assert.ok(!slugs.includes('apollo'));
  assert.ok(!slugs.includes('ebco'));
});

test('a new root category added in the admin shows up with no code change', () => {
  const added = [...tree, row({ id: 'ply', name: 'Plywood', slug: 'plywood', root_id: 'ply', root_name: 'Plywood', product_count: 4 })];
  assert.ok(pickHomeCategories(added, brands).some((c) => c.slug === 'plywood'));
});

test('children of real roots stay inside their parent card', () => {
  assert.ok(!pickHomeCategories(tree, brands).some((c) => c.slug === '0-8mm-rockstar'));
});

test('same-name categories collapse into the bigger one', () => {
  const locks = pickHomeCategories(tree, brands).filter((c) => /digital lock/i.test(c.name));
  assert.equal(locks.length, 1);
  assert.equal(locks[0].slug, 'digital-lock');
});

test('ordered by admin display order, then size', () => {
  const ordered = pickHomeCategories([...tree, row({ id: 'x', name: 'Pinned', slug: 'pinned', root_id: 'x', root_name: 'Pinned', display_order: -1 })], brands);
  assert.equal(ordered[0].slug, 'pinned');
  assert.equal(ordered[1].slug, 'laminates');
});

test('a category with no photo borrows a child photo', () => {
  assert.equal(pickHomeCategories(tree, brands).find((c) => c.slug === 'laminates').image, '/rock.jpg');
});

test('without the brand list every root still shows', () => {
  assert.ok(pickHomeCategories(tree, []).some((c) => c.slug === 'apollo'));
});

const product = (id, category_id, day) => ({ id, name: id, price: 100, category_id, created_at: `2026-10-${String(day).padStart(2, '0')}T00:00:00Z` });

test('new arrivals: newest first, one per category before repeats', () => {
  const rows = [
    product('lock1', 'lock', 12), product('lock2', 'lock', 11), product('lock3', 'lock', 10),
    product('hinge', 'hinge', 5), product('glue', 'glue', 3),
  ];
  const picks = pickNewArrivals(rows, 4).map((p) => p.id);
  assert.deepEqual(picks, ['lock1', 'lock2', 'hinge', 'glue']);
});

test('the newest product is always included', () => {
  const rows = [product('old', 'a', 1), product('fresh', 'a', 15)];
  assert.equal(pickNewArrivals(rows, 1)[0].id, 'fresh');
});

test('New badge lasts 30 days', () => {
  const now = Date.parse('2026-10-16T00:00:00Z');
  assert.ok(isNewProduct('2026-10-01T00:00:00Z', now));
  assert.ok(!isNewProduct('2026-09-01T00:00:00Z', now));
});

test('card price: lowest option, flagged "from" only when options differ', async () => {
  const { cardPrice } = await import('../src/lib/homeCatalog.ts');
  assert.deepEqual(cardPrice({ price: 9300, variants: [{ price: 9300 }, { price: 10300 }] }), { amount: 9300, from: true });
  assert.deepEqual(cardPrice({ price: 500, variants: [{ price: '420' }] }), { amount: 420, from: true });
  assert.deepEqual(cardPrice({ price: 40, variants: null }), { amount: 40, from: false });
  assert.equal(cardPrice({ price: null, variants: [] }), null);
});

test('brand name from an object or array embed', async () => {
  const { productBrand } = await import('../src/lib/homeCatalog.ts');
  assert.equal(productBrand({ brands: { name: 'Ebco' } }), 'Ebco');
  assert.equal(productBrand({ brands: [{ name: 'Dorset' }] }), 'Dorset');
  assert.equal(productBrand({ brands: null }), undefined);
});
