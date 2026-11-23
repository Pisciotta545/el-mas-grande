"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Lock } from "lucide-react";
import { shortDay } from "@/lib/format";
import { createBrowserDb } from "@/lib/supabase/browser";
import type { Competition, Match, RankingRow } from "@/lib/types";
import { KickoffTime } from "./MatchRow";
import { PredictionForm, type Pick } from "./PredictionForm";
import { useSession } from "./Session";

type Picks = Map<number, Pick>;

function usePicks(userId: string | null) {
  const [picks, setPicks] = useState<Picks | null>(null);

  useEffect(() => {
    if (!userId) return;
    createBrowserDb()
      .from("predictions")
      .select("match_id, home_goals, away_goals")
      .eq("user_id", userId)
      .then(({ data }) =>
        setPicks(new Map((data ?? []).map((p) => [p.match_id as number, { home: p.home_goals, away: p.away_goals }]))),
      );
  }, [userId]);

  const save = (matchId: number, pick: Pick) => setPicks((prev) => new Map(prev ?? []).set(matchId, pick));
  return { picks: userId ? picks : null, save };
}

export function ProdeBoard({
  upcoming,
  finished,
  competitions,
}: {
  upcoming: Match[];
  finished: Match[];
  competitions: Competition[];
}) {
  const { user, ready } = useSession();
  const { picks, save } = usePicks(user?.id ?? null);
  const compName = (id: string) => competitions.find((c) => c.id === id)?.name ?? "";
  const loading = !ready || (user && !picks);

  return (
    <>
      {ready && !user && (
        <div className="gate">
          <p className="gate__title">Ingresá para jugar</p>
          <p>Con tu cuenta guardás los pronósticos y sumás puntos en el ranking.</p>
          <Link href="/ingresar?next=/prode" className="btn btn--red">
            <Lock aria-hidden />
            Ingresar o crear cuenta
          </Link>
        </div>
      )}
      <ul className="rows">
        {upcoming.map((m) => (
          <li key={m.id} className="ticket">
            <div className="ticket__meta">
              <span>
                {compName(m.competition_id)} · {m.stage}
              </span>
              <span>
                {shortDay(m.kickoff)} · <KickoffTime match={m} />
              </span>
            </div>
            <PredictionForm
              match={m}
              userId={loading ? null : (user?.id ?? null)}
              saved={picks?.get(m.id) ?? null}
              onSaved={(pick) => save(m.id, pick)}
            />
          </li>
        ))}
      </ul>

      <div className="section__head" style={{ marginTop: 48 }}>
        <h2 className="section__title heading">Jugados</h2>
      </div>
      <ul className="rows">
        {finished.map((m) => {
          const pick = picks?.get(m.id);
          const [weekday, day, month] = shortDay(m.kickoff).split(" ");
          return (
            <li key={m.id} className="row row--played">
              <div className="row__date">
                <span className="row__num">{day}</span>
                <span className="row__month">
                  <span>{weekday}</span>
                  <span>{month}</span>
                </span>
              </div>
              <div className="row__match">
                <span className="row__teams">
                  {m.home.name} {m.home_goals}–{m.away_goals} {m.away.name}
                </span>
                <span className="row__meta">
                  {pick ? `Tu pronóstico: ${pick.home}–${pick.away}` : picks ? "No pronosticaste" : m.stage}
                </span>
              </div>
              <div className="row__side">{pick ? <span className="score">+{points(pick, m)}</span> : null}</div>
            </li>
          );
        })}
      </ul>
    </>
  );
}

function points(pick: Pick, m: Match) {
  if (m.home_goals === null || m.away_goals === null) return 0;
  if (pick.home === m.home_goals && pick.away === m.away_goals) return 3;
  return Math.sign(pick.home - pick.away) === Math.sign(m.home_goals - m.away_goals) ? 1 : 0;
}

// El ranking viene armado de la publicación y se actualiza al abrir la página.
export function Ranking({ initial }: { initial: RankingRow[] }) {
  const [rows, setRows] = useState(initial);

  useEffect(() => {
    createBrowserDb()
      .from("prode_ranking")
      .select("*")
      .order("points", { ascending: false })
      .order("exact_hits", { ascending: false })
      .limit(20)
      .then(({ data }) => data && setRows(data as RankingRow[]));
  }, []);

  if (rows.length === 0) {
    return (
      <div className="empty">
        <strong>Todavía no hay puntos.</strong>
        El ranking arranca cuando termine el primer partido con pronósticos.
      </div>
    );
  }

  return (
    <table className="standings">
      <thead>
        <tr>
          <th scope="col">#</th>
          <th scope="col">Hincha</th>
          <th scope="col" title="Resultados exactos">
            Exactos
          </th>
          <th scope="col">Pts</th>
        </tr>
      </thead>
      <tbody>
        {rows.map((r, i) => (
          <tr key={r.user_id}>
            <td className="pos">{i + 1}</td>
            <td className="team">{r.username}</td>
            <td>{r.exact_hits}</td>
            <td className="pts">{r.points}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}
