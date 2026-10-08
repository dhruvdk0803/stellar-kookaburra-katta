import { BadgePercent, Loader2 } from 'lucide-react';
import { cn } from '@/lib/utils';
import { getDiscountBanner } from '@/lib/checkout';

interface DiscountProgressProps {
  /** Server-decided percent from useCartDiscount (the previous cart's value while loading). */
  percent: number;
  isLoading: boolean;
  hasItems: boolean;
  /** `card`: full banner (cart). `inline`: one compact line (checkout summary). */
  variant?: 'card' | 'inline';
  className?: string;
}

/**
 * Friendly banner for the Automatic Random Discount. The percent is chosen by
 * the server for the current cart and changes when the cart changes; there is
 * no tier, minimum order or "add more to unlock" text. Renders nothing when
 * there is no discount to talk about.
 */
const DiscountProgress = ({ percent, isLoading, hasItems, variant = 'card', className }: DiscountProgressProps) => {
  const banner = getDiscountBanner(percent, { isLoading, hasItems });
  if (!banner) return null;
  const loading = banner.status === 'loading';

  if (variant === 'inline') {
    return (
      <p className={cn('flex items-start gap-2 text-sm text-emerald-800', className)} aria-live="polite">
        {loading ? (
          <Loader2 className="mt-0.5 h-4 w-4 shrink-0 animate-spin text-emerald-600" aria-hidden="true" />
        ) : (
          <BadgePercent className="mt-0.5 h-4 w-4 shrink-0 text-emerald-600" aria-hidden="true" />
        )}
        <span className="min-w-0 break-words">{banner.message}</span>
      </p>
    );
  }

  return (
    <div className={cn('rounded-2xl border border-gray-100 bg-white p-4 shadow-sm sm:p-5', className)}>
      <div className="flex items-start gap-3">
        <div
          className={cn(
            'flex h-10 w-10 shrink-0 items-center justify-center rounded-full',
            loading ? 'bg-primary/10 text-primary' : 'bg-emerald-50 text-emerald-600',
          )}
        >
          {loading ? (
            <Loader2 className="h-5 w-5 animate-spin" aria-hidden="true" />
          ) : (
            <BadgePercent className="h-5 w-5" aria-hidden="true" />
          )}
        </div>
        <div className="min-w-0 flex-1" aria-live="polite">
          <p className="text-xs font-semibold uppercase tracking-wider text-gray-500">Automatic Random Discount</p>
          <p className={cn('mt-1 break-words font-medium', loading ? 'text-gray-700' : 'text-emerald-800')}>
            {banner.message}
          </p>
          {banner.hint && <p className="mt-0.5 break-words text-sm text-gray-600">{banner.hint}</p>}
        </div>
      </div>
    </div>
  );
};

export default DiscountProgress;
