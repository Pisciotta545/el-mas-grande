import type { Competition, Match } from "@/lib/types";
import { hour, shortDay } from "@/lib/format";

export function TeamName({ team }: { team: Match["home"] }) {
  return <span className={team.is_river ? "is-river" : undefined}>{team.name}</span>;
}

export function KickoffTime({ match }: { match: Match }) {
  return match.time_confirmed ? (
    <span className="kick">{hour(match.kickoff)} h</span>
  ) : (
    <span className="tbc">Hora a confirmar</span>
  );
}

export function MatchRow({ match, competition }: { match: Match; competition?: Competition }) {
  const played = match.status === "finished";
  const [weekday, day, month] = shortDay(match.kickoff).split(" ");

  return (
    <li className={played ? "row row--played" : "row"}>
      <div className="row__date">
        <span className="row__num">{day}</span>
        <span className="row__month">
          <span>{weekday}</span>
          <span>{month}</span>
        </span>
      </div>
      <div className="row__match">
        <span className="row__teams">
          <TeamName team={match.home} /> – <TeamName team={match.away} />
        </span>
        <span className="row__meta">
          {competition ? `${competition.name} · ` : ""}
          {match.stage}
          {match.venue ? ` · ${match.venue}` : ""}
        </span>
      </div>
      <div className="row__side">
        {played ? (
          <span className="score" aria-label={`Resultado ${match.home_goals} a ${match.away_goals}`}>
            {match.home_goals}–{match.away_goals}
          </span>
        ) : (
          <KickoffTime match={match} />
        )}
      </div>
    </li>
  );
}
