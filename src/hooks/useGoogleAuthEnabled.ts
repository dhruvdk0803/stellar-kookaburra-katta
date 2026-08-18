import { useEffect, useState } from 'react';
import { SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY } from '@/integrations/supabase/client';

/**
 * Reports whether the Google OAuth provider is actually enabled on this
 * Supabase project.
 *
 * Rendering a "Sign in with Google" button when the provider is turned off in
 * the Supabase dashboard produces a dead button (Supabase answers the OAuth
 * request with "Unsupported provider: provider is not enabled"), so the auth
 * pages ask this first and only offer Google once it really works.
 *
 * `null` while the check is in flight.
 */
export const useGoogleAuthEnabled = () => {
  const [enabled, setEnabled] = useState<boolean | null>(null);

  useEffect(() => {
    let cancelled = false;

    const check = async () => {
      try {
        const res = await fetch(`${SUPABASE_URL}/auth/v1/settings`, {
          headers: { apikey: SUPABASE_PUBLISHABLE_KEY },
        });
        if (!res.ok) throw new Error(`auth settings: ${res.status}`);
        const settings = await res.json();
        if (!cancelled) setEnabled(Boolean(settings?.external?.google));
      } catch (error) {
        console.error('Could not read Supabase auth settings:', error);
        if (!cancelled) setEnabled(false);
      }
    };

    check();
    return () => {
      cancelled = true;
    };
  }, []);

  return enabled;
};
