import { useState } from 'react';
import { cn } from '@/lib/utils';
import { brandInitials } from '@/lib/brands';

interface BrandLogoProps {
  name: string;
  logoUrl?: string | null;
  /**
   * What to show when there is no logo or it fails to load: the full brand name
   * (cards, brand strips) or two-letter initials (small thumbnails).
   */
  fallback?: 'name' | 'initials';
  /** Sizing for the logo image; the fallback badge is sized the same way. */
  className?: string;
}

/**
 * A brand logo that never leaves a broken-image icon behind. A missing logo, or
 * one that fails to load (deleted file, bad URL, a format the browser cannot
 * decode), is replaced by the brand name or its initials.
 */
const BrandLogo = ({ name, logoUrl, fallback = 'name', className }: BrandLogoProps) => {
  // Remember which URL failed rather than a plain flag, so a corrected logo
  // URL is tried again without needing an effect to reset state.
  const [failedUrl, setFailedUrl] = useState<string | null>(null);
  const src = typeof logoUrl === 'string' ? logoUrl.trim() : '';

  if (src && failedUrl !== src) {
    return (
      <img
        src={src}
        alt={`${name} logo`}
        loading="lazy"
        decoding="async"
        onError={() => setFailedUrl(src)}
        className={cn('object-contain', className)}
      />
    );
  }

  const showInitials = fallback === 'initials';
  return (
    <span
      title={name}
      className={cn(
        'inline-flex items-center justify-center text-center font-semibold leading-tight text-foreground',
        showInitials ? 'text-base tracking-wide' : 'text-sm',
        className,
      )}
    >
      {showInitials ? (
        <>
          <span aria-hidden="true">{brandInitials(name)}</span>
          <span className="sr-only">{name}</span>
        </>
      ) : name}
    </span>
  );
};

export default BrandLogo;
