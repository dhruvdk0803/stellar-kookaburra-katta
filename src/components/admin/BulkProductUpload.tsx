import { useMemo, useRef, useState } from 'react';
import { toast } from 'sonner';
import { AlertTriangle, CheckCircle2, Download, FileSpreadsheet, Loader2, Upload, XCircle } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Progress } from '@/components/ui/progress';
import { supabase } from '@/integrations/supabase/client';
import {
  BULK_IMPORT_LIMITS,
  buildCsvTemplate,
  buildImportReport,
  buildReportCsv,
  checkCsvFile,
  formatRowLabel,
  runBatchedImport,
  validateBulkCsv,
  type ExistingProduct,
  type ImportReport,
  type ImportStatus,
  type InsertError,
  type ReportMessage,
} from '@/lib/bulkImport';

interface BulkProductUploadProps {
  brands: { id: string; name: string; slug: string }[];
  categories: { id: string; name: string; slug: string; parent_id: string | null }[];
  onImported: () => void | Promise<void>;
}

type Phase = 'idle' | 'reading' | 'ready' | 'importing' | 'done';

const MAX_SHOWN_MESSAGES = 300;

const getErrorMessage = (error: unknown) => {
  if (error instanceof Error) return error.message;
  if (error && typeof error === 'object' && 'message' in error) return String((error as { message: unknown }).message);
  return String(error);
};

// Duplicate detection needs every product, drafts included (admins can read them).
const fetchExistingProducts = async (): Promise<ExistingProduct[]> => {
  const PAGE_SIZE = 1000;
  const all: ExistingProduct[] = [];
  for (let from = 0; ; from += PAGE_SIZE) {
    const { data, error } = await supabase
      .from('products')
      .select('id, name, brand_id')
      .order('id')
      .range(from, from + PAGE_SIZE - 1);
    if (error) throw error;
    if (!data?.length) break;
    all.push(...data.map((product: { name: string | null; brand_id: string | null }) => ({ name: product.name, brand_id: product.brand_id })));
    if (data.length < PAGE_SIZE) break;
  }
  return all;
};

const insertProducts = async (products: object[]): Promise<InsertError | null> => {
  const { error } = await supabase.from('products').insert(products);
  return error ? { message: error.message, code: error.code, details: error.details, hint: error.hint } : null;
};

// The BOM makes Excel read the file as UTF-8 (₹, accented names).
const downloadCsv = (fileName: string, csv: string) => {
  const url = URL.createObjectURL(new Blob(['\ufeff', csv], { type: 'text/csv;charset=utf-8' }));
  const link = document.createElement('a');
  link.href = url;
  link.download = fileName;
  document.body.appendChild(link);
  link.click();
  link.remove();
  setTimeout(() => URL.revokeObjectURL(url), 1000);
};

const MessageList = ({ messages }: { messages: ReportMessage[] }) => {
  if (!messages.length) return null;
  const shown = messages.slice(0, MAX_SHOWN_MESSAGES);
  return (
    <div className="max-h-64 overflow-y-auto rounded-lg border border-gray-200 bg-white">
      <ul className="divide-y divide-gray-100 text-xs">
        {shown.map((entry, index) => (
          <li key={`${entry.row}-${index}`} className="flex gap-2 px-3 py-2">
            {entry.level === 'error'
              ? <XCircle className="mt-0.5 h-3.5 w-3.5 shrink-0 text-red-500" aria-label="Error" />
              : <AlertTriangle className="mt-0.5 h-3.5 w-3.5 shrink-0 text-amber-500" aria-label="Warning" />}
            <span className="min-w-0 break-words text-gray-700 [overflow-wrap:anywhere]">
              <span className="font-semibold text-gray-900">{formatRowLabel(entry.row)}:</span> {entry.message}
            </span>
          </li>
        ))}
      </ul>
      {messages.length > MAX_SHOWN_MESSAGES && (
        <p className="border-t border-gray-100 px-3 py-2 text-xs text-gray-500">
          Showing the first {MAX_SHOWN_MESSAGES} of {messages.length} messages. Download the report to see all of them.
        </p>
      )}
    </div>
  );
};

