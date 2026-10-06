import type { ReactNode } from 'react';
import { MapPin } from 'lucide-react';
import { buildGoogleMapsUrl, toCoordinate } from '@/lib/location';
import { cn } from '@/lib/utils';

interface OpenInMapsLinkProps {
  latitude?: number | string | null;
  longitude?: number | string | null;
  /** Human-readable address captured at checkout; shown as small muted text. */
  label?: string | null;
  className?: string;
  /** Replaces the default "Open in Maps" text. */
  children?: ReactNode;
}

/**
 * Admin-facing "Open in Maps" link for an order's saved delivery pin.
 * Renders nothing when the coordinates are missing or invalid (older orders).
 */
const OpenInMapsLink = ({ latitude, longitude, label, className, children }: OpenInMapsLinkProps) => {
  const lat = toCoordinate(latitude);
  const lng = toCoordinate(longitude);
  const url = lat !== null && lng !== null ? buildGoogleMapsUrl(lat, lng) : null;
  if (!url) return null;

  const trimmedLabel = typeof label === 'string' ? label.trim() : '';

  return (
    <span className="inline-flex max-w-full flex-col items-start gap-0.5">
      <a
        href={url}
        target="_blank"
        rel="noopener noreferrer"
        className={cn(
          'inline-flex items-center gap-1.5 text-sm font-medium text-primary underline-offset-4 hover:underline',
          className,
        )}
      >
        <MapPin className="h-4 w-4 shrink-0" aria-hidden="true" />
        {children ?? 'Open in Maps'}
      </a>
      {trimmedLabel && (
        <span className="max-w-full break-words text-xs text-muted-foreground">{trimmedLabel}</span>
      )}
    </span>
  );
};

export default OpenInMapsLink;
