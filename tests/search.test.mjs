import assert from 'node:assert/strict';
import test from 'node:test';
import { expandSearchQuery, matchesSearch, searchOrFilters, SEARCH_SYNONYMS } from '../src/lib/search.ts';

test('Hindi words find their English products', () => {
  assert.ok(matchesSearch('Dorset Thick Door Soft Close Hinge', 'kabja'));
  assert.ok(matchesSearch('Dorset Thick Door Soft Close Hinge', 'Kabza'));
  assert.ok(matchesSearch('Ebco Tower Bolt 6 inch', 'chitkani'));
  assert.ok(matchesSearch('Apollo CPVC Elbow 90° 1 inch', 'koni'));
  assert.ok(matchesSearch('Jivanjor Allrounder Adhesive 1kg', 'fevicol'));
});

test('every word must match, in any order and position', () => {
  assert.ok(matchesSearch('Dorset Thick Door Soft Close Hinge', 'soft kabja'));
  assert.ok(matchesSearch('Dorset Thick Door Soft Close Hinge', 'hinge   dorset'));
  assert.ok(!matchesSearch('Dorset Thick Door Soft Close Hinge', 'kabja ebco'));
  assert.ok(!matchesSearch('Apollo CPVC Pipe', 'kabja'));
});

test('empty or punctuation-only queries match everything; plain substring search still works', () => {
  assert.ok(matchesSearch('anything', ''));
  assert.ok(matchesSearch('anything', ' ,() '));
  assert.ok(matchesSearch('Ebco 165° Hinge Regular Close', '165'));
  assert.ok(matchesSearch('Apollo CPVC Pipe 1.5 inch', '1.5'));
});

test('PostgREST filters: one per word, special characters stripped', () => {
  assert.deepEqual(searchOrFilters('Kabja 165'), ['name.ilike.%kabja%,name.ilike.%hinge%', 'name.ilike.%165%']);
  assert.deepEqual(searchOrFilters('a,b(c)%*'), ['name.ilike.%a%', 'name.ilike.%b%', 'name.ilike.%c%']);
  assert.deepEqual(searchOrFilters('  '), []);
  assert.deepEqual(expandSearchQuery('tonti')[0].slice(0, 2), ['tonti', 'tap']);
});

test('dictionary keys are lower-case single words with lower-case values', () => {
  for (const [key, values] of Object.entries(SEARCH_SYNONYMS)) {
    assert.match(key, /^[a-z]+$/, key);
    for (const v of values) assert.equal(v, v.toLowerCase(), `${key} -> ${v}`);
  }
});
