import { useId } from 'react';
import { CreditCard, QrCode, type LucideIcon } from 'lucide-react';
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group';
import { cn } from '@/lib/utils';
import { PAYMENT_METHOD_LABELS, UPI_ON_DELIVERY_DESCRIPTION, type PaymentMethod } from '@/lib/paymentMethods';

interface PaymentMethodSelectorProps {
  value: PaymentMethod;
  onChange: (value: PaymentMethod) => void;
  disabled?: boolean;
  className?: string;
}

const OPTIONS: { value: PaymentMethod; title: string; description: string; icon: LucideIcon }[] = [
  {
    value: 'razorpay',
    title: 'Pay Online',
    description: 'Cards, UPI, net banking & wallets via Razorpay.',
    icon: CreditCard,
  },
  {
    value: 'upi_on_delivery',
    title: PAYMENT_METHOD_LABELS.upi_on_delivery,
    description: UPI_ON_DELIVERY_DESCRIPTION,
    icon: QrCode,
  },
];

const isPaymentMethod = (value: string): value is PaymentMethod => OPTIONS.some((option) => option.value === value);

/** Accessible two-card radio group (arrow keys move between options). There is deliberately no cash option. */
const PaymentMethodSelector = ({ value, onChange, disabled = false, className }: PaymentMethodSelectorProps) => {
  const baseId = useId();
  const headingId = `${baseId}-heading`;

  return (
    <section className={className} aria-labelledby={headingId}>
      <h3 id={headingId} className="mb-4 font-semibold text-gray-900">Payment Method</h3>
      <RadioGroup
        value={value}
        onValueChange={(next) => { if (isPaymentMethod(next)) onChange(next); }}
        disabled={disabled}
        aria-labelledby={headingId}
        className="grid grid-cols-1 gap-3 sm:grid-cols-2"
      >
        {OPTIONS.map((option) => {
          const id = `${baseId}-${option.value}`;
          const titleId = `${id}-title`;
          const descriptionId = `${id}-description`;
          const selected = value === option.value;
          const Icon = option.icon;
          return (
            <label
              key={option.value}
              htmlFor={id}
              className={cn(
                'flex min-h-[72px] cursor-pointer items-start gap-3 rounded-xl border p-4 transition-colors',
                selected ? 'border-primary bg-primary/5 ring-1 ring-primary' : 'border-gray-200 bg-white hover:border-gray-300',
                disabled && 'cursor-not-allowed opacity-70',
              )}
            >
              <RadioGroupItem
                value={option.value}
                id={id}
                aria-labelledby={titleId}
                aria-describedby={descriptionId}
                className="mt-3 shrink-0"
              />
              <span
                className={cn(
                  'flex h-10 w-10 shrink-0 items-center justify-center rounded-full',
                  selected ? 'bg-primary text-primary-foreground' : 'bg-gray-100 text-gray-600',
                )}
                aria-hidden="true"
              >
                <Icon className="h-5 w-5" />
              </span>
              <span className="min-w-0 flex-1">
                <span id={titleId} className="block font-medium text-gray-900">{option.title}</span>
                <span id={descriptionId} className="mt-0.5 block break-words text-sm text-gray-500">{option.description}</span>
              </span>
            </label>
          );
        })}
      </RadioGroup>
    </section>
  );
};

export default PaymentMethodSelector;
