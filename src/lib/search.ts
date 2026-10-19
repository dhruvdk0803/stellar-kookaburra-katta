/**
 * Product search that understands the Hindi / local words customers type
 * (e.g. "kabja" -> hinge), used by the header search and the Shop page.
 *
 * Rule: the query is split into words; EVERY word must match the product
 * (name, brand or category), where a word matches if the text contains the
 * word itself or any of its English equivalents below. So "soft close kabja"
 * finds "Soft Close Hinge" even though the words are not adjacent.
 *
 * To teach search a new word, add it to SEARCH_SYNONYMS (lower case, roman
 * script). Values are English words that appear in product/category names.
 *
 * This file has no imports so Node tests can load it directly.
 */

export const SEARCH_SYNONYMS: Readonly<Record<string, readonly string[]>> = {
  // Furniture fittings
  kabja: ['hinge'], kabza: ['hinge'], kabjaa: ['hinge'], kabje: ['hinge'], kabze: ['hinge'],
  chitkani: ['tower bolt', 'bolt'], chitkini: ['tower bolt', 'bolt'], chatkani: ['tower bolt', 'bolt'],
  sitkani: ['tower bolt', 'bolt'], chatkhani: ['tower bolt', 'bolt'],
  kunda: ['hasp', 'latch'], kundi: ['hasp', 'latch'],
  hatha: ['handle'], hattha: ['handle'], hatta: ['handle'], mutha: ['handle', 'knob'], muththa: ['handle', 'knob'],
  tala: ['lock'], taala: ['lock'], taale: ['lock'],
  chabi: ['key', 'lock'], chaabi: ['key', 'lock'],
  channel: ['channel', 'drawer slide', 'slide'], chainal: ['channel', 'drawer slide', 'slide'],
  draj: ['drawer'], daraj: ['drawer'],
  tokri: ['basket'], tokari: ['basket'],
  chumbak: ['magnet'],
  pahiya: ['wheel', 'caster'], pahiye: ['wheel', 'caster'],
  pench: ['screw'], painch: ['screw'],
  keel: ['nail'], kil: ['nail'], kile: ['nail'],
  darwaza: ['door'], darwaja: ['door'], darvaza: ['door'], darvaja: ['door'],
  khidki: ['window'], khirki: ['window'],
  shatar: ['shutter'], shutar: ['shutter'],
  jaali: ['louver', 'louvre', 'mesh'], jali: ['louver', 'louvre', 'mesh'],
  // Plumbing
  tonti: ['tap', 'faucet', 'cock'], tooti: ['tap', 'faucet', 'cock'], toti: ['tap', 'faucet', 'cock'],
  nal: ['tap', 'faucet', 'pipe'], nall: ['tap', 'faucet', 'pipe'],
  paip: ['pipe'], paipe: ['pipe'],
  koni: ['elbow'], kohni: ['elbow'], elbo: ['elbow'],
  tanki: ['tank'], taanki: ['tank'],
  solution: ['solvent', 'cement'], solushan: ['solvent', 'cement'],
  // Boards, sheets and adhesives
  ply: ['plywood', 'ply'], plai: ['plywood', 'ply'],
  chadar: ['sheet'], chaddar: ['sheet'],
  sunmica: ['laminate', 'sunmica'], mica: ['laminate', 'mica'],
  fevicol: ['adhesive'], gond: ['adhesive', 'glue'], glue: ['adhesive', 'glue'],
};

/** Lower-case, trim, and collapse anything that is not a letter or digit into single spaces. */
export const normalizeSearchText = (value: unknown): string =>
  String(value ?? '')
    .toLowerCase()
    .replace(/[^\p{L}\p{N}.]+/gu, ' ')
    .trim();

/**
 * One entry per query word: the alternatives any of which may match.
 * "Kabja 165" -> [["kabja", "hinge"], ["165"]]. Empty query -> [].
 */
export const expandSearchQuery = (query: string): string[][] =>
  normalizeSearchText(query)
    .split(' ')
    .filter(Boolean)
    .map((word) => [word, ...(SEARCH_SYNONYMS[word] ?? [])]);

/** True when every query word (or one of its synonyms) appears in `haystack`. */
export const matchesSearch = (haystack: string, query: string): boolean => {
  const groups = expandSearchQuery(query);
  if (groups.length === 0) return true;
  const text = normalizeSearchText(haystack);
  return groups.every((alternatives) => alternatives.some((alt) => text.includes(alt)));
};

/**
 * PostgREST `or` filters for the header search (one per query word; supabase-js
 * ANDs repeated `.or()` calls). Words are already stripped of , ( ) % * by
 * normalizeSearchText, so they are safe inside the filter string.
 */
export const searchOrFilters = (query: string, column = 'name'): string[] =>
  expandSearchQuery(query).map((alternatives) =>
    alternatives.map((alt) => `${column}.ilike.%${alt}%`).join(','),
  );
