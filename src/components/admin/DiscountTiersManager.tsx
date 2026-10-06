import { useCallback, useEffect, useMemo, useState } from 'react';
import type { KeyboardEvent } from 'react';
import { useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { AlertTriangle, Loader2, Percent, Plus } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Switch } from '@/components/ui/switch';
import { supabase } from '@/integrations/supabase/client';
import { DISCOUNT_TIERS_QUERY_KEY } from '@/hooks/useDiscountTiers';
import { formatDiscountPercent } from '@/lib/discounts';
import { formatRupees } from '@/lib/money';
import {
  isMissingTableError,
  tierSavingAtMinimum,
  validateTierInput,
  type TierDraft,
} from '@/lib/discountTierForm';

interface TierRow {
  id: string;
  min_subtotal: number;
  discount_percent: number;
  is_active: boolean;
}

type LoadState =
  | { status: 'loading' }
  | { status: 'ready' }
  | { status: 'missing-table' }
  | { status: 'error'; message: string };

const EMPTY_DRAFT: TierDraft = { min: '', percent: '' };

// Same three columns on wide screens; on phones each tier is a small card.
const ROW_GRID = 'sm:grid-cols-[minmax(0,1.3fr)_minmax(0,1fr)_5rem_auto]';

const getErrorMessage = (error: unknown) => {
  if (error instanceof Error) return error.message;
  if (error && typeof error === 'object' && 'message' in error) return String((error as { message: unknown }).message);
  return String(error);
};

const describeSaveError = (error: unknown) => {
  if (isMissingTableError(error)) return 'Run the discount tiers SQL migration first.';
  const code = error && typeof error === 'object' ? (error as { code?: unknown }).code : undefined;
  if (code === '23505') return 'A tier with that minimum cart value already exists.';
  if (code === '23514') return 'The database rejected these values (minimum above ₹0, discount above 0% and at most 50%).';
  return getErrorMessage(error);
};

const rupees = (amount: number) => `₹${formatRupees(amount)}`;

const toRow = (row: Record<string, unknown>): TierRow => ({
  id: String(row.id),
  min_subtotal: Number(row.min_subtotal),
  discount_percent: Number(row.discount_percent),
  is_active: row.is_active !== false,
});

interface FieldProps {
  label: string;
  value: string;
  onChange: (value: string) => void;
  onKeyDown?: (event: KeyboardEvent<HTMLInputElement>) => void;
  placeholder?: string;
  disabled?: boolean;
  /** Show the label on phones only (wide screens use the column headers). */
  mobileLabelOnly?: boolean;
}

const Field = ({ label, value, onChange, onKeyDown, placeholder, disabled, mobileLabelOnly }: FieldProps) => (
  <label className="block min-w-0 text-xs font-medium text-gray-600">
    <span className={mobileLabelOnly ? 'mb-1 block sm:sr-only' : 'mb-1 block'}>{label}</span>
    <Input
      inputMode="decimal"
      autoComplete="off"
      placeholder={placeholder}
      aria-label={label}
      value={value}
      disabled={disabled}
      onChange={(event) => onChange(event.target.value)}
      onKeyDown={onKeyDown}
      className="w-full"
    />
  </label>
);

/**
 * Admin editor for public.discount_tiers: the cart-value discount ladder. The
 * storefront reads active tiers through useDiscountTiers; the order edge
 * functions apply the same rule on the server.
 */
