/**
 * Delivery-location helpers shared by the checkout LocationPicker and the
 * admin "Open in Maps" link.
 *
 * Everything here is free of React / Leaflet so it can be unit-tested in Node
 * (tests/location.test.mjs) and so importing it never pulls map code into a
 * bundle. Nothing in this file throws for bad input: validators return
 * booleans/nulls and the async helpers resolve to a tagged result.
 */

export interface DeliveryLocation {
  latitude: number;
  longitude: number;
  label?: string | null;
}

/** Default map centre (Jaipur) used when the customer has no saved location yet. */
export const DEFAULT_MAP_CENTER: readonly [number, number] = [26.9124, 75.7873];

const NOMINATIM_REVERSE_URL = 'https://nominatim.openstreetmap.org/reverse';
export const REVERSE_GEOCODE_TIMEOUT_MS = 6000;
export const GEOLOCATION_TIMEOUT_MS = 12000;

/** True only for finite *numbers* inside the valid lat/lng ranges. Strings, NaN, null etc. are rejected. 0/0 is allowed. */
export function isValidCoordinate(lat: unknown, lng: unknown): boolean {
  return (
    typeof lat === 'number' &&
    typeof lng === 'number' &&
    Number.isFinite(lat) &&
    Number.isFinite(lng) &&
    lat >= -90 &&
    lat <= 90 &&
    lng >= -180 &&
    lng <= 180
  );
}

/**
 * Coerce a DB / form value to a number. Accepts numbers and numeric strings
 * (Postgres `double precision` can arrive as either); returns null for
 * anything else (null, undefined, '', 'abc', booleans, objects, NaN).
 */
export function toCoordinate(value: unknown): number | null {
  if (typeof value === 'number') return Number.isFinite(value) ? value : null;
  if (typeof value === 'string') {
    const trimmed = value.trim();
    if (trimmed === '') return null;
    const parsed = Number(trimmed);
    return Number.isFinite(parsed) ? parsed : null;
  }
  return null;
}

/** Round to 6 decimal places (~0.1 m). Normalises -0 to 0. Non-finite input is returned unchanged. */
export function roundCoordinate(n: number): number {
  if (!Number.isFinite(n)) return n;
  return Math.round(n * 1e6) / 1e6 + 0;
}

/** `https://www.google.com/maps?q=<lat>,<lng>` (6 dp), or null when the coordinates are invalid. */
export function buildGoogleMapsUrl(lat: number, lng: number): string | null {
  if (!isValidCoordinate(lat, lng)) return null;
  return `https://www.google.com/maps?q=${roundCoordinate(lat)},${roundCoordinate(lng)}`;
}

/** Human-readable "26.912400, 75.787300" (always 6 dp). Empty string when invalid. */
export function formatCoordinates(lat: number, lng: number): string {
  if (!isValidCoordinate(lat, lng)) return '';
  return `${roundCoordinate(lat).toFixed(6)}, ${roundCoordinate(lng).toFixed(6)}`;
}

/**
 * Look up a human-readable address for a coordinate using OpenStreetMap
 * Nominatim. Resolves to `display_name`, or null on ANY failure (invalid
 * input, offline, non-2xx, bad JSON, no result, abort, timeout). Never throws.
 *
 * Nominatim's usage policy allows ~1 request/second and forbids per-keystroke
 * style lookups, so callers must only invoke this for a *final* position
 * (map click / drag end / "use my location"), never on every drag tick.
 */
