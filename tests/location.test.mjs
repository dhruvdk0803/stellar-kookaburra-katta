import assert from 'node:assert/strict';
import test from 'node:test';
import {
  buildGoogleMapsUrl,
  formatCoordinates,
  getCurrentPosition,
  isValidCoordinate,
  mapGeolocationErrorCode,
  reverseGeocode,
  roundCoordinate,
  toCoordinate,
} from '../src/lib/location.ts';

// ---------- helpers -------------------------------------------------------

function stubGlobal(name, value) {
  const original = Object.getOwnPropertyDescriptor(globalThis, name);
  Object.defineProperty(globalThis, name, { value, configurable: true, writable: true, enumerable: true });
  return () => {
    if (original) Object.defineProperty(globalThis, name, original);
    else delete globalThis[name];
  };
}

function stubGeolocation(impl) {
  return stubGlobal('navigator', { geolocation: impl === undefined ? undefined : { getCurrentPosition: impl } });
}

function jsonResponse(body, init = {}) {
  return {
    ok: init.ok ?? true,
    status: init.status ?? 200,
    json: async () => (typeof body === 'function' ? body() : body),
  };
}

// ---------- coordinate validation ----------------------------------------

test('isValidCoordinate accepts real coordinates, including the boundaries and 0/0', () => {
  assert.equal(isValidCoordinate(26.9124, 75.7873), true);
  assert.equal(isValidCoordinate(-33.8688, 151.2093), true);
  assert.equal(isValidCoordinate(90, 180), true);
  assert.equal(isValidCoordinate(-90, -180), true);
  assert.equal(isValidCoordinate(0, 0), true);
});

test('isValidCoordinate rejects out-of-range, non-finite and non-number input', () => {
  assert.equal(isValidCoordinate(90.000001, 0), false);
  assert.equal(isValidCoordinate(-90.5, 0), false);
  assert.equal(isValidCoordinate(0, 180.1), false);
  assert.equal(isValidCoordinate(0, -181), false);
  assert.equal(isValidCoordinate(NaN, 75), false);
  assert.equal(isValidCoordinate(26, NaN), false);
  assert.equal(isValidCoordinate(Infinity, 0), false);
  assert.equal(isValidCoordinate(0, -Infinity), false);
  assert.equal(isValidCoordinate('26.9', '75.7'), false);
  assert.equal(isValidCoordinate('26.9', 75.7), false);
  assert.equal(isValidCoordinate(null, null), false);
  assert.equal(isValidCoordinate(undefined, 75), false);
  assert.equal(isValidCoordinate(true, false), false);
  assert.equal(isValidCoordinate({}, []), false);
});

test('toCoordinate coerces numeric strings and rejects everything else', () => {
  assert.equal(toCoordinate(26.9124), 26.9124);
  assert.equal(toCoordinate('26.9124'), 26.9124);
  assert.equal(toCoordinate(' -75.5 '), -75.5);
  assert.equal(toCoordinate('0'), 0);
  assert.equal(toCoordinate(''), null);
  assert.equal(toCoordinate('   '), null);
  assert.equal(toCoordinate('abc'), null);
  assert.equal(toCoordinate(NaN), null);
  assert.equal(toCoordinate(Infinity), null);
  assert.equal(toCoordinate(null), null);
  assert.equal(toCoordinate(undefined), null);
  assert.equal(toCoordinate(true), null);
  assert.equal(toCoordinate({}), null);
});

test('roundCoordinate rounds to 6 decimal places and normalises negative zero', () => {
  assert.equal(roundCoordinate(26.91240049), 26.9124);
  assert.equal(roundCoordinate(75.78730051), 75.787301);
  assert.equal(roundCoordinate(-26.1234567), -26.123457);
  assert.equal(roundCoordinate(12), 12);
  assert.ok(Object.is(roundCoordinate(-0.0000001), 0), 'must not return -0');
  assert.ok(Number.isNaN(roundCoordinate(NaN)));
});

// ---------- URL + formatting ---------------------------------------------

test('buildGoogleMapsUrl builds a maps query URL', () => {
  assert.equal(buildGoogleMapsUrl(26.9124, 75.7873), 'https://www.google.com/maps?q=26.9124,75.7873');
});

test('buildGoogleMapsUrl keeps negative signs and caps precision at 6 dp', () => {
  assert.equal(buildGoogleMapsUrl(-33.868812345, -151.209299999), 'https://www.google.com/maps?q=-33.868812,-151.2093');
  assert.equal(buildGoogleMapsUrl(26.91240000001, 75.787300009), 'https://www.google.com/maps?q=26.9124,75.7873');
  assert.equal(buildGoogleMapsUrl(0, 0), 'https://www.google.com/maps?q=0,0');
  assert.equal(buildGoogleMapsUrl(-0.0000001, 0.000001), 'https://www.google.com/maps?q=0,0.000001');
});