const BulkProductUpload = ({ brands, categories, onImported }: BulkProductUploadProps) => {
  const [status, setStatus] = useState<ImportStatus>('draft');
  const [phase, setPhase] = useState<Phase>('idle');
  const [file, setFile] = useState<{ name: string; text: string } | null>(null);
  const [existingProducts, setExistingProducts] = useState<ExistingProduct[] | null>(null);
  const [loadError, setLoadError] = useState<string | null>(null);
  const [progress, setProgress] = useState({ done: 0, total: 0 });
  const [report, setReport] = useState<ImportReport | null>(null);
  const importingRef = useRef(false);

  const validation = useMemo(
    () => (file && existingProducts ? validateBulkCsv(file.text, { brands, categories, existingProducts, status }) : null),
    [file, existingProducts, brands, categories, status],
  );
  const warningCount = validation?.messages.filter((entry) => entry.level === 'warning').length ?? 0;
  const readyCount = validation && !validation.fileErrors.length ? validation.valid.length : 0;
  const isBusy = phase === 'reading' || phase === 'importing';
  const statusLabel = status === 'live' ? 'Live' : 'Draft';

  const clearSelection = () => {
    setFile(null);
    setExistingProducts(null);
    setLoadError(null);
    setPhase('idle');
  };

  const handleFileChange = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const selected = event.target.files?.[0];
    event.target.value = '';
    if (!selected || isBusy) return;
    clearSelection();
    setReport(null);
    const fileError = checkCsvFile({ name: selected.name, size: selected.size });
    if (fileError) {
      setLoadError(fileError);
      return;
    }
    setPhase('reading');
    try {
      const [text, existing] = await Promise.all([selected.text(), fetchExistingProducts()]);
      setFile({ name: selected.name, text });
      setExistingProducts(existing);
      setPhase('ready');
    } catch (error) {
      setLoadError(`Could not read the file or check existing products: ${getErrorMessage(error)}`);
      setPhase('idle');
    }
  };

  const handleImport = async () => {
    if (importingRef.current || !validation || validation.fileErrors.length || !validation.valid.length) return;
    importingRef.current = true;
    setPhase('importing');
    setProgress({ done: 0, total: validation.valid.length });
    try {
      const outcome = await runBatchedImport(validation.valid, insertProducts, {
        batchSize: BULK_IMPORT_LIMITS.batchSize,
        onProgress: (done, total) => setProgress({ done, total }),
      });
      const result = buildImportReport(validation, outcome);
      setReport(result);
      setFile(null);
      setExistingProducts(null);
      setPhase('done');
      if (result.failed) toast.warning(`Imported ${result.imported} product(s); ${result.failed} row(s) failed.`);
      else toast.success(`Imported ${result.imported} product(s).`);
      if (result.imported) {
        try {
          await onImported();
        } catch (error) {
          toast.error(`Products were imported, but the list could not be refreshed: ${getErrorMessage(error)}`);
        }
      }
    } catch (error) {
      toast.error(`Bulk upload failed: ${getErrorMessage(error)}`);
      setPhase('ready');
    } finally {
      importingRef.current = false;
    }
  };

  return (
    <Card className="border-0 shadow-sm">
      <CardHeader>
        <CardTitle className="flex items-center"><FileSpreadsheet className="mr-2 h-5 w-5 shrink-0" /> Bulk Upload (CSV)</CardTitle>
      </CardHeader>
      <CardContent className="min-w-0 space-y-4">
        <Button type="button" variant="outline" className="w-full" onClick={() => downloadCsv('katta-products-template.csv', buildCsvTemplate())}>
          <Download className="mr-2 h-4 w-4" /> Download CSV Template
        </Button>

        <div className="space-y-2 text-xs text-gray-500">
          <p>
            Required columns: <code className="rounded bg-gray-100 px-1">name</code>, <code className="rounded bg-gray-100 px-1">brand_slug</code>,{' '}
            <code className="rounded bg-gray-100 px-1">category_slug</code> (or <code className="rounded bg-gray-100 px-1">category_id</code>),{' '}
            <code className="rounded bg-gray-100 px-1">price</code>. Optional: stock, description, images, specifications, return_policy, replacement_policy, status.
          </p>
          <p>
            Images: use publicly accessible image URLs in the images column. Separate multiple URLs with a semicolon (<code className="rounded bg-gray-100 px-1">;</code>). The first image becomes the primary product image, the rest become the gallery.
          </p>
          <p className="break-words [overflow-wrap:anywhere]">
            Specifications: Name:Value pairs separated by <code className="rounded bg-gray-100 px-1">|</code>, e.g.{' '}
            <code className="rounded bg-gray-100 px-1">Material:Stainless Steel|Finish:Matte Black</code>. A JSON object such as{' '}
            <code className="rounded bg-gray-100 px-1">{'{"Material":"Steel"}'}</code> also works.
          </p>
          <p>return_policy and replacement_policy are optional plain text (up to 4,000 characters each); leave them blank if not needed.</p>
          <p>Limit: .csv files up to 5 MB and 2,000 products. Products that already exist for the same brand and name are skipped, never duplicated.</p>
        </div>

        <div>
          <label htmlFor="bulk-import-status" className="text-sm font-medium text-gray-800">Import products as</label>
          <select
            id="bulk-import-status"
            className="mt-1 flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:opacity-50"
            value={status}
            onChange={(event) => setStatus(event.target.value === 'live' ? 'live' : 'draft')}
            disabled={phase === 'importing'}
          >
            <option value="draft">Draft</option>
            <option value="live">Live</option>
          </select>
          <ul className="mt-1.5 space-y-0.5 text-xs text-gray-500">
            <li><span className="font-medium text-gray-700">Draft</span> – saved but hidden from the storefront until you switch it to Live.</li>
            <li><span className="font-medium text-gray-700">Live</span> – visible to customers as soon as the import finishes.</li>
          </ul>
        </div>

        <label className={`flex h-24 w-full items-center justify-center rounded-xl border-2 border-dashed border-gray-300 transition-colors ${isBusy ? 'cursor-not-allowed opacity-60' : 'cursor-pointer hover:bg-gray-50'}`}>
          <div className="flex flex-col items-center px-3 text-center">
            {phase === 'reading' ? <Loader2 className="mb-2 h-6 w-6 animate-spin text-primary" /> : <Upload className="mb-2 h-6 w-6 text-gray-400" />}
            <span className="text-sm font-medium text-gray-600">{phase === 'reading' ? 'Checking file...' : file ? 'Choose a different CSV file' : 'Select CSV File'}</span>
          </div>
          <input type="file" accept=".csv,text/csv" className="hidden" onChange={handleFileChange} disabled={isBusy} />
        </label>

        {loadError && (
          <p className="rounded-lg bg-red-50 px-3 py-2 text-xs text-red-700 [overflow-wrap:anywhere]">{loadError}</p>
        )}

        {validation && file && phase !== 'done' && (
          <div className="space-y-3">
            <div className="rounded-lg bg-slate-50 px-3 py-2 text-xs text-gray-600">
              <p className="font-medium text-gray-800 [overflow-wrap:anywhere]">{file.name}</p>
              {validation.fileErrors.length ? null : (
                <p className="mt-0.5">
                  {validation.totalRows} product row{validation.totalRows === 1 ? '' : 's'} ·{' '}
                  <span className="text-green-700">{validation.valid.length} ready</span> ·{' '}
                  <span className="text-red-600">{validation.invalidRows} with errors</span> ·{' '}
                  <span className="text-amber-700">{warningCount} warning{warningCount === 1 ? '' : 's'}</span>
                </p>
              )}
            </div>

            {validation.fileErrors.length > 0 && (
              <ul className="space-y-1 rounded-lg bg-red-50 px-3 py-2 text-xs text-red-700">
                {validation.fileErrors.map((message) => <li key={message} className="[overflow-wrap:anywhere]">{message}</li>)}
              </ul>
            )}

            <MessageList messages={validation.fileErrors.length ? [] : validation.messages} />

            {phase === 'importing' ? (
              <div className="space-y-1.5">
                <Progress value={progress.total ? (progress.done / progress.total) * 100 : 0} className="h-2" />
                <p className="flex items-center text-xs text-gray-600">
                  <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" /> Importing... {progress.done} of {progress.total}
                </p>
              </div>
            ) : (
              <div className="flex flex-col gap-2 sm:flex-row">
                <Button type="button" className="w-full rounded-full sm:flex-1" onClick={handleImport} disabled={!readyCount || isBusy}>
                  Import {readyCount} product{readyCount === 1 ? '' : 's'} as {statusLabel}
                </Button>
                <Button type="button" variant="outline" className="w-full rounded-full sm:w-auto" onClick={clearSelection} disabled={isBusy}>
                  Cancel
                </Button>
              </div>
            )}
            {!readyCount && !validation.fileErrors.length && (
              <p className="text-xs text-gray-500">Nothing can be imported yet. Fix the errors above and choose the file again.</p>
            )}
          </div>
        )}

        {report && phase === 'done' && (
          <div className="space-y-3">
            <div className="flex items-start gap-2 rounded-lg bg-green-50 px-3 py-2 text-sm text-green-900">
              <CheckCircle2 className="mt-0.5 h-4 w-4 shrink-0 text-green-600" />
              <p>
                <span className="font-semibold">Import Complete</span> - Successfully imported: {report.imported}, Failed: {report.failed}, Warnings: {report.warnings}
              </p>
            </div>
            <MessageList messages={report.rows} />
            {report.rows.length > 0 && (
              <Button type="button" variant="outline" className="w-full" onClick={() => downloadCsv('katta-import-report.csv', buildReportCsv(report))}>
                <Download className="mr-2 h-4 w-4" /> Download report
              </Button>
            )}
          </div>
        )}
      </CardContent>
    </Card>
  );
};

export default BulkProductUpload;
