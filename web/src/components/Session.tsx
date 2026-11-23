"use client";

import { createContext, useContext, useEffect, useState, type ReactNode } from "react";
import type { Session } from "@supabase/supabase-js";
import { createBrowserDb } from "@/lib/supabase/browser";

export type CurrentUser = { id: string; username: string };
type SessionState = { user: CurrentUser | null; ready: boolean };

const SessionContext = createContext<SessionState>({ user: null, ready: false });

// El sitio es estático: la sesión vive en el navegador y se lee acá una sola vez para todas las secciones.
export function SessionProvider({ children }: { children: ReactNode }) {
  const [state, setState] = useState<SessionState>({ user: null, ready: false });

  useEffect(() => {
    const db = createBrowserDb();

    async function load(session: Session | null) {
      if (!session) return setState({ user: null, ready: true });
      const { data } = await db.from("profiles").select("username").eq("id", session.user.id).maybeSingle();
      setState({
        user: { id: session.user.id, username: data?.username ?? session.user.email?.split("@")[0] ?? "hincha" },
        ready: true,
      });
    }

    const { data } = db.auth.onAuthStateChange((_event, session) => {
      // Supabase pide no esperar otras consultas dentro de este callback.
      setTimeout(() => load(session), 0);
    });
    return () => data.subscription.unsubscribe();
  }, []);

  return <SessionContext value={state}>{children}</SessionContext>;
}

export function useSession() {
  return useContext(SessionContext);
}