export async function reverseGeocode(
  lat: number,
  lng: number,
  signal?: AbortSignal,
  timeoutMs: number = REVERSE_GEOCODE_TIMEOUT_MS,
): Promise<string | null> {
  if (!isValidCoordinate(lat, lng)) return null;
  if (typeof fetch !== 'function') return null;
  if (signal?.aborted) return null;

  const controller = new AbortController();
  let timer: ReturnType<typeof setTimeout> | undefined;
  let cancelNow: () => void = () => undefined;
  const cancelled = new Promise<null>((resolve) => {
    cancelNow = () => {
      controller.abort();
      resolve(null);
    };
  });

  try {
    timer = setTimeout(cancelNow, timeoutMs);
    signal?.addEventListener('abort', cancelNow, { once: true });

    const url =
      `${NOMINATIM_REVERSE_URL}?format=jsonv2` +
      `&lat=${encodeURIComponent(String(roundCoordinate(lat)))}` +
      `&lon=${encodeURIComponent(String(roundCoordinate(lng)))}` +
      `&zoom=18&accept-language=en`;

    const request = (async (): Promise<string | null> => {
      const response = await fetch(url, {
        signal: controller.signal,
        headers: { Accept: 'application/json' },
      });
      if (!response || !response.ok) return null;
      const data: unknown = await response.json();
      if (!data || typeof data !== 'object') return null;
      const name = (data as { display_name?: unknown }).display_name;
      if (typeof name !== 'string') return null;
      const trimmed = name.trim();
      return trimmed === '' ? null : trimmed;
    })();

    // Racing against `cancelled` means a stubbed / misbehaving fetch that ignores
    // the abort signal still can't hang the caller past the timeout.
    return await Promise.race([request, cancelled]);
  } catch {
    return null;
  } finally {
    if (timer !== undefined) clearTimeout(timer);
    signal?.removeEventListener('abort', cancelNow);
  }
}

export type GeolocationFailureReason = 'denied' | 'unavailable' | 'timeout' | 'unsupported';

export type CurrentPositionResult =
  | { ok: true; latitude: number; longitude: number; accuracy?: number }
  | { ok: false; reason: GeolocationFailureReason };

/** Map a GeolocationPositionError.code (1/2/3) to our reason union. Unknown codes become 'unavailable'. */
export function mapGeolocationErrorCode(code: unknown): GeolocationFailureReason {
  if (code === 1) return 'denied';
  if (code === 3) return 'timeout';
  return 'unavailable';
}

/**
 * Promise wrapper around navigator.geolocation.getCurrentPosition.
 * Defaults: enableHighAccuracy true, timeout 12 s, maximumAge 0. Never rejects.
 *
 * A hard fallback timer (timeout + 3 s) guards against browsers that never fire
 * either callback when the user dismisses the permission prompt.
 */
export function getCurrentPosition(options?: PositionOptions): Promise<CurrentPositionResult> {
  return new Promise<CurrentPositionResult>((resolve) => {
    const geo: Geolocation | undefined =
      typeof navigator !== 'undefined' ? navigator.geolocation : undefined;
    if (!geo || typeof geo.getCurrentPosition !== 'function') {
      resolve({ ok: false, reason: 'unsupported' });
      return;
    }

    const merged: PositionOptions = {
      enableHighAccuracy: true,
      timeout: GEOLOCATION_TIMEOUT_MS,
      maximumAge: 0,
      ...options,
    };

    let settled = false;
    const finish = (result: CurrentPositionResult) => {
      if (settled) return;
      settled = true;
      clearTimeout(fallbackTimer);
      resolve(result);
    };

    // Declared before geo.getCurrentPosition runs, so `finish` can never see it uninitialised.
    const timeoutMs = typeof merged.timeout === 'number' && merged.timeout > 0 ? merged.timeout : GEOLOCATION_TIMEOUT_MS;
    const fallbackTimer = setTimeout(() => finish({ ok: false, reason: 'timeout' }), timeoutMs + 3000);

    try {
      geo.getCurrentPosition(
        (position) => {
          const latitude = position?.coords?.latitude;
          const longitude = position?.coords?.longitude;
          if (!isValidCoordinate(latitude, longitude)) {
            finish({ ok: false, reason: 'unavailable' });
            return;
          }
          const accuracy = position.coords.accuracy;
          finish({
            ok: true,
            latitude,
            longitude,
            ...(typeof accuracy === 'number' && Number.isFinite(accuracy) ? { accuracy } : {}),
          });
        },
        (error) => finish({ ok: false, reason: mapGeolocationErrorCode(error?.code) }),
        merged,
      );
    } catch {
      finish({ ok: false, reason: 'unavailable' });
    }
  });
}
