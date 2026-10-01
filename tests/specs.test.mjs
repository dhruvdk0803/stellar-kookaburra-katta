import assert from 'node:assert/strict';
import test from 'node:test';
import {
  buildFallbackSpecs,
  getCustomerFacingSpecs,
  mergeSpecsForSave,
  splitSpecsForEditing,
  validateSpecRows,
} from '../src/lib/specs.ts';

test('customers never see internal, tax or placeholder specs', () => {
  const specs = {
    Material: ' Stainless steel ',
    Source: 'ebco-hinges-septemberbatch2',
    source: 'lowercase variant',
    'Demo Video': 'https://example.test/video',
    'Special Notes': 'owner-only',
    GST: '18%',
    'Tax note': 'Includes GST',
    Finish: '-',
    Size: '',
  };
  assert.deepEqual(getCustomerFacingSpecs(specs), [['Material', 'Stainless steel']]);
});

test('only text, numbers and booleans are shown; objects and arrays are not', () => {
  const specs = { Material: 'Steel', Rating: 4, Waterproof: true, Meta: { a: 1 }, Tags: ['x'], Nothing: null };
  assert.deepEqual(getCustomerFacingSpecs(specs), [
    ['Material', 'Steel'],
    ['Rating', '4'],
    ['Waterproof', 'true'],
  ]);
});

test('an empty or missing specs object yields no customer specs', () => {
  assert.deepEqual(getCustomerFacingSpecs({}), []);
  assert.deepEqual(getCustomerFacingSpecs(null), []);
  assert.deepEqual(getCustomerFacingSpecs(['not', 'an object']), []);
});

test('fallback specs use only brand, category and the option list', () => {
  const variants = [
    { label: '450x1320mm', type: 'size' },
    { label: '600x1320mm', type: 'size' },
  ];
  assert.deepEqual(
    buildFallbackSpecs({ brandName: 'Dorset', categoryName: 'Rolling Shutter', variants }),
    [
      ['Brand', 'Dorset'],
      ['Category', 'Rolling Shutter'],
      ['Available Sizes', '450x1320mm, 600x1320mm'],
    ],
  );
});

test('fallback labels the option list by its type and skips unknown categories', () => {
  assert.deepEqual(
    buildFallbackSpecs({ categoryName: 'Uncategorized', variants: [{ label: 'Matte black', type: 'colour' }] }),
    [['Available Colours', 'Matte black']],
  );
  assert.deepEqual(buildFallbackSpecs({ variants: [{ label: 'Premium' }] }), [['Available Options', 'Premium']]);
  assert.deepEqual(buildFallbackSpecs({ brandName: null, categoryName: null, variants: null }), []);
});

test('an option type that names an Object property is treated as an unknown type', () => {
  assert.deepEqual(
    buildFallbackSpecs({ variants: [{ label: 'A', type: 'constructor' }, { label: 'B', type: 'constructor' }] }),
    [['Available Options', 'A, B']],
  );
});

test('editing offers only the specs customers see and keeps everything else as stored', () => {
  let counter = 0;
  const { editable, preserved } = splitSpecsForEditing(
    {
      Material: 'Steel',
      Source: 'batch-x',
      GST: '18%',
      Note: 'Price includes GST',
      Rating: 5,
      'Size (inch)': '',
      Pack: ' - ',
    },
    () => `k${++counter}`,
  );
  assert.deepEqual(editable, [{ _key: 'k1', label: 'Material', value: 'Steel' }]);
  // Hidden or non-text entries are carried through untouched; blank leftovers are dropped.
  assert.deepEqual(preserved, { Source: 'batch-x', GST: '18%', Note: 'Price includes GST', Rating: 5 });
});

test('a product with legacy blank specs can be re-saved without touching them', () => {
  const { editable, preserved } = splitSpecsForEditing({ 'Size (inch)': '', Material: 'Steel' }, () => 'k');
  assert.equal(validateSpecRows(editable, Object.keys(preserved)), null);
  assert.deepEqual(mergeSpecsForSave(editable, preserved), { Material: 'Steel' });
});

test('saving merges edited rows with the preserved entries and drops blank rows', () => {
  const saved = mergeSpecsForSave(
    [
      { label: ' Finish ', value: ' Matte ' },
      { label: '', value: '' },
      { label: 'Size', value: '-' },
    ],
    { Source: 'batch-x' },
  );
  assert.deepEqual(saved, { Finish: 'Matte', Source: 'batch-x' });
  assert.deepEqual(mergeSpecsForSave([], {}), {});
});

test('a row cannot overwrite an internal key', () => {
  assert.deepEqual(
    mergeSpecsForSave([{ label: 'Source', value: 'typed' }], { Source: 'batch-x' }),
    { Source: 'batch-x' },
  );
});

test('validation rejects half-filled, reserved, hidden and duplicate rows', () => {
  assert.equal(validateSpecRows([{ label: 'Finish', value: 'Matte' }, { label: '', value: '' }]), null);
  assert.match(validateSpecRows([{ label: 'Finish', value: '' }]), /needs both a name and a value/);
  assert.match(validateSpecRows([{ label: 'Finish', value: '-' }]), /needs both a name and a value/);
  assert.match(validateSpecRows([{ label: '', value: 'Matte' }]), /needs both a name and a value/);
  assert.match(validateSpecRows([{ label: 'Source', value: 'x' }]), /reserved/);
  assert.match(validateSpecRows([{ label: 'source', value: 'x' }]), /reserved/);
  assert.match(validateSpecRows([{ label: 'Gst', value: '18%' }]), /reserved/);
  assert.match(validateSpecRows([{ label: 'Warranty', value: '1 year (GST bill needed)' }]), /mentions GST/);
  assert.match(
    validateSpecRows([{ label: 'Finish', value: 'A' }, { label: 'finish', value: 'B' }]),
    /listed twice/,
  );
});

test('a new row cannot reuse the name of an entry that is kept as stored', () => {
  assert.match(
    validateSpecRows([{ label: 'rating', value: '4.5' }], ['Rating']),
    /already exists on this product/,
  );
  assert.equal(validateSpecRows([{ label: 'Finish', value: 'Matte' }], ['Rating']), null);
});
