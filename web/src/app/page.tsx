import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { MatchCenter } from "@/components/MatchCenter";
import { KickoffTime, TeamName } from "@/components/MatchRow";
import { getCompetitions, getInterviews, getMatches, getStandings } from "@/lib/data";
import { StoryList } from "@/components/StoryList";
import { fullDate, shortDay } from "@/lib/format";

export default async function Home() {
  const [interviews, matches, standings, competitions] = await Promise.all([
    getInterviews(),
    getMatches(),
    getStandings(),
    getCompetitions(),
  ]);

  const lead = interviews.find((i) => i.featured) ?? interviews[0];
  const more = interviews.filter((i) => i.id !== lead?.id).slice(0, 3);
  const next = matches.find((m) => m.status === "scheduled");
  const nextComp = competitions.find((c) => c.id === next?.competition_id);
  const [nextWeekday, nextDay, nextMonth] = next ? shortDay(next.kickoff).split(" ") : [];

  return (
    <>
      <div className="wrap">
        <section className="front" aria-label="Portada">
          {lead && (
            <article>
              <h1 className="lead__title heading">
                <Link href={`/entrevistas/${lead.slug}`}>{lead.title}</Link>
              </h1>
              <p className="lead__dek">{lead.dek}</p>
              <p className="byline">
                <span>
                  <strong>{lead.interviewee}</strong>, {lead.interviewee_role}
                </span>
                <span>{fullDate(lead.published_at)}</span>
              </p>
              <div className="lead__actions">
                <Link href={`/entrevistas/${lead.slug}`} className="btn btn--red">
                  Leer la entrevista
                  <ArrowRight aria-hidden />
                </Link>
              </div>
            </article>
          )}

          {next && (
            <aside className="next" aria-labelledby="proximo">
              <h2 id="proximo" className="next__title heading">
                Próximo partido
              </h2>
              <div className="next__line">
                <div className="row__date">
                  <span className="row__num next__num">{nextDay}</span>
                  <span className="row__month">
                    <span>{nextWeekday}</span>
                    <span>{nextMonth}</span>
                  </span>
                </div>
                <div className="next__body">
                  <div className="next__teams heading">
                    <TeamName team={next.home} />
                    <span className="next__vs">contra</span>
                    <TeamName team={next.away} />
                  </div>
                  <div className="next__meta">
                    <KickoffTime match={next} />
                    <span>
                      {nextComp?.name} · {next.stage}
                    </span>
                    <span>{next.venue ?? "Estadio a confirmar"}</span>
                  </div>
                </div>
              </div>
              <div className="next__foot">
                <Link href="/prode" className="btn" style={{ width: "100%" }}>
                  Pronosticar en el prode
                  <ArrowRight aria-hidden />
                </Link>
              </div>
            </aside>
          )}
        </section>

        <section className="section" aria-labelledby="partidos">
          <div className="section__head">
            <h2 id="partidos" className="section__title heading">
              Partidos de River
            </h2>
          </div>
          <MatchCenter matches={matches} standings={standings} competitions={competitions} />
          <p className="note">Fixture, resultados y tablas de prueba hasta conectar los datos oficiales.</p>
        </section>

        {more.length > 0 && (
          <section className="section" aria-labelledby="mas-entrevistas">
            <div className="section__head">
              <h2 id="mas-entrevistas" className="section__title heading">
                Más entrevistas
              </h2>
              <Link href="/entrevistas" className="section__more">
                Ver todas
              </Link>
            </div>
            <StoryList items={more} />
          </section>
        )}
      </div>
    </>
  );
}