test('buildGoogleMapsUrl returns null for invalid coordinates', () => {
  assert.equal(buildGoogleMapsUrl(NaN, 75), null);
  assert.equal(buildGoogleMapsUrl(91, 75), null);
  assert.equal(buildGoogleMapsUrl(26, 181), null);
  assert.equal(buildGoogleMapsUrl('26.9', '75.7'), null);
  assert.equal(buildGoogleMapsUrl(undefined, undefined), null);
  assert.equal(buildGoogleMapsUrl(null, 75), null);
});

test('formatCoordinates prints 6 dp and is empty for invalid input', () => {
  assert.equal(formatCoordinates(26.9124, 75.7873), '26.912400, 75.787300');
  assert.equal(formatCoordinates(-33.5, -151.25), '-33.500000, -151.250000');
  assert.equal(formatCoordinates(-0.0000001, 0), '0.000000, 0.000000');
  assert.equal(formatCoordinates(NaN, 1), '');
  assert.equal(formatCoordinates(100, 1), '');
});

// ---------- getCurrentPosition -------------------------------------------

test('getCurrentPosition resolves coordinates and accuracy, with high-accuracy defaults', async () => {
  let seenOptions;
  const restore = stubGeolocation((success, _error, options) => {
    seenOptions = options;
    success({ coords: { latitude: 26.9124, longitude: 75.7873, accuracy: 18.4 } });
  });
  try {
    const result = await getCurrentPosition();
    assert.deepEqual(result, { ok: true, latitude: 26.9124, longitude: 75.7873, accuracy: 18.4 });
    assert.deepEqual(seenOptions, { enableHighAccuracy: true, timeout: 12000, maximumAge: 0 });
  } finally {
    restore();
  }
});

test('getCurrentPosition lets callers override options', async () => {
  let seenOptions;
  const restore = stubGeolocation((success, _error, options) => {
    seenOptions = options;
    success({ coords: { latitude: 1, longitude: 2 } });
  });
  try {
    const result = await getCurrentPosition({ timeout: 5000, enableHighAccuracy: false });
    assert.deepEqual(result, { ok: true, latitude: 1, longitude: 2 });
    assert.deepEqual(seenOptions, { enableHighAccuracy: false, timeout: 5000, maximumAge: 0 });
  } finally {
    restore();
  }
});

test('getCurrentPosition maps error codes to reasons', async () => {
  const cases = [
    [1, 'denied'],
    [2, 'unavailable'],
    [3, 'timeout'],
    [99, 'unavailable'],
    [undefined, 'unavailable'],
  ];
  for (const [code, reason] of cases) {
    const restore = stubGeolocation((_success, error) => error({ code, message: 'x' }));
    try {
      assert.deepEqual(await getCurrentPosition(), { ok: false, reason }, `code ${code}`);
    } finally {
      restore();
    }
  }
  assert.equal(mapGeolocationErrorCode(1), 'denied');
  assert.equal(mapGeolocationErrorCode(3), 'timeout');
  assert.equal(mapGeolocationErrorCode('1'), 'unavailable');
});

test('getCurrentPosition reports unsupported when geolocation is missing', async () => {
  let restore = stubGeolocation(undefined);
  try {
    assert.deepEqual(await getCurrentPosition(), { ok: false, reason: 'unsupported' });
  } finally {
    restore();
  }
  restore = stubGlobal('navigator', undefined);
  try {
    assert.deepEqual(await getCurrentPosition(), { ok: false, reason: 'unsupported' });
  } finally {
    restore();
  }
});

test('getCurrentPosition never throws: sync throw and garbage coordinates become unavailable', async () => {
  let restore = stubGeolocation(() => {
    throw new Error('SecurityError');
  });
  try {
    assert.deepEqual(await getCurrentPosition(), { ok: false, reason: 'unavailable' });
  } finally {
    restore();
  }
  restore = stubGeolocation((success) => success({ coords: { latitude: NaN, longitude: 5 } }));
  try {
    assert.deepEqual(await getCurrentPosition(), { ok: false, reason: 'unavailable' });
  } finally {
    restore();
  }
});

test('getCurrentPosition settles only once even if the browser calls back repeatedly', async () => {
  let calls = 0;
  const restore = stubGeolocation((success, error) => {
    success({ coords: { latitude: 5, longitude: 6 } });
    error({ code: 1 });
    success({ coords: { latitude: 7, longitude: 8 } });
    calls += 1;
  });
  try {
    assert.deepEqual(await getCurrentPosition(), { ok: true, latitude: 5, longitude: 6 });
    assert.equal(calls, 1);
  } finally {
    restore();
  }
});

test('getCurrentPosition hard-timeout fallback resolves as timeout when no callback ever fires', async () => {
  // e.g. Firefox when the user dismisses the permission prompt without choosing
  const restore = stubGeolocation(() => {});
  try {
    const started = Date.now();
    const result = await getCurrentPosition({ timeout: 50 }); // fallback fires at timeout + 3000 ms
    assert.deepEqual(result, { ok: false, reason: 'timeout' });
    assert.ok(Date.now() - started >= 2900, 'waits for the hard fallback window');
  } finally {
    restore();
  }
});

