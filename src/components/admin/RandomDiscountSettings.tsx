import { useCallback, useEffect, useState } from 'react';
import { toast } from 'sonner';
import { AlertTriangle, Loader2, Percent } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { supabase } from '@/integrations/supabase/client';
import { formatDiscountPercent } from '@/lib/discounts';
import {
  RANDOM_DISCOUNT_MAX_PERCENT,
  isMissingTableError,
  validateRandomDiscountInput,
} from '@/lib/randomDiscountForm';

type LoadState =
  | { status: 'loading' }
  | { status: 'ready' }
  | { status: 'missing-table' }
  | { status: 'error'; message: string };

const MIGRATION_NOTICE = 'Run the random discount SQL migration first.';

const getErrorMessage = (error: unknown) => {
  if (error instanceof Error) return error.message;
  if (error && typeof error === 'object' && 'message' in error) return String((error as { message: unknown }).message);
  return String(error);
};

/**
 * Admin card for the Automatic Random Discount: the single row (id = 1) of
 * public.discount_settings. The percent each cart gets is decided by the server
 * between these two bounds; nothing here is ever sent by the storefront.
 */
const RandomDiscountSettings = () => {
  const [state, setState] = useState<LoadState>({ status: 'loading' });
  const [enabled, setEnabled] = useState(true);
  const [min, setMin] = useState('');
  const [max, setMax] = useState('');
  const [fieldError, setFieldError] = useState<{ field: 'min' | 'max'; error: string } | null>(null);
  const [saving, setSaving] = useState(false);

  const load = useCallback(async () => {
    setState({ status: 'loading' });
    // The table is created by the random discount migration, so it is not in the generated client types.
    const { data, error } = await supabase
      .from('discount_settings' as never)
      .select('enabled, min_percent, max_percent')
      .eq('id', 1)
      .maybeSingle();
    if (error) {
      console.error('Could not load random discount settings:', error);
      setState(isMissingTableError(error) ? { status: 'missing-table' } : { status: 'error', message: getErrorMessage(error) });
      return;
    }
    const row = data as { enabled?: boolean; min_percent?: number | string; max_percent?: number | string } | null;
    if (!row) {
      setState({ status: 'error', message: 'The discount settings row (id 1) is missing. Run the random discount SQL migration again.' });
      return;
    }
    setEnabled(row.enabled !== false);
    setMin(String(Number(row.min_percent)));
    setMax(String(Number(row.max_percent)));
    setFieldError(null);
    setState({ status: 'ready' });
  }, []);

  useEffect(() => {
    void load();
  }, [load]);

  const save = async () => {
    const result = validateRandomDiscountInput({ min, max });
    if (result.ok === false) {
      setFieldError({ field: result.field, error: result.error });
      toast.error(result.error);
      return;
    }
    setFieldError(null);
    setSaving(true);
    try {
      const { data, error } = await supabase
        .from('discount_settings' as never)
        .update({
          enabled,
          min_percent: result.min_percent,
          max_percent: result.max_percent,
          updated_at: new Date().toISOString(),
        } as never)
        .eq('id', 1)
        .select('id');
      if (error) throw error;
      if (!data || (data as unknown[]).length === 0) {
        throw new Error('Nothing was saved. Your account may not have permission to change discount settings.');
      }
      setMin(String(result.min_percent));
      setMax(String(result.max_percent));
      toast.success(
        enabled
          ? `Saved. Carts now get a random discount of ${formatDiscountPercent(result.min_percent)} to ${formatDiscountPercent(result.max_percent)}.`
          : 'Saved. The automatic random discount is switched off.',
      );
    } catch (error) {
      console.error('Could not save random discount settings:', error);
      if (isMissingTableError(error)) {
        setState({ status: 'missing-table' });
        toast.error(MIGRATION_NOTICE);
      } else {
        toast.error(getErrorMessage(error));
      }
    } finally {
      setSaving(false);
    }
  };

  return (
    <Card className="max-w-2xl">
      <CardHeader>
        <CardTitle className="flex items-center gap-2 text-lg">
          <Percent className="h-5 w-5 text-primary" aria-hidden="true" />
          Automatic Random Discount
        </CardTitle>
        <CardDescription>
          Each cart gets a random discount between the minimum and maximum, decided by the server. It changes when the
          cart changes. No minimum order.
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-5">
        {state.status === 'loading' && (
          <div className="flex items-center gap-2 text-sm text-gray-500" role="status">
            <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" /> Loading settings…
          </div>
        )}

        {state.status === 'missing-table' && (
          <div className="flex items-start gap-2 rounded-lg border border-amber-200 bg-amber-50 p-3 text-sm text-amber-900" role="alert">
            <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" aria-hidden="true" />
            <span>{MIGRATION_NOTICE}</span>
          </div>
        )}

        {state.status === 'error' && (
          <div className="space-y-3" role="alert">
            <div className="flex items-start gap-2 rounded-lg border border-red-200 bg-red-50 p-3 text-sm text-red-900">
              <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" aria-hidden="true" />
              <span className="min-w-0 break-words">{state.message}</span>
            </div>
            <Button type="button" variant="outline" onClick={() => void load()}>Try again</Button>
          </div>
        )}

        {state.status === 'ready' && (
          <>
            <div className="flex items-center justify-between gap-4 rounded-lg border border-gray-100 p-3">
              <Label htmlFor="random-discount-enabled" className="cursor-pointer">
                <span className="block font-medium">Enabled</span>
                <span className="block text-xs font-normal text-gray-500">
                  {enabled ? 'Customers get an automatic random discount.' : 'No automatic discount is applied.'}
                </span>
              </Label>
              <Switch id="random-discount-enabled" checked={enabled} onCheckedChange={setEnabled} disabled={saving} />
            </div>

            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-1.5">
                <Label htmlFor="random-discount-min">Minimum %</Label>
                <Input
                  id="random-discount-min"
                  inputMode="decimal"
                  value={min}
                  onChange={(e) => setMin(e.target.value)}
                  disabled={saving}
                  aria-invalid={fieldError?.field === 'min'}
                  placeholder="e.g. 0.5"
                />
                {fieldError?.field === 'min' && <p className="text-xs text-red-600">{fieldError.error}</p>}
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="random-discount-max">Maximum %</Label>
                <Input
                  id="random-discount-max"
                  inputMode="decimal"
                  value={max}
                  onChange={(e) => setMax(e.target.value)}
                  disabled={saving}
                  aria-invalid={fieldError?.field === 'max'}
                  placeholder={`up to ${RANDOM_DISCOUNT_MAX_PERCENT}`}
                />
                {fieldError?.field === 'max' && <p className="text-xs text-red-600">{fieldError.error}</p>}
              </div>
            </div>
            <p className="text-xs text-gray-500">
              Both values must be above 0%, at most {RANDOM_DISCOUNT_MAX_PERCENT}%, with up to 2 decimals, and the
              minimum cannot exceed the maximum.
            </p>

            <Button type="button" onClick={() => void save()} disabled={saving}>
              {saving ? (
                <>
                  <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" /> Saving…
                </>
              ) : (
                'Save'
              )}
            </Button>
          </>
        )}
      </CardContent>
    </Card>
  );
};

export default RandomDiscountSettings;
