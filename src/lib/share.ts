export async function shareProduct(name: string, url: string): Promise<'shared' | 'copied'> {
  if (typeof navigator !== 'undefined' && navigator.share) {
    try {
      await navigator.share({ title: name, text: name, url });
      return 'shared';
    } catch {
      // User cancelled the share sheet (or it failed) — nothing left to do.
      return 'shared';
    }
  }
  try {
    await navigator.clipboard.writeText(url);
  } catch {
    // Best effort: clipboard may be blocked; never crash the UI.
  }
  return 'copied';
}
