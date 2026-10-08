import { cn } from '@/lib/utils';
import { formatDiscountPercent, type calculateOrderTotals } from '@/lib/discounts';
import { formatRupees } from '@/lib/money';

interface OrderTotalsProps {
  totals: ReturnType<typeof calculateOrderTotals>;
  className?: string;
}

/**
 * Subtotal / Automatic Random Discount / Shipping / Total, shared by the cart and
 * checkout so both always show the same figures the server will charge.
 */
const OrderTotals = ({ totals, className }: OrderTotalsProps) => (
  <dl className={cn('space-y-3 text-sm text-gray-600', className)}>
    <div className="flex items-start justify-between gap-4">
      <dt>Subtotal (Incl. taxes)</dt>
      <dd className="whitespace-nowrap font-medium text-gray-900">₹{formatRupees(totals.subtotal, true)}</dd>
    </div>
    {totals.tier && totals.discountAmount > 0 && (
      <div className="flex items-start justify-between gap-4 font-medium text-emerald-700">
        <dt>Automatic Random Discount ({formatDiscountPercent(totals.discountPercent)})</dt>
        <dd className="whitespace-nowrap">−₹{formatRupees(totals.discountAmount, true)}</dd>
      </div>
    )}
    <div className="flex items-start justify-between gap-4">
      <dt>Shipping</dt>
      <dd className="whitespace-nowrap font-medium text-emerald-700">
        {totals.shipping > 0 ? `₹${formatRupees(totals.shipping, true)}` : 'FREE'}
      </dd>
    </div>
    <div className="flex items-center justify-between gap-4 border-t border-gray-100 pt-4">
      <dt className="text-base font-bold text-gray-900">Total</dt>
      <dd className="whitespace-nowrap text-xl font-bold text-primary">₹{formatRupees(totals.total, true)}</dd>
    </div>
  </dl>
);

export default OrderTotals;
