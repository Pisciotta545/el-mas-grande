"use client";

import { useState } from "react";
import { Check } from "lucide-react";
import { createBrowserDb } from "@/lib/supabase/browser";
import type { Match } from "@/lib/types";

export type Pick = { home: number; away: number };
type FormState = { ok: boolean; message: string } | null;

type Props = {
  match: Match;
  userId: string | null;
  saved: Pick | null;
  onSaved?: (pick: Pick) => void;
};

function goals(value: FormDataEntryValue | null) {
  const n = Number(value);
  return value !== "" && Number.isInteger(n) && n >= 0 && n <= 20 ? n : null;
}

export function PredictionForm({ match, userId, saved, onSaved }: Props) {
  const [state, setState] = useState<FormState>(null);
  const [pending, setPending] = useState(false);
  const disabled = !userId;
  const label = `${match.home.name} contra ${match.away.name}`;

  async function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    if (!userId) return;
    const form = new FormData(e.currentTarget);
    const home = goals(form.get("home"));
    const away = goals(form.get("away"));
    if (home === null || away === null) {
      return setState({ ok: false, message: "Completá los dos casilleros con un número de 0 a 20." });
    }

    setPending(true);
    // Las reglas de la base solo aceptan pronósticos propios y antes de que empiece el partido.
    const { error } = await createBrowserDb().from("predictions").upsert({
      user_id: userId,
      match_id: match.id,
      home_goals: home,
      away_goals: away,
      updated_at: new Date().toISOString(),
    });
    setPending(false);

    if (error) return setState({ ok: false, message: "No se pudo guardar: el partido ya empezó o se cerró." });
    setState({ ok: true, message: `Guardado: ${home} a ${away}.` });
    onSaved?.({ home, away });
  }

  return (
    <form onSubmit={onSubmit} aria-label={`Pronóstico para ${label}`} style={{ display: "grid", gap: 12 }}>
      <div className="pick">
        <span className={match.home.is_river ? "pick__team is-river" : "pick__team"}>{match.home.name}</span>
        <span className="pick__boxes">
          <input
            key={`h-${saved?.home ?? ""}`}
            className="goal"
            name="home"
            type="number"
            inputMode="numeric"
            min={0}
            max={20}
            required
            defaultValue={saved?.home ?? ""}
            disabled={disabled}
            aria-label={`Goles de ${match.home.name}`}
          />
          <input
            key={`a-${saved?.away ?? ""}`}
            className="goal"
            name="away"
            type="number"
            inputMode="numeric"
            min={0}
            max={20}
            required
            defaultValue={saved?.away ?? ""}
            disabled={disabled}
            aria-label={`Goles de ${match.away.name}`}
          />
        </span>
        <span className={match.away.is_river ? "pick__team is-river" : "pick__team"}>{match.away.name}</span>
      </div>

      {(state || saved || !disabled) && (
        <div className="ticket__foot">
          <span aria-live="polite">
            {state ? (
              <span className={state.ok ? "form-msg" : "form-msg form-msg--error"}>{state.message}</span>
            ) : saved ? (
              <span className="stamp">
                <Check aria-hidden strokeWidth={3} />
                Pronóstico cargado
              </span>
            ) : null}
          </span>
          {!disabled && (
            <button type="submit" className={saved ? "btn" : "btn btn--red"} disabled={pending}>
              {pending ? "Guardando…" : saved ? "Cambiar" : "Guardar"}
            </button>
          )}
        </div>
      )}
    </form>
  );
}
