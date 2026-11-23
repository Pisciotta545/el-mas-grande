import "server-only";
import { publicDb } from "./supabase/public";
import type {
  Competition,
  Discount,
  Interview,
  Match,
  RankingRow,
  Raffle,
  StandingRow,
  Team,
} from "./types";

const TEAM = "id, name, short_name, is_river";
const MATCH = `id, competition_id, stage, kickoff, time_confirmed, venue, home_goals, away_goals, status,
  home:teams!matches_home_team_id_fkey(${TEAM}), away:teams!matches_away_team_id_fkey(${TEAM})`;

function must<T>(result: { data: T | null; error: { message: string } | null }): T {
  if (result.error) throw new Error(result.error.message);
  return result.data as T;
}

export async function getCompetitions(): Promise<Competition[]> {
  return must(await publicDb.from("competitions").select("*").order("sort_order"));
}

export async function getMatches(): Promise<Match[]> {
  return must(await publicDb.from("matches").select(MATCH).order("kickoff")) as unknown as Match[];
}

export async function getStandings(): Promise<StandingRow[]> {
  return must(
    await publicDb
      .from("standings")
      .select(`competition_id, position, played, won, drawn, lost, goals_for, goals_against, points, team:teams(${TEAM})`)
      .order("position"),
  ) as unknown as StandingRow[];
}

export async function getTeams(): Promise<Team[]> {
  return must(await publicDb.from("teams").select("*").order("name"));
}

export async function getInterviews(): Promise<Interview[]> {
  return must(
    await publicDb.from("interviews").select("*").order("published_at", { ascending: false }),
  );
}

export async function getInterview(slug: string): Promise<Interview | null> {
  return must(await publicDb.from("interviews").select("*").eq("slug", slug).maybeSingle());
}

export async function getDiscounts(): Promise<Discount[]> {
  return must(await publicDb.from("discounts").select("*").order("valid_until"));
}

export async function getRaffles(): Promise<Raffle[]> {
  return must(
    await publicDb
      .from("raffles")
      .select(`id, title, description, prize_count, closes_at, match:matches(${MATCH})`)
      .order("closes_at", { ascending: false }),
  ) as unknown as Raffle[];
}

export async function getRanking(): Promise<RankingRow[]> {
  return must(
    await publicDb
      .from("prode_ranking")
      .select("*")
      .order("points", { ascending: false })
      .order("exact_hits", { ascending: false })
      .limit(20),
  );
}
