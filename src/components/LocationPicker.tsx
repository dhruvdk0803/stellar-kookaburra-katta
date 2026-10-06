import { useCallback, useEffect, useId, useRef, useState } from 'react';
// Type-only import: erased at compile time, so Leaflet is NOT part of any static bundle.
// The runtime module + CSS are loaded with dynamic import() the first time the map is opened.
import type * as LeafletNS from 'leaflet';
import { Loader2, LocateFixed, Map as MapIcon, MapPin, X } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils';
import {
  DEFAULT_MAP_CENTER,
  formatCoordinates,
  getCurrentPosition,
  isValidCoordinate,
  reverseGeocode,
  roundCoordinate,
  type DeliveryLocation,
  type GeolocationFailureReason,
} from '@/lib/location';

type LeafletModule = typeof LeafletNS;

interface LocationPickerProps {
  value: DeliveryLocation | null;
  onChange: (value: DeliveryLocation | null) => void;
  disabled?: boolean;
  className?: string;
}

type Status = { tone: 'info' | 'warn'; text: string } | null;

const DEFAULT_ZOOM = 12;
const PIN_ZOOM = 16;
/** Wait for the pin to settle before asking Nominatim (usage policy: ~1 request/second, final position only). */
const GEOCODE_DEBOUNCE_MS = 700;
const TILE_URL = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const TILE_ATTRIBUTION = '&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noopener noreferrer">OpenStreetMap</a> contributors';

const FALLBACK_HINT = 'You can still place the pin on the map or just continue with your address.';
const FAILURE_MESSAGES: Record<GeolocationFailureReason, string> = {
  denied: `Location permission was denied. ${FALLBACK_HINT}`,
  unavailable: `We couldn't detect your location right now. ${FALLBACK_HINT}`,
  timeout: `Finding your location took too long. Please try again. ${FALLBACK_HINT}`,
  unsupported: `Your browser doesn't support location detection. ${FALLBACK_HINT}`,
};

// Inline SVG pin (no image assets, so Leaflet's default-icon path detection never matters under Vite).
const PIN_SVG =
  '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="42" viewBox="0 0 36 46" aria-hidden="true" focusable="false" style="display:block;filter:drop-shadow(0 2px 2px rgba(0,0,0,.35))">' +
  '<path d="M18 1C8.6 1 1 8.6 1 18c0 12.8 17 26.5 17 26.5S35 30.8 35 18C35 8.6 27.4 1 18 1z" fill="#dc2626" stroke="#ffffff" stroke-width="2"/>' +
  '<circle cx="18" cy="18" r="6.5" fill="#ffffff"/>' +
  '</svg>';

const createPinIcon = (L: LeafletModule) =>
  L.divIcon({
    className: 'katta-location-pin',
    html: PIN_SVG,
    iconSize: [32, 42],
    iconAnchor: [16, 42],
  });

