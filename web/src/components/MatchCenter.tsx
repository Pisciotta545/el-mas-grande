"use client";

import { useDeferredValue, useId, useMemo, useState } from "react";
import { Check, Search } from "lucide-react";
import type { Competition, Match, StandingRow } from "@/lib/types";
import { MatchRow } from "./MatchRow";

const fold = (s: string) =>
  s
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase();

type Props = {
  matches: Match[];
  standings: StandingRow[];
  competitions: Competition[];
};

export function MatchCenter({ matches, standings, competitions }: Props) {
  const [query, setQuery] = useState("");
  const [comp, setComp] = useState<string>("all");
  const [showPlayed, setShowPlayed] = useState(false);
  const deferredQuery = useDeferredValue(query);
  const searchId = useId();

  const byId = useMemo(() => new Map(competitions.map((c) => [c.id, c])), [competitions]);

  const visible = useMemo(() => {
    const q = fold(deferredQuery.trim());
    const list = matches.filter((m) => {
      if (!showPlayed && m.status === "finished") return false;
      if (comp !== "all" && m.competition_id !== comp) return false;
      if (!q) return true;
      const haystack = fold(
        [m.home.name, m.away.name, m.stage, m.venue ?? "", byId.get(m.competition_id)?.name ?? ""].join(" "),
      );
      return haystack.includes(q);
    });
    // Jugados primero (los más recientes arriba de los próximos), después los próximos en orden.
    return showPlayed
      ? [...list.filter((m) => m.status === "finished").reverse(), ...list.filter((m) => m.status !== "finished")]
      : list;
  }, [matches, comp, showPlayed, deferredQuery, byId]);

  const tableComp =
    comp === "all" ? competitions.find((c) => c.has_table) : competitions.find((c) => c.id === comp);
  const table = tableComp ? standings.filter((s) => s.competition_id === tableComp.id) : [];

  return (
    <div className="center">
      <div>
        <div className="controls">
          <div className="search">
            <label htmlFor={searchId} className="visually-hidden">
              Buscar partidos
            </label>
            <Search aria-hidden />
            <input
              id={searchId}
              type="search"
              placeholder="Buscar por rival, estadio o fase"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              autoComplete="off"
            />
          </div>

          <fieldset className="filters">
            <legend className="visually-hidden">Filtrar por copa</legend>
            {[{ id: "all", name: "Todas" }, ...competitions].map((c) => (
              <label key={c.id} className="filter">
                <input
                  type="radio"
                  name="comp"
                  value={c.id}
                  checked={comp === c.id}
                  onChange={() => setComp(c.id)}
                />
                <span className={comp === c.id ? "box box--on" : "box"} aria-hidden>
                  {comp === c.id && <Check strokeWidth={3} />}
                </span>
                {c.name}
              </label>
            ))}
          </fieldset>

          <label className="toggle">
            <input type="checkbox" checked={showPlayed} onChange={(e) => setShowPlayed(e.target.checked)} />
            Mostrar también los partidos jugados
          </label>
        </div>

        <ul className="rows" aria-live="polite">
          {visible.map((m) => (
            <MatchRow key={m.id} match={m} competition={byId.get(m.competition_id)} />
          ))}
          {visible.length === 0 && (
            <li className="empty">
              <strong>No hay partidos con ese filtro.</strong>
              {query ? "Probá con otro nombre o borrá la búsqueda." : "Probá con otra copa."}
            </li>
          )}
        </ul>
      </div>

      <div className="table-wrap">
        {tableComp && tableComp.has_table ? (
          <table className="standings">
            <caption>
              {tableComp.name} {tableComp.season} <span>· {tableComp.table_label}</span>
            </caption>
            <thead>
              <tr>
                <th scope="col">#</th>
                <th scope="col">Equipo</th>
                <th scope="col" title="Partidos jugados">
                  PJ
                </th>
                <th scope="col" title="Ganados">
                  G
                </th>
                <th scope="col" title="Empatados">
                  E
                </th>
                <th scope="col" title="Perdidos">
                  P
                </th>
                <th scope="col" title="Diferencia de gol">
                  DG
                </th>
                <th scope="col" title="Puntos">
                  Pts
                </th>
              </tr>
            </thead>
            <tbody>
              {table.map((row) => {
                const dg = row.goals_for - row.goals_against;
                return (
                  <tr key={row.team.id} className={row.team.is_river ? "river" : undefined}>
                    <td className="pos">{row.position}</td>
                    <td className="team">{row.team.name}</td>
                    <td>{row.played}</td>
                    <td>{row.won}</td>
                    <td>{row.drawn}</td>
                    <td>{row.lost}</td>
                    <td>{dg > 0 ? `+${dg}` : dg}</td>
                    <td className="pts">{row.points}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        ) : (
          <div className="empty" style={{ borderTop: "1px solid var(--rule)" }}>
            <strong>{tableComp?.name} no tiene tabla.</strong>
            Se juega por eliminación directa: el que gana pasa.
          </div>
        )}
        {tableComp?.has_table && table.every((r) => r.played === 0) && (
          <p className="note">El grupo todavía no empezó: todos arrancan en cero.</p>
        )}
      </div>
    </div>
  );
}
