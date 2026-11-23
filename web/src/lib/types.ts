export type Competition = {
  id: string;
  name: string;
  season: string;
  has_table: boolean;
  table_label: string | null;
  sort_order: number;
};

export type Team = {
  id: string;
  name: string;
  short_name: string;
  nickname: string | null;
  city: string;
  country: string;
  founded: number | null;
  stadium: string | null;
  is_river: boolean;
};

export type Match = {
  id: number;
  competition_id: string;
  stage: string;
  kickoff: string;
  time_confirmed: boolean;
  venue: string | null;
  home_goals: number | null;
  away_goals: number | null;
  status: "scheduled" | "finished" | "postponed";
  home: Pick<Team, "id" | "name" | "short_name" | "is_river">;
  away: Pick<Team, "id" | "name" | "short_name" | "is_river">;
};

export type StandingRow = {
  competition_id: string;
  position: number;
  played: number;
  won: number;
  drawn: number;
  lost: number;
  goals_for: number;
  goals_against: number;
  points: number;
  team: Pick<Team, "id" | "name" | "short_name" | "is_river">;
};

export type QA = { q: string; a: string };

export type Interview = {
  id: number;
  slug: string;
  title: string;
  dek: string;
  interviewee: string;
  interviewee_role: string;
  author: string;
  published_at: string;
  featured: boolean;
  is_sample: boolean;
  body: QA[];
};

export type Discount = {
  id: number;
  merchant: string;
  category: string;
  title: string;
  description: string;
  valid_until: string;
};

export type Raffle = {
  id: number;
  title: string;
  description: string;
  prize_count: number;
  closes_at: string;
  match: Match | null;
};

export type RankingRow = {
  user_id: string;
  username: string;
  points: number;
  exact_hits: number;
  played: number;
};
