import React, { createContext, useContext, useEffect, useRef, useState } from 'react';
import { Session, User } from '@supabase/supabase-js';
import { supabase } from '@/integrations/supabase/client';

interface Profile {
  id: string;
  name: string;
  phone: string;
  role: 'customer' | 'admin';
}

interface AuthContextType {
  session: Session | null;
  user: User | null;
  profile: Profile | null;
  isLoading: boolean;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType>({
  session: null,
  user: null,
  profile: null,
  isLoading: true,
  signOut: async () => {},
});

export const useAuth = () => useContext(AuthContext);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [session, setSession] = useState<Session | null>(null);
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const activeUserId = useRef<string | null>(null);

  useEffect(() => {
    let receivedAuthEvent = false;
    const applySession = (session: Session | null) => {
      activeUserId.current = session?.user.id || null;
      setSession(session);
      setUser(session?.user ?? null);
      setProfile(null);
      setIsLoading(Boolean(session?.user));
      if (session?.user) void fetchProfile(session.user.id);
    };

    supabase.auth.getSession().then(({ data: { session } }) => {
      if (!receivedAuthEvent) applySession(session);
    }).catch(() => {
      if (!receivedAuthEvent) applySession(null);
    });

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((event, session) => {
      receivedAuthEvent = true;
      
      // INTERCEPT PASSWORD RECOVERY
      if (event === 'PASSWORD_RECOVERY') {
        // When the user clicks the reset link in their email, this event fires.
        // We force a redirect to the reset-password page so they can set a new one.
        window.location.href = '/reset-password';
        return;
      }

      applySession(session);
    });

    return () => subscription.unsubscribe();
  }, []);

  const fetchProfile = async (userId: string) => {
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .single();
      
      if (activeUserId.current === userId && !error && data) {
        setProfile(data as Profile);
      }
    } catch (error) {
      console.error('Error fetching profile:', error);
    } finally {
      if (activeUserId.current === userId) setIsLoading(false);
    }
  };

  const signOut = async () => {
    await supabase.auth.signOut();
  };

  return (
    <AuthContext.Provider value={{ session, user, profile, isLoading, signOut }}>
      {children}
    </AuthContext.Provider>
  );
};
