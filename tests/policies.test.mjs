import assert from 'node:assert/strict';
import test from 'node:test';
import {
  buildPolicyPayload,
  DEFAULT_REPLACEMENT_NOTE,
  DEFAULT_RETURN_POLICY,
  getProductPolicies,
  normalizePolicyForSave,
  POLICY_MAX_LENGTH,
} from '../src/lib/policies.ts';

test('saving trims the text and turns empty or blank input into null', () => {
  assert.equal(normalizePolicyForSave('  Returns accepted within 7 days.  '), 'Returns accepted within 7 days.');
  assert.equal(normalizePolicyForSave(''), null);
  assert.equal(normalizePolicyForSave('   \n\t \n  '), null);
  assert.equal(normalizePolicyForSave(null), null);
  assert.equal(normalizePolicyForSave(undefined), null);
  assert.equal(normalizePolicyForSave(42), null);
});

test('saving keeps single line breaks and one blank line, and collapses longer runs', () => {
  assert.equal(normalizePolicyForSave('Line one\nLine two'), 'Line one\nLine two');
  assert.equal(normalizePolicyForSave('Para one\n\nPara two'), 'Para one\n\nPara two');
  assert.equal(normalizePolicyForSave('Para one\n\n\n\n\nPara two'), 'Para one\n\nPara two');
  assert.equal(normalizePolicyForSave('A\n \n \n \nB'), 'A\n\nB');
});

test('saving unifies line endings and drops trailing spaces and control characters', () => {
  assert.equal(normalizePolicyForSave('A  \r\nB\rC'), 'A\nB\nC');
  assert.equal(normalizePolicyForSave('Pay\u0000ment\u0007 terms\tapply'), 'Payment terms\tapply');
});

test('saving cuts the text to the maximum length without leaving a broken character', () => {
  const long = 'x'.repeat(POLICY_MAX_LENGTH + 500);
  assert.equal(normalizePolicyForSave(long).length, POLICY_MAX_LENGTH);
  assert.equal(normalizePolicyForSave('y'.repeat(POLICY_MAX_LENGTH)).length, POLICY_MAX_LENGTH);

  // An emoji (two UTF-16 units) straddling the limit is dropped whole.
  const straddling = 'x'.repeat(POLICY_MAX_LENGTH - 1) + '\u{1F600}';
  const cut = normalizePolicyForSave(straddling);
  assert.equal(cut, 'x'.repeat(POLICY_MAX_LENGTH - 1));
  assert.doesNotMatch(cut, /[\uD800-\uDFFF]/);

  // Trailing whitespace exposed by the cut is trimmed.
  assert.equal(normalizePolicyForSave('x'.repeat(POLICY_MAX_LENGTH - 2) + '   tail'), 'x'.repeat(POLICY_MAX_LENGTH - 2));
});

test('saved text is never HTML-processed: markup stays plain text', () => {
  const text = '<b>Bold</b> & <script>alert(1)</script>';
  assert.equal(normalizePolicyForSave(text), text);
});

test('a product with its own policies shows them', () => {
  const policies = getProductPolicies({
    return_policy: '  Returnable within 7 days.\n\nShipping paid by buyer.  ',
    replacement_policy: 'Replacement within 10 days for manufacturing defects.',
  });
  assert.deepEqual(policies, {
    returnPolicy: 'Returnable within 7 days.\n\nShipping paid by buyer.',
    replacementPolicy: 'Replacement within 10 days for manufacturing defects.',
    hasProductSpecificReturn: true,
    hasProductSpecificReplacement: true,
  });
});

test('a product without policies shows the store-wide return wording and a neutral replacement note', () => {
  const policies = getProductPolicies({ return_policy: null, replacement_policy: null });
  assert.equal(policies.returnPolicy, DEFAULT_RETURN_POLICY);
  assert.equal(policies.replacementPolicy, DEFAULT_REPLACEMENT_NOTE);
  assert.equal(policies.hasProductSpecificReturn, false);
  assert.equal(policies.hasProductSpecificReplacement, false);
});

