"use client";

import Link from "next/link";
import { LogOut, UserRound } from "lucide-react";
import { withBase } from "@/lib/base";
import { createBrowserDb } from "@/lib/supabase/browser";
import { useSession } from "./Session";

export function UserSlot() {
  const { user } = useSession();

  if (!user) {
    return (
      <Link href="/ingresar" className="btn btn--red">
        <UserRound aria-hidden />
        Ingresar
      </Link>
    );
  }

  async function signOut() {
    await createBrowserDb().auth.signOut();
    window.location.assign(withBase("/"));
  }

  return (
    <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
      <Link href="/prode" className="btn" title="Mi prode">
        <UserRound aria-hidden />
        {user.username}
      </Link>
      <button type="button" className="btn" aria-label="Cerrar sesión" title="Cerrar sesión" onClick={signOut}>
        <LogOut aria-hidden />
      </button>
    </div>
  );
}
