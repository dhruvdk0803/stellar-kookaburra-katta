import { BadgePercent } from 'lucide-react';
import { cn } from '@/lib/utils';
import { getDiscountNudge } from '@/lib/checkout';
import type { DiscountTier } from '@/lib/discounts';

interface DiscountProgressProps {
  subtotal: number;
  tiers: DiscountTier[];
  /** `card`: full banner with a progress bar (cart). `inline`: one compact line (checkout summary). */
  variant?: 'card' | 'inline';
  className?: string;
}

/**
 * Cart-value discount incentive. All copy is derived from the admin-editable
 * tiers via getDiscountNudge; renders nothing when no tiers are configured.
 * Recomputed on every render, so it follows add/remove/quantity changes.
 */
const DiscountProgress = ({ subtotal, tiers, variant = 'card', className }: DiscountProgressProps) => {
  const nudge = getDiscountNudge(subtotal, tiers);
  if (!nudge) return null;

  if (variant === 'inline') {
    const text = nudge.status === 'locked' ? nudge.headline : nudge.nextStep;
    if (!text) return null;
    return (
      <p className={cn('flex items-start gap-2 text-sm text-emerald-800', className)} aria-live="polite">
        <BadgePercent className="mt-0.5 h-4 w-4 shrink-0 text-emerald-600" aria-hidden="true" />
        <span className="min-w-0 break-words">{text}</span>
      </p>
    );
  }

  const percentComplete = Math.round(nudge.progress * 100);
  const unlocked = nudge.status !== 'locked';

  return (
    <div className={cn('rounded-2xl border border-gray-100 bg-white p-4 shadow-sm sm:p-5', className)}>
      <div className="flex items-start gap-3">
        <div
          className={cn(
            'flex h-10 w-10 shrink-0 items-center justify-center rounded-full',
            unlocked ? 'bg-emerald-50 text-emerald-600' : 'bg-primary/10 text-primary',
          )}
        >
          <BadgePercent className="h-5 w-5" aria-hidden="true" />
        </div>
        <div className="min-w-0 flex-1" aria-live="polite">
          <p className="text-xs font-semibold uppercase tracking-wider text-gray-500">Bulk Purchase Discount</p>
          <p className={cn('mt-1 break-words font-medium', unlocked ? 'text-emerald-800' : 'text-gray-900')}>
            {nudge.headline}
          </p>
          {nudge.nextStep && <p className="mt-0.5 break-words text-sm text-gray-600">{nudge.nextStep}</p>}
        </div>
      </div>
      <div
        className="mt-4 h-1.5 w-full overflow-hidden rounded-full bg-gray-100"
        role="progressbar"
        aria-label={nudge.status === 'top' ? 'Best discount unlocked' : 'Progress toward the next discount'}
        aria-valuemin={0}
        aria-valuemax={100}
        aria-valuenow={percentComplete}
      >
        <div
          className="h-full rounded-full bg-emerald-600 transition-[width] duration-500 ease-out motion-reduce:transition-none"
          style={{ width: `${percentComplete}%` }}
        />
      </div>
    </div>
  );
};

export default DiscountProgress;