test('each policy falls back independently', () => {
  const onlyReturn = getProductPolicies({ return_policy: 'Custom return terms.' });
  assert.equal(onlyReturn.returnPolicy, 'Custom return terms.');
  assert.equal(onlyReturn.replacementPolicy, DEFAULT_REPLACEMENT_NOTE);
  assert.equal(onlyReturn.hasProductSpecificReturn, true);
  assert.equal(onlyReturn.hasProductSpecificReplacement, false);

  const onlyReplacement = getProductPolicies({ replacement_policy: 'Custom replacement terms.' });
  assert.equal(onlyReplacement.returnPolicy, DEFAULT_RETURN_POLICY);
  assert.equal(onlyReplacement.replacementPolicy, 'Custom replacement terms.');
  assert.equal(onlyReplacement.hasProductSpecificReturn, false);
  assert.equal(onlyReplacement.hasProductSpecificReplacement, true);
});

test('a product from a database without the columns, or with bad values, does not crash', () => {
  for (const product of [{}, { id: 'p1', name: 'Hinge' }, null, undefined, { return_policy: '', replacement_policy: '   ' }]) {
    const policies = getProductPolicies(product);
    assert.equal(policies.returnPolicy, DEFAULT_RETURN_POLICY);
    assert.equal(policies.replacementPolicy, DEFAULT_REPLACEMENT_NOTE);
    assert.equal(policies.hasProductSpecificReturn, false);
    assert.equal(policies.hasProductSpecificReplacement, false);
  }
  const odd = getProductPolicies({ return_policy: 7, replacement_policy: { text: 'x' } });
  assert.equal(odd.hasProductSpecificReturn, false);
  assert.equal(odd.hasProductSpecificReplacement, false);
});

test('displayed text is never empty', () => {
  assert.ok(DEFAULT_RETURN_POLICY.trim().length > 0);
  assert.ok(DEFAULT_REPLACEMENT_NOTE.trim().length > 0);
  assert.ok(getProductPolicies({}).returnPolicy.length > 0);
});

test('default return wording matches the store Returns page facts', () => {
  assert.match(DEFAULT_RETURN_POLICY, /within 2 days of delivery/);
  assert.match(DEFAULT_RETURN_POLICY, /Doorskins, wall panels, laminates, and digital locks are excluded/);
  assert.match(DEFAULT_REPLACEMENT_NOTE, /kattainterior@gmail\.com/);
});

test('the save payload sends only the policies that have text or must be cleared', () => {
  // Brand-new product, nothing typed: no policy columns are sent at all.
  assert.deepEqual(buildPolicyPayload({ returnPolicy: '', replacementPolicy: '  ' }), {});
  // Existing product from a database without the columns: still nothing to send.
  assert.deepEqual(buildPolicyPayload({ returnPolicy: '', replacementPolicy: '' }, { id: 'p1' }), {});
  // Existing product whose policies were never set (columns exist, values null).
  assert.deepEqual(
    buildPolicyPayload({ returnPolicy: '', replacementPolicy: '' }, { return_policy: null, replacement_policy: null }),
    {},
  );
});

test('the save payload carries cleaned text and clears removed policies', () => {
  assert.deepEqual(
    buildPolicyPayload({ returnPolicy: '  7 day return \n\n\n\nBuyer pays shipping ', replacementPolicy: '' }),
    { return_policy: '7 day return\n\nBuyer pays shipping' },
  );
  // The admin emptied a policy that was saved before: it is sent as null so it is removed.
  assert.deepEqual(
    buildPolicyPayload(
      { returnPolicy: '', replacementPolicy: 'New replacement terms' },
      { return_policy: 'Old return terms', replacement_policy: null },
    ),
    { return_policy: null, replacement_policy: 'New replacement terms' },
  );
});
