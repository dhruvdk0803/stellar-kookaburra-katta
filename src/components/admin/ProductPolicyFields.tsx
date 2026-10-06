import React, { useId } from 'react';
import { Textarea } from '@/components/ui/textarea';
import { cn } from '@/lib/utils';
import { POLICY_MAX_LENGTH } from '@/lib/policies';

interface ProductPolicyFieldsProps {
  returnPolicy: string;
  replacementPolicy: string;
  onReturnPolicyChange: (value: string) => void;
  onReplacementPolicyChange: (value: string) => void;
}

interface PolicyFieldProps {
  id: string;
  label: string;
  helper: string;
  placeholder: string;
  value: string;
  onChange: (value: string) => void;
}

const PolicyField = ({ id, label, helper, placeholder, value, onChange }: PolicyFieldProps) => {
  const helperId = `${id}-help`;
  const nearLimit = value.length >= POLICY_MAX_LENGTH - 200;
  return (
    <div className="space-y-1.5">
      <label htmlFor={id} className="text-sm font-medium text-gray-700">{label}</label>
      <Textarea
        id={id}
        rows={6}
        maxLength={POLICY_MAX_LENGTH}
        placeholder={placeholder}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        aria-describedby={helperId}
        className="bg-white"
      />
      <div className="flex items-start justify-between gap-3">
        <p id={helperId} className="text-xs text-gray-500">{helper}</p>
        <p className={cn('shrink-0 text-xs tabular-nums', nearLimit ? 'font-medium text-amber-600' : 'text-gray-500')}>
          {value.length}/{POLICY_MAX_LENGTH}
        </p>
      </div>
    </div>
  );
};

/**
 * Per-product return and replacement policy text for the Admin product form.
 * Plain text; line breaks are kept on the product page.
 */
const ProductPolicyFields = ({
  returnPolicy,
  replacementPolicy,
  onReturnPolicyChange,
  onReplacementPolicyChange,
}: ProductPolicyFieldsProps) => {
  const baseId = useId();
  return (
    <div className="space-y-4 rounded-xl border border-gray-200 bg-gray-50/50 p-4">
      <div>
        <p className="text-sm font-semibold text-gray-800">Returns &amp; Replacement</p>
        <p className="text-xs text-gray-600">Plain text, shown in the Returns &amp; Replacement section of this product&apos;s page. Press Enter for a new line.</p>
      </div>
      <PolicyField
        id={`${baseId}-return`}
        label="Return Policy"
        placeholder="e.g. Returnable within 2 days of delivery if unused and in original packaging."
        helper="Shown on this product's page. Leave empty to use the store-wide default."
        value={returnPolicy}
        onChange={onReturnPolicyChange}
      />
      <PolicyField
        id={`${baseId}-replacement`}
        label="Replacement Policy"
        placeholder="e.g. Replacement for manufacturing defects reported with a photo within 2 days of delivery."
        helper="Shown on this product's page. Leave empty to show a short note pointing to the Returns page."
        value={replacementPolicy}
        onChange={onReplacementPolicyChange}
      />
    </div>
  );
};

export default ProductPolicyFields;