const LocationPicker = ({ value, onChange, disabled = false, className }: LocationPickerProps) => {
  const titleId = useId();

  const [mapOpen, setMapOpen] = useState(false);
  const [mapReady, setMapReady] = useState(false);
  const [locating, setLocating] = useState(false);
  const [geocoding, setGeocoding] = useState(false);
  const [status, setStatus] = useState<Status>(null);

  const containerRef = useRef<HTMLDivElement>(null);
  const leafletRef = useRef<LeafletModule | null>(null);
  const mapRef = useRef<LeafletNS.Map | null>(null);
  const markerRef = useRef<LeafletNS.Marker | null>(null);

  // Latest props for long-lived Leaflet / async callbacks (avoids stale closures).
  const onChangeRef = useRef(onChange);
  const valueRef = useRef(value);
  const disabledRef = useRef(disabled);
  useEffect(() => {
    onChangeRef.current = onChange;
    valueRef.current = value;
    disabledRef.current = disabled;
  }, [onChange, value, disabled]);

  const mountedRef = useRef(false);
  const focusRef = useRef(false);
  const geocodeSeq = useRef(0);
  const geocodeTimer = useRef<ReturnType<typeof setTimeout> | undefined>(undefined);
  const geocodeAbort = useRef<AbortController | null>(null);

  const latitude = value?.latitude;
  const longitude = value?.longitude;
  const hasPin = isValidCoordinate(latitude, longitude);
  const label = typeof value?.label === 'string' && value.label.trim() !== '' ? value.label.trim() : null;

  /** Invalidate any scheduled / in-flight reverse-geocode so a stale result can never overwrite a newer pin. */
  const cancelGeocode = useCallback(() => {
    geocodeSeq.current += 1;
    if (geocodeTimer.current !== undefined) {
      clearTimeout(geocodeTimer.current);
      geocodeTimer.current = undefined;
    }
    geocodeAbort.current?.abort();
    geocodeAbort.current = null;
    setGeocoding(false);
  }, []);

  /** Commit a final pin position, then (after a short settle delay) fetch a readable address for it. */
  const placePin = useCallback(
    (lat: number, lng: number, opts: { delay: number; message?: string }) => {
      const pinLat = roundCoordinate(lat);
      const pinLng = roundCoordinate(lng);
      if (!isValidCoordinate(pinLat, pinLng)) return;

      cancelGeocode();
      const seq = geocodeSeq.current;
      onChangeRef.current({ latitude: pinLat, longitude: pinLng, label: null });
      setStatus(opts.message ? { tone: 'info', text: opts.message } : null);
      setGeocoding(true);

      geocodeTimer.current = setTimeout(async () => {
        geocodeTimer.current = undefined;
        const controller = new AbortController();
        geocodeAbort.current = controller;
        const name = await reverseGeocode(pinLat, pinLng, controller.signal);
        if (!mountedRef.current || seq !== geocodeSeq.current) return;
        geocodeAbort.current = null;
        setGeocoding(false);
        if (name) {
          onChangeRef.current({ latitude: pinLat, longitude: pinLng, label: name });
        } else {
          setStatus({
            tone: 'info',
            text: "Your pin is saved. We couldn't look up an address name for it, but our team can still use the coordinates.",
          });
        }
      }, opts.delay);
    },
    [cancelGeocode],
  );

  // Mount / unmount bookkeeping (also correct under React 18 StrictMode's mount-unmount-mount).
  useEffect(() => {
    mountedRef.current = true;
    return () => {
      mountedRef.current = false;
      cancelGeocode();
    };
  }, [cancelGeocode]);

  // Create the Leaflet map only while it is open. Leaflet + its CSS are fetched lazily right here.
  useEffect(() => {
    if (!mapOpen) return;
    let cancelled = false;
    let map: LeafletNS.Map | null = null;
    let observer: ResizeObserver | undefined;

    (async () => {
      try {
        const [leafletModule] = await Promise.all([import('leaflet'), import('leaflet/dist/leaflet.css')]);
        if (cancelled || !containerRef.current) return;

        // Leaflet ships an ESM build with named exports; fall back to a default export if a bundler adds one.
        const candidate = leafletModule as unknown as { default?: LeafletModule } & LeafletModule;
        const L: LeafletModule = candidate.default && typeof candidate.default.map === 'function' ? candidate.default : candidate;
        leafletRef.current = L;

        const current = valueRef.current;
        const startsOnPin = !!current && isValidCoordinate(current.latitude, current.longitude);
        const center: [number, number] = startsOnPin
          ? [current!.latitude, current!.longitude]
          : [DEFAULT_MAP_CENTER[0], DEFAULT_MAP_CENTER[1]];

        map = L.map(containerRef.current, {
          center,
          zoom: startsOnPin ? PIN_ZOOM : DEFAULT_ZOOM,
          scrollWheelZoom: false, // never hijack page scrolling on the checkout form
        });
        L.tileLayer(TILE_URL, { maxZoom: 19, attribution: TILE_ATTRIBUTION }).addTo(map);

        map.on('click', (event: LeafletNS.LeafletMouseEvent) => {
          if (disabledRef.current) return;
          placePin(event.latlng.lat, event.latlng.lng, { delay: GEOCODE_DEBOUNCE_MS });
        });

        if (typeof ResizeObserver !== 'undefined') {
          const target = map;
          observer = new ResizeObserver(() => target.invalidateSize());
          observer.observe(containerRef.current);
        }

        mapRef.current = map;
        setMapReady(true);
      } catch {
        if (cancelled) return;
        setMapOpen(false);
        setStatus({
          tone: 'warn',
          text: "The map couldn't be loaded. You can still use your current location or just continue with your address.",
        });
      }
    })();

    return () => {
      cancelled = true;
      observer?.disconnect();
      markerRef.current = null; // removed together with the map
      mapRef.current = null;
      map?.remove();
      map = null;
      setMapReady(false);
    };
  }, [mapOpen, placePin]);

  // Keep the marker in step with `value` (create / move / remove / enable-disable dragging).
  useEffect(() => {
    const L = leafletRef.current;
    const map = mapRef.current;
    if (!mapReady || !L || !map) return;

    if (!hasPin) {
      markerRef.current?.remove();
      markerRef.current = null;
      return;
    }

    const latlng = L.latLng(latitude as number, longitude as number);
    let marker = markerRef.current;
    if (!marker) {
      marker = L.marker(latlng, {
        icon: createPinIcon(L),
        draggable: !disabled,
        keyboard: true,
        title: 'Delivery location - drag to adjust',
      }).addTo(map);
      marker.getElement()?.setAttribute('aria-label', 'Delivery location pin. Drag to adjust.');
      // Only the FINAL position triggers a lookup (never every drag tick).
      marker.on('dragend', () => {
        const point = marker!.getLatLng();
        placePin(point.lat, point.lng, { delay: GEOCODE_DEBOUNCE_MS });
      });
      markerRef.current = marker;
    } else if (!marker.getLatLng().equals(latlng, 1e-9)) {
      marker.setLatLng(latlng);
    }

    if (disabled) marker.dragging?.disable();
    else marker.dragging?.enable();

    if (focusRef.current) {
      focusRef.current = false;
      map.setView(latlng, Math.max(map.getZoom(), PIN_ZOOM));
    } else if (!map.getBounds().contains(latlng)) {
      map.panTo(latlng);
    }
  }, [mapReady, hasPin, latitude, longitude, disabled, placePin]);

  const handleUseCurrentLocation = async () => {
    if (disabled || locating) return;
    setLocating(true);
    setStatus({ tone: 'info', text: 'Getting your location...' });
    try {
      const result = await getCurrentPosition();
      if (!mountedRef.current) return;
      if (result.ok === false) {
        setStatus({ tone: 'warn', text: FAILURE_MESSAGES[result.reason] });
        return;
      }
      const accuracy =
        typeof result.accuracy === 'number' && result.accuracy > 0 ? ` (accurate to about ${Math.round(result.accuracy)} m)` : '';
      focusRef.current = true;
      setMapOpen(true);
      placePin(result.latitude, result.longitude, {
        delay: 0,
        message: `Pin placed at your current location${accuracy}. Drag it on the map to fine-tune.`,
      });
    } catch {
      if (mountedRef.current) setStatus({ tone: 'warn', text: FAILURE_MESSAGES.unavailable });
    } finally {
      if (mountedRef.current) setLocating(false);
    }
  };

  const handleToggleMap = () => {
    if (disabled) return;
    setStatus(null);
    setMapOpen((open) => !open);
  };

  const handleClear = () => {
    cancelGeocode();
    focusRef.current = false;
    setStatus(null);
    onChange(null);
  };

  const mapLoading = mapOpen && !mapReady;

  return (
    <section className={cn('space-y-3', className)} aria-labelledby={titleId}>
      <div>
        <h3 id={titleId} className="font-semibold text-gray-900">
          Exact Delivery Location
        </h3>
        <p className="text-sm text-muted-foreground">Optional - helps our delivery team find you</p>
      </div>

      <div className="flex flex-col gap-2 sm:flex-row">
        <Button
          type="button"
          variant="outline"
          onClick={handleUseCurrentLocation}
          disabled={disabled || locating}
          aria-busy={locating}
          className="w-full gap-2 rounded-full bg-white sm:w-auto"
        >
          {locating ? <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" /> : <LocateFixed className="h-4 w-4" aria-hidden="true" />}
          {locating ? 'Locating...' : 'Use My Current Location'}
        </Button>
        <Button
          type="button"
          variant="outline"
          onClick={handleToggleMap}
          disabled={disabled}
          aria-expanded={mapOpen}
          aria-busy={mapLoading}
          className="w-full gap-2 rounded-full bg-white sm:w-auto"
        >
          {mapLoading ? <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" /> : <MapIcon className="h-4 w-4" aria-hidden="true" />}
          {mapOpen ? (mapReady ? 'Hide Map' : 'Loading Map...') : 'Choose Location on Map'}
        </Button>
      </div>

      {/* Polite live region: always mounted so screen readers announce changes. */}
      <div aria-live="polite">
        {status && (
          <p
            className={cn(
              'text-sm',
              status.tone === 'warn'
                ? 'rounded-md border border-amber-200 bg-amber-50 px-3 py-2 text-amber-800'
                : 'text-muted-foreground',
            )}
          >
            {status.text}
          </p>
        )}
      </div>

      {mapOpen && (
        <div className="space-y-2">
          <div className="relative isolate z-0 h-[260px] w-full overflow-hidden rounded-lg border border-gray-200 bg-gray-100 md:h-[300px]">
            <div ref={containerRef} className="absolute inset-0" />
            {!mapReady && (
              <div className="absolute inset-0 z-10 flex items-center justify-center gap-2 bg-gray-100 text-sm text-muted-foreground">
                <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" />
                Loading map...
              </div>
            )}
          </div>
          <p className="text-xs text-muted-foreground">Tap or click the map to drop a pin, then drag it to fine-tune.</p>
        </div>
      )}

      {hasPin && (
        <div className="rounded-lg border border-gray-200 bg-white p-3 text-sm">
          <div className="flex items-start gap-2">
            <MapPin className="mt-0.5 h-4 w-4 shrink-0 text-primary" aria-hidden="true" />
            <div className="min-w-0 flex-1 space-y-0.5">
              <p className="font-medium text-gray-900">Delivery pin saved</p>
              <p className="break-all text-xs tabular-nums text-muted-foreground">
                {formatCoordinates(latitude as number, longitude as number)}
              </p>
              {label ? (
                <p className="break-words text-gray-700">{label}</p>
              ) : geocoding ? (
                <p className="flex items-center gap-1.5 text-xs text-muted-foreground">
                  <Loader2 className="h-3 w-3 animate-spin" aria-hidden="true" />
                  Finding address...
                </p>
              ) : null}
            </div>
          </div>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={handleClear}
            disabled={disabled}
            className="-ml-2 mt-1 h-8 gap-1.5 px-2 text-muted-foreground hover:text-destructive"
          >
            <X className="h-4 w-4" aria-hidden="true" />
            Clear location
          </Button>
        </div>
      )}
    </section>
  );
};

export default LocationPicker;