// ---------- reverseGeocode ------------------------------------------------

test('reverseGeocode returns display_name and calls Nominatim with the documented parameters', async () => {
  let seenUrl;
  let seenInit;
  const restore = stubGlobal('fetch', async (url, init) => {
    seenUrl = url;
    seenInit = init;
    return jsonResponse({ display_name: '  C-Scheme, Jaipur, Rajasthan, India  ' });
  });
  try {
    const name = await reverseGeocode(26.91240049, 75.7873);
    assert.equal(name, 'C-Scheme, Jaipur, Rajasthan, India');
    const url = new URL(seenUrl);
    assert.equal(url.origin + url.pathname, 'https://nominatim.openstreetmap.org/reverse');
    assert.equal(url.searchParams.get('format'), 'jsonv2');
    assert.equal(url.searchParams.get('lat'), '26.9124');
    assert.equal(url.searchParams.get('lon'), '75.7873');
    assert.equal(url.searchParams.get('zoom'), '18');
    assert.equal(url.searchParams.get('accept-language'), 'en');
    assert.ok(seenInit.signal instanceof AbortSignal);
  } finally {
    restore();
  }
});

test('reverseGeocode returns null for invalid coordinates without calling fetch', async () => {
  let called = false;
  const restore = stubGlobal('fetch', async () => {
    called = true;
    return jsonResponse({ display_name: 'x' });
  });
  try {
    assert.equal(await reverseGeocode(NaN, 75), null);
    assert.equal(await reverseGeocode(95, 75), null);
    assert.equal(await reverseGeocode('26', '75'), null);
    assert.equal(called, false);
  } finally {
    restore();
  }
});

test('reverseGeocode returns null for non-200, error bodies, empty and malformed responses', async () => {
  const scenarios = {
    'HTTP 500': async () => jsonResponse({ display_name: 'x' }, { ok: false, status: 500 }),
    'HTTP 429': async () => jsonResponse({}, { ok: false, status: 429 }),
    'error body': async () => jsonResponse({ error: 'Unable to geocode' }),
    'blank name': async () => jsonResponse({ display_name: '   ' }),
    'non-string name': async () => jsonResponse({ display_name: 42 }),
    'null body': async () => jsonResponse(null),
    'array body': async () => jsonResponse([]),
    'malformed JSON': async () => jsonResponse(() => {
      throw new SyntaxError('Unexpected token < in JSON');
    }),
    'network failure': async () => {
      throw new TypeError('Failed to fetch');
    },
    'undefined response': async () => undefined,
  };
  for (const [name, impl] of Object.entries(scenarios)) {
    const restore = stubGlobal('fetch', impl);
    try {
      assert.equal(await reverseGeocode(26.9, 75.7), null, name);
    } finally {
      restore();
    }
  }
});

test('reverseGeocode returns null when no fetch exists', async () => {
  const restore = stubGlobal('fetch', undefined);
  try {
    assert.equal(await reverseGeocode(26.9, 75.7), null);
  } finally {
    restore();
  }
});

test('reverseGeocode times out (and aborts the request) when the server never answers', async () => {
  let aborted = false;
  const restore = stubGlobal('fetch', (_url, init) => new Promise((_resolve, reject) => {
    init.signal.addEventListener('abort', () => {
      aborted = true;
      reject(Object.assign(new Error('The operation was aborted'), { name: 'AbortError' }));
    });
  }));
  try {
    const started = Date.now();
    assert.equal(await reverseGeocode(26.9, 75.7, undefined, 40), null);
    assert.ok(Date.now() - started < 1500);
    assert.equal(aborted, true);
  } finally {
    restore();
  }
});

test('reverseGeocode cannot hang even if fetch ignores the abort signal', async () => {
  const restore = stubGlobal('fetch', () => new Promise(() => {}));
  try {
    assert.equal(await reverseGeocode(26.9, 75.7, undefined, 40), null);
  } finally {
    restore();
  }
});

test('reverseGeocode honours a caller AbortSignal (mid-flight and already aborted)', async () => {
  let fetchCalls = 0;
  const restore = stubGlobal('fetch', (_url, init) => {
    fetchCalls += 1;
    return new Promise((_resolve, reject) => {
      init.signal.addEventListener('abort', () => reject(new Error('aborted')));
    });
  });
  try {
    const controller = new AbortController();
    const pending = reverseGeocode(26.9, 75.7, controller.signal);
    setTimeout(() => controller.abort(), 10);
    assert.equal(await pending, null);
    assert.equal(fetchCalls, 1);

    const already = new AbortController();
    already.abort();
    assert.equal(await reverseGeocode(26.9, 75.7, already.signal), null);
    assert.equal(fetchCalls, 1, 'no request is made for a pre-aborted signal');
  } finally {
    restore();
  }
});
