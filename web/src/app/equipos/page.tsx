import type { Metadata } from "next";
import { KickoffTime } from "@/components/MatchRow";
import { getCompetitions, getMatches, getTeams } from "@/lib/data";
import { shortDay } from "@/lib/format";
import type { Match, Team } from "@/lib/types";

export const metadata: Metadata = { title: "Otros equipos" };

export default async function TeamsPage() {
  const [teams, matches, competitions] = await Promise.all([getTeams(), getMatches(), getCompetitions()]);

  const rivals = teams.filter((t) => !t.is_river);
  const nextAgainst = new Map<string, Match>();
  for (const m of matches) {
    if (m.status !== "scheduled") continue;
    const rival = m.home.is_river ? m.away.id : m.home.id;
    if (!nextAgainst.has(rival)) nextAgainst.set(rival, m);
  }
  const compName = (id: string) => competitions.find((c) => c.id === id)?.name ?? "";

  const local = rivals.filter((t) => t.country === "Argentina");
  const abroad = rivals.filter((t) => t.country !== "Argentina");

  return (
    <div className="wrap">
      <header className="page-head">
        <h1 className="page-head__title display">Otros equipos</h1>
        <p className="page-head__lede">
          Los rivales de River en el torneo local y en las copas: de dónde son, dónde juegan y cuándo nos cruzamos.
        </p>
      </header>

      <section className="section" aria-labelledby="argentina">
        <div className="section__head">
          <h2 id="argentina" className="section__title heading">
            Argentina
          </h2>
        </div>
        <TeamGrid teams={local} nextAgainst={nextAgainst} compName={compName} />
      </section>

      <section className="section" aria-labelledby="exterior">
        <div className="section__head">
          <h2 id="exterior" className="section__title heading">
            Copa Libertadores
          </h2>
        </div>
        <TeamGrid teams={abroad} nextAgainst={nextAgainst} compName={compName} />
      </section>
    </div>
  );
}

function TeamGrid({
  teams,
  nextAgainst,
  compName,
}: {
  teams: Team[];
  nextAgainst: Map<string, Match>;
  compName: (id: string) => string;
}) {
  return (
    <ul className="teams" style={{ listStyle: "none", margin: 0, padding: 0 }}>
      {teams.map((t) => {
        const next = nextAgainst.get(t.id);
        return (
          <li key={t.id} className="team-card">
            <span className="team-card__code">{t.short_name}</span>
            <h3 className="team-card__name">{t.name}</h3>
            <dl>
              {t.nickname && (
                <>
                  <dt>Apodo</dt>
                  <dd>{t.nickname}</dd>
                </>
              )}
              <dt>Ciudad</dt>
              <dd>
                {t.city}
                {t.country !== "Argentina" ? `, ${t.country}` : ""}
              </dd>
              {t.founded && (
                <>
                  <dt>Fundado</dt>
                  <dd className="tnum">{t.founded}</dd>
                </>
              )}
              {t.stadium && (
                <>
                  <dt>Estadio</dt>
                  <dd>{t.stadium}</dd>
                </>
              )}
            </dl>
            {next && (
              <p className="team-card__next">
                Contra River: {shortDay(next.kickoff)} · <KickoffTime match={next} /> · {compName(next.competition_id)}
              </p>
            )}
          </li>
        );
      })}
    </ul>
  );
}