const DiscountTiersManager = () => {
  const queryClient = useQueryClient();
  const [tiers, setTiers] = useState<TierRow[]>([]);
  const [load, setLoad] = useState<LoadState>({ status: 'loading' });
  const [editingId, setEditingId] = useState<string | null>(null);
  const [draft, setDraft] = useState<TierDraft>(EMPTY_DRAFT);
  const [draftError, setDraftError] = useState<string | null>(null);
  const [newDraft, setNewDraft] = useState<TierDraft>(EMPTY_DRAFT);
  const [newError, setNewError] = useState<string | null>(null);
  // Row id being saved/toggled/deleted, or 'new' while a tier is being added.
  const [busyId, setBusyId] = useState<string | null>(null);

  const loadTiers = useCallback(async (showSpinner: boolean) => {
    if (showSpinner) setLoad({ status: 'loading' });
    // Admins can read inactive tiers too (RLS), so this lists every row.
    const { data, error } = await supabase
      .from('discount_tiers')
      .select('id, min_subtotal, discount_percent, is_active')
      .order('min_subtotal', { ascending: true });
    if (error) {
      setLoad(isMissingTableError(error) ? { status: 'missing-table' } : { status: 'error', message: getErrorMessage(error) });
      return;
    }
    setTiers((data ?? []).map(toRow));
    setLoad({ status: 'ready' });
  }, []);

  useEffect(() => {
    loadTiers(true).catch((error: unknown) => setLoad({ status: 'error', message: getErrorMessage(error) }));
  }, [loadTiers]);

  const sortedTiers = useMemo(() => [...tiers].sort((a, b) => a.min_subtotal - b.min_subtotal), [tiers]);
  const activeCount = tiers.filter((tier) => tier.is_active).length;

  // Storefront carts cache tiers; refresh them so this browser sees the change straight away.
  const refreshAfterChange = async () => {
    await Promise.all([
      loadTiers(false),
      queryClient.invalidateQueries({ queryKey: DISCOUNT_TIERS_QUERY_KEY }),
    ]);
  };

  const reportFailure = (action: string, error: unknown) => {
    if (isMissingTableError(error)) setLoad({ status: 'missing-table' });
    const message = describeSaveError(error);
    toast.error(`${action}: ${message}`);
    return message;
  };

  const startEdit = (tier: TierRow) => {
    setEditingId(tier.id);
    setDraft({ min: String(tier.min_subtotal), percent: String(tier.discount_percent) });
    setDraftError(null);
  };

  const cancelEdit = () => {
    setEditingId(null);
    setDraftError(null);
  };

  const saveEdit = async (tier: TierRow) => {
    if (busyId) return;
    const result = validateTierInput(draft, tiers, tier.id);
    if (result.ok === false) { setDraftError(result.error); return; }
    setDraftError(null);
    setBusyId(tier.id);
    try {
      const { data, error } = await supabase
        .from('discount_tiers')
        .update({ min_subtotal: result.min_subtotal, discount_percent: result.discount_percent })
        .eq('id', tier.id)
        .select('id');
      if (error) throw error;
      if (!data?.length) throw new Error('The tier was not changed (it may have been deleted, or you lack permission).');
      toast.success(`Tier saved: ${rupees(result.min_subtotal)} at ${formatDiscountPercent(result.discount_percent)}. New carts use it immediately.`);
      setEditingId(null);
      await refreshAfterChange();
    } catch (error: unknown) {
      setDraftError(reportFailure('Could not save tier', error));
    } finally {
      setBusyId(null);
    }
  };

  const toggleActive = async (tier: TierRow, isActive: boolean) => {
    if (busyId) return;
    setBusyId(tier.id);
    try {
      const { data, error } = await supabase
        .from('discount_tiers')
        .update({ is_active: isActive })
        .eq('id', tier.id)
        .select('id');
      if (error) throw error;
      if (!data?.length) throw new Error('The tier was not changed (it may have been deleted, or you lack permission).');
      toast.success(`Tier ${rupees(tier.min_subtotal)} is now ${isActive ? 'active' : 'inactive'}. New carts use this immediately.`);
      await refreshAfterChange();
    } catch (error: unknown) {
      reportFailure('Could not change tier', error);
    } finally {
      setBusyId(null);
    }
  };

  const deleteTier = async (tier: TierRow) => {
    if (busyId) return;
    const label = `${rupees(tier.min_subtotal)} at ${formatDiscountPercent(tier.discount_percent)}`;
    if (!window.confirm(`Delete the ${label} tier? Carts that reached it will get the next lower active tier instead, or no discount if there is none.`)) return;
    setBusyId(tier.id);
    try {
      const { data, error } = await supabase.from('discount_tiers').delete().eq('id', tier.id).select('id');
      if (error) throw error;
      if (!data?.length) throw new Error('The tier was not deleted (it may already be gone, or you lack permission).');
      toast.success(`Tier deleted: ${label}.`);
      if (editingId === tier.id) cancelEdit();
      await refreshAfterChange();
    } catch (error: unknown) {
      reportFailure('Could not delete tier', error);
    } finally {
      setBusyId(null);
    }
  };

  const addTier = async () => {
    if (busyId) return;
    const result = validateTierInput(newDraft, tiers, null);
    if (result.ok === false) { setNewError(result.error); return; }
    setNewError(null);
    setBusyId('new');
    try {
      const { data, error } = await supabase
        .from('discount_tiers')
        .insert([{ min_subtotal: result.min_subtotal, discount_percent: result.discount_percent, is_active: true }])
        .select('id');
      if (error) throw error;
      if (!data?.length) throw new Error('The tier was not added (you may lack permission).');
      toast.success(`Tier added: ${rupees(result.min_subtotal)} at ${formatDiscountPercent(result.discount_percent)}. New carts use it immediately.`);
      setNewDraft(EMPTY_DRAFT);
      await refreshAfterChange();
    } catch (error: unknown) {
      setNewError(reportFailure('Could not add tier', error));
    } finally {
      setBusyId(null);
    }
  };

  const editKeys = (tier: TierRow) => (event: KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Enter') { event.preventDefault(); void saveEdit(tier); }
    else if (event.key === 'Escape') cancelEdit();
  };

  const newKeys = (event: KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Enter') { event.preventDefault(); void addTier(); }
  };

  return (
    <Card className="border-0 shadow-sm">
      <CardHeader>
        <CardTitle className="flex items-center"><Percent className="mr-2 h-5 w-5" /> Bulk Purchase Discount Tiers</CardTitle>
      </CardHeader>
      <CardContent className="space-y-5">
        <div className="space-y-2 text-sm text-gray-600">
          <p>
            The highest tier a customer&apos;s cart subtotal reaches applies to the ENTIRE subtotal (e.g. ₹3,000 at 1.4% = ₹42 off).
            Shipping is not discounted.
          </p>
          <p className="text-xs text-gray-500">
            Tier changes apply to new carts immediately. A cart a customer already has open updates when they refresh, and the
            order total is always recalculated from the current tiers when the order is placed.
          </p>
        </div>

        {load.status === 'loading' && (
          <div className="flex items-center gap-2 py-6 text-sm text-gray-500" role="status">
            <Loader2 className="h-4 w-4 animate-spin" /> Loading discount tiers…
          </div>
        )}

        {load.status === 'missing-table' && (
          <div role="alert" className="flex items-start gap-3 rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">
            <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" aria-hidden="true" />
            <div className="min-w-0 space-y-2">
              <p className="font-semibold">Run the discount tiers SQL migration first</p>
              <p className="text-xs">
                The <code className="rounded bg-amber-100 px-1">discount_tiers</code> table does not exist in the database yet. Run{' '}
                <code className="break-all rounded bg-amber-100 px-1">supabase/migrations/20261005000200_discount_tiers_and_order_checkout.sql</code>{' '}
                in the Supabase SQL editor, then check again. Until then customers see no cart discount.
              </p>
              <Button type="button" variant="outline" size="sm" className="bg-white" onClick={() => void loadTiers(true)}>Check again</Button>
            </div>
          </div>
        )}

        {load.status === 'error' && (
          <div role="alert" className="flex items-start gap-3 rounded-xl border border-red-200 bg-red-50 p-4 text-sm text-red-800">
            <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" aria-hidden="true" />
            <div className="min-w-0 space-y-2">
              <p className="font-semibold">Could not load discount tiers</p>
              <p className="break-words text-xs">{load.message}</p>
              <Button type="button" variant="outline" size="sm" className="bg-white" onClick={() => void loadTiers(true)}>Try again</Button>
            </div>
          </div>
        )}

        {load.status === 'ready' && (
          <>
            <p className="text-xs text-gray-500">
              {tiers.length} tier{tiers.length === 1 ? '' : 's'} · {activeCount} active
            </p>
            {tiers.length > 0 && activeCount === 0 && (
              <p role="status" className="rounded-lg bg-amber-50 px-3 py-2 text-xs text-amber-800">
                No tier is active, so customers currently get no cart discount.
              </p>
            )}

            <div className="space-y-3">
              <div className={`hidden gap-3 px-3 text-xs font-medium uppercase text-gray-500 sm:grid ${ROW_GRID}`}>
                <span>Minimum cart value (₹)</span>
                <span>Discount (%)</span>
                <span>Active</span>
                <span className="text-right">Actions</span>
              </div>

              {sortedTiers.length === 0 && (
                <p className="rounded-xl border border-dashed border-gray-200 px-4 py-6 text-center text-sm text-gray-500">
                  No tiers yet. Customers get no cart discount until you add one below.
                </p>
              )}

              {sortedTiers.map((tier) => {
                const isEditing = editingId === tier.id;
                const isBusy = busyId === tier.id;
                const saving = tierSavingAtMinimum(tier.min_subtotal, tier.discount_percent);
                return (
                  <div
                    key={tier.id}
                    className={`grid grid-cols-2 gap-3 rounded-xl border p-3 sm:items-center ${ROW_GRID} ${tier.is_active ? 'border-gray-100' : 'border-gray-100 bg-gray-50/70'}`}
                  >
                    {isEditing ? (
                      <>
                        <Field
                          label="Minimum cart value (₹)"
                          mobileLabelOnly
                          value={draft.min}
                          onChange={(min) => setDraft((previous) => ({ ...previous, min }))}
                          onKeyDown={editKeys(tier)}
                          disabled={isBusy}
                        />
                        <Field
                          label="Discount (%)"
                          mobileLabelOnly
                          value={draft.percent}
                          onChange={(percent) => setDraft((previous) => ({ ...previous, percent }))}
                          onKeyDown={editKeys(tier)}
                          disabled={isBusy}
                        />
                      </>
                    ) : (
                      <>
                        <div className="min-w-0">
                          <span className="block text-xs text-gray-500 sm:hidden">Minimum cart value (₹)</span>
                          <span className="font-semibold text-gray-900">{rupees(tier.min_subtotal)}</span>
                        </div>
                        <div className="min-w-0">
                          <span className="block text-xs text-gray-500 sm:hidden">Discount (%)</span>
                          <span className="font-semibold text-gray-900">{formatDiscountPercent(tier.discount_percent)}</span>
                        </div>
                      </>
                    )}

                    <div className="col-span-2 flex flex-wrap items-center justify-between gap-3 sm:contents">
                      <label className="flex items-center gap-2 text-sm text-gray-700">
                        <Switch
                          checked={tier.is_active}
                          disabled={busyId !== null}
                          onCheckedChange={(checked) => void toggleActive(tier, checked)}
                          aria-label={`Tier ${rupees(tier.min_subtotal)} active`}
                        />
                        <span className="sm:sr-only">{tier.is_active ? 'Active' : 'Inactive'}</span>
                      </label>
                      <div className="flex items-center justify-end gap-2">
                        {isEditing ? (
                          <>
                            <Button type="button" size="sm" className="h-8 rounded-full text-xs" disabled={isBusy} onClick={() => void saveEdit(tier)}>
                              {isBusy ? <Loader2 className="mr-1 h-3.5 w-3.5 animate-spin" /> : null}
                              Save
                            </Button>
                            <Button type="button" variant="outline" size="sm" className="h-8 rounded-full text-xs" disabled={isBusy} onClick={cancelEdit}>
                              Cancel
                            </Button>
                          </>
                        ) : (
                          <>
                            <Button type="button" variant="outline" size="sm" className="h-8 rounded-full text-xs" disabled={busyId !== null} onClick={() => startEdit(tier)} aria-label={`Edit tier ${rupees(tier.min_subtotal)}`}>
                              Edit
                            </Button>
                            <Button
                              type="button"
                              variant="outline"
                              size="sm"
                              className="h-8 rounded-full border-red-100 text-xs text-red-600 hover:bg-red-50"
                              disabled={busyId !== null}
                              onClick={() => void deleteTier(tier)}
                              aria-label={`Delete tier ${rupees(tier.min_subtotal)}`}
                            >
                              {isBusy ? <Loader2 className="mr-1 h-3.5 w-3.5 animate-spin" /> : null}
                              Delete
                            </Button>
                          </>
                        )}
                      </div>
                    </div>

                    {isEditing && draftError ? (
                      <p role="alert" className="col-span-2 text-xs font-medium text-red-600 sm:col-span-4">{draftError}</p>
                    ) : (
                      <p className="col-span-2 text-xs text-gray-500 sm:col-span-4">
                        {tier.is_active
                          ? `A ${rupees(tier.min_subtotal)} cart saves ${rupees(saving)}.`
                          : 'Inactive: customers do not get this tier.'}
                      </p>
                    )}
                  </div>
                );
              })}
            </div>

            <div className="rounded-xl border border-dashed border-gray-300 bg-gray-50/60 p-3">
              <p className="mb-2 text-sm font-semibold text-gray-800">Add a tier</p>
              <div className="grid grid-cols-2 gap-3 sm:grid-cols-[minmax(0,1.3fr)_minmax(0,1fr)_auto] sm:items-end">
                <Field
                  label="Minimum cart value (₹)"
                  placeholder="e.g. 5000"
                  value={newDraft.min}
                  onChange={(min) => setNewDraft((previous) => ({ ...previous, min }))}
                  onKeyDown={newKeys}
                  disabled={busyId === 'new'}
                />
                <Field
                  label="Discount (%)"
                  placeholder="e.g. 2"
                  value={newDraft.percent}
                  onChange={(percent) => setNewDraft((previous) => ({ ...previous, percent }))}
                  onKeyDown={newKeys}
                  disabled={busyId === 'new'}
                />
                <Button type="button" className="col-span-2 rounded-full sm:col-span-1" disabled={busyId !== null} onClick={() => void addTier()}>
                  {busyId === 'new' ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <Plus className="mr-2 h-4 w-4" />}
                  Add tier
                </Button>
              </div>
              {newError && <p role="alert" className="mt-2 text-xs font-medium text-red-600">{newError}</p>}
              <p className="mt-2 text-xs text-gray-500">Minimum above ₹0, discount above 0% and at most 50%, up to 2 decimals. Each minimum can be used once.</p>
            </div>
          </>
        )}
      </CardContent>
    </Card>
  );
};

export default DiscountTiersManager;
