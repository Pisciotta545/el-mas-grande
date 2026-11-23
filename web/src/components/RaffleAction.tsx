"use client";

import { useEffect, useState } from "react";
import { Check, Ticket } from "lucide-react";
import { createBrowserDb } from "@/lib/supabase/browser";
import { Locked } from "./Locked";
import { useSession } from "./Session";

export function RaffleAction({ raffleId, closesAt }: { raffleId: number; closesAt: string }) {
  const { user, ready } = useSession();
  const [joined, setJoined] = useState<boolean | null>(null);
  const [open, setOpen] = useState<boolean | null>(null);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // El sitio se genera una vez: si el sorteo sigue abierto se decide con la hora de quien lo mira.
  useEffect(() => setOpen(new Date(closesAt).getTime() > Date.now()), [closesAt]);

  useEffect(() => {
    if (!user) return;
    createBrowserDb()
      .from("raffle_entries")
      .select("raffle_id")
      .eq("raffle_id", raffleId)
      .eq("user_id", user.id)
      .then(({ data }) => setJoined((data ?? []).length > 0));
  }, [user, raffleId]);

  async function toggle(join: boolean) {
    if (!user) return;
    setPending(true);
    setError(null);
    const db = createBrowserDb();
    const { error } = join
      ? await db.from("raffle_entries").insert({ raffle_id: raffleId, user_id: user.id })
      : await db.from("raffle_entries").delete().eq("raffle_id", raffleId).eq("user_id", user.id);
    setPending(false);
    if (error) return setError("No se pudo: el sorteo ya cerró.");
    setJoined(join);
  }

  if (!ready || open === null || (user && joined === null)) return <span className="locked">Cargando…</span>;
  if (!open) return <span className="closed">{joined ? "Participaste. Sorteo cerrado." : "Sorteo cerrado"}</span>;
  if (!user) return <Locked next="/sorteos">Ingresá para participar</Locked>;

  return (
    <div style={{ display: "grid", gap: 8, justifyItems: "end" }}>
      {joined ? (
        <>
          <span className="stamp">
            <Check aria-hidden strokeWidth={3} />
            Estás participando
          </span>
          <button type="button" className="btn" style={{ width: "100%" }} disabled={pending} onClick={() => toggle(false)}>
            Bajarme del sorteo
          </button>
        </>
      ) : (
        <button
          type="button"
          className="btn btn--red"
          style={{ width: "100%" }}
          disabled={pending}
          onClick={() => toggle(true)}
        >
          <Ticket aria-hidden />
          Participar
        </button>
      )}
      {error && (
        <span className="form-msg form-msg--error" role="alert">
          {error}
        </span>
      )}
    </div>
  );
}
