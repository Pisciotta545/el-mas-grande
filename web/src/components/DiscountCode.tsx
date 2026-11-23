"use client";

import { useEffect, useState } from "react";
import { createBrowserDb } from "@/lib/supabase/browser";
import { CopyCode } from "./CopyCode";
import { Locked } from "./Locked";
import { useSession } from "./Session";

// Una sola consulta de códigos por usuario, aunque la página tenga muchos casilleros.
let cache: { userId: string; codes: Promise<Map<number, string>> } | null = null;

function loadCodes(userId: string) {
  if (cache?.userId !== userId) {
    const codes = Promise.resolve(createBrowserDb().from("discount_codes").select("discount_id, code")).then(
      ({ data }) => new Map((data ?? []).map((row) => [row.discount_id as number, row.code as string])),
    );
    cache = { userId, codes };
  }
  return cache.codes;
}

export function DiscountCode({ id }: { id: number }) {
  const { user, ready } = useSession();
  const [code, setCode] = useState<string | null | undefined>(undefined);

  useEffect(() => {
    if (!user) return;
    let alive = true;
    loadCodes(user.id).then((codes) => alive && setCode(codes.get(id) ?? null));
    return () => {
      alive = false;
    };
  }, [user, id]);

  if (!ready || (user && code === undefined)) return <span className="locked">Cargando código…</span>;
  if (!user) return <Locked next="/descuentos">Ingresá para ver el código</Locked>;
  return code ? <CopyCode code={code} /> : <span className="closed">Código no disponible</span>;
}
