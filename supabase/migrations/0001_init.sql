-- El más grande · esquema inicial
-- Contenido público (entrevistas, partidos, tablas, equipos) lo lee cualquiera.
-- Lo que exige cuenta (prode, sorteos, códigos de descuento) queda protegido por RLS.

-- Perfiles ---------------------------------------------------------------

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username text not null unique check (char_length(username) between 3 and 24),
  created_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, username)
  values (
    new.id,
    coalesce(
      nullif(new.raw_user_meta_data ->> 'username', ''),
      'hincha_' || substr(new.id::text, 1, 8)
    )
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Fútbol -----------------------------------------------------------------

create table public.competitions (
  id text primary key,                 -- 'lpf', 'copa-argentina', 'libertadores'
  name text not null,
  season text not null,
  has_table boolean not null default true,
  table_label text,                    -- 'Zona B', 'Grupo C'
  sort_order int not null default 0
);

create table public.teams (
  id text primary key,                 -- slug
  name text not null,
  short_name text not null,
  nickname text,
  city text not null,
  country text not null default 'Argentina',
  founded int,
  stadium text,
  is_river boolean not null default false
);

create table public.matches (
  id bigint generated always as identity primary key,
  competition_id text not null references public.competitions (id),
  stage text not null,                 -- 'Fecha 15', 'Semifinal', 'Grupo C · Fecha 1'
  home_team_id text not null references public.teams (id),
  away_team_id text not null references public.teams (id),
  kickoff timestamptz not null,
  time_confirmed boolean not null default true,
  venue text,
  home_goals int,
  away_goals int,
  status text not null default 'scheduled' check (status in ('scheduled', 'finished', 'postponed')),
  is_sample boolean not null default true
);

create index matches_kickoff_idx on public.matches (kickoff);

create table public.standings (
  competition_id text not null references public.competitions (id),
  team_id text not null references public.teams (id),
  position int not null,
  played int not null default 0,
  won int not null default 0,
  drawn int not null default 0,
  lost int not null default 0,
  goals_for int not null default 0,
  goals_against int not null default 0,
  points int not null default 0,
  is_sample boolean not null default true,
  primary key (competition_id, team_id)
);

-- Contenido --------------------------------------------------------------

create table public.interviews (
  id bigint generated always as identity primary key,
  slug text not null unique,
  title text not null,
  dek text not null,                   -- bajada
  interviewee text not null,
  interviewee_role text not null,
  author text not null,
  published_at timestamptz not null default now(),
  featured boolean not null default false,
  body jsonb not null,                 -- [{ "q": "...", "a": "..." }]
  is_sample boolean not null default true
);

create table public.discounts (
  id bigint generated always as identity primary key,
  merchant text not null,
  category text not null,
  title text not null,
  description text not null,
  valid_until date not null,
  is_sample boolean not null default true
);

-- Los códigos van aparte para que solo los vea quien inició sesión.
create table public.discount_codes (
  discount_id bigint primary key references public.discounts (id) on delete cascade,
  code text not null
);

create table public.raffles (
  id bigint generated always as identity primary key,
  match_id bigint references public.matches (id),
  title text not null,
  description text not null,
  prize_count int not null default 1,
  closes_at timestamptz not null,
  is_sample boolean not null default true
);

create table public.raffle_entries (
  raffle_id bigint not null references public.raffles (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (raffle_id, user_id)
);

-- Prode ------------------------------------------------------------------

create table public.predictions (
  user_id uuid not null references auth.users (id) on delete cascade,
  match_id bigint not null references public.matches (id) on delete cascade,
  home_goals int not null check (home_goals between 0 and 20),
  away_goals int not null check (away_goals between 0 and 20),
  updated_at timestamptz not null default now(),
  primary key (user_id, match_id)
);

-- 3 puntos por resultado exacto, 1 por acertar ganador o empate.
create or replace function public.prediction_points(
  p_home int, p_away int, r_home int, r_away int
) returns int
language sql
immutable
as $$
  select case
    when r_home is null or r_away is null then 0
    when p_home = r_home and p_away = r_away then 3
    when sign(p_home - p_away) = sign(r_home - r_away) then 1
    else 0
  end;
$$;

create view public.prode_ranking
with (security_invoker = true)
as
select
  pr.id as user_id,
  pr.username,
  coalesce(sum(public.prediction_points(p.home_goals, p.away_goals, m.home_goals, m.away_goals)), 0)::int as points,
  count(*) filter (where m.home_goals = p.home_goals and m.away_goals = p.away_goals)::int as exact_hits,
  count(m.id)::int as played
from public.profiles pr
join public.predictions p on p.user_id = pr.id
join public.matches m on m.id = p.match_id and m.status = 'finished'
group by pr.id, pr.username;

-- RLS --------------------------------------------------------------------

alter table public.profiles enable row level security;
alter table public.competitions enable row level security;
alter table public.teams enable row level security;
alter table public.matches enable row level security;
alter table public.standings enable row level security;
alter table public.interviews enable row level security;
alter table public.discounts enable row level security;
alter table public.discount_codes enable row level security;
alter table public.raffles enable row level security;
alter table public.raffle_entries enable row level security;
alter table public.predictions enable row level security;

create policy "perfiles visibles" on public.profiles for select using (true);
create policy "editar mi perfil" on public.profiles for update
  using ((select auth.uid()) = id) with check ((select auth.uid()) = id);

create policy "lectura pública" on public.competitions for select using (true);
create policy "lectura pública" on public.teams for select using (true);
create policy "lectura pública" on public.matches for select using (true);
create policy "lectura pública" on public.standings for select using (true);
create policy "lectura pública" on public.interviews for select using (true);
create policy "lectura pública" on public.discounts for select using (true);
create policy "lectura pública" on public.raffles for select using (true);

create policy "códigos para socios" on public.discount_codes for select
  to authenticated using (true);

create policy "ver mis participaciones" on public.raffle_entries for select
  to authenticated using ((select auth.uid()) = user_id);
create policy "anotarme mientras está abierto" on public.raffle_entries for insert
  to authenticated with check (
    (select auth.uid()) = user_id
    and exists (select 1 from public.raffles r where r.id = raffle_id and r.closes_at > now())
  );
create policy "bajarme mientras está abierto" on public.raffle_entries for delete
  to authenticated using (
    (select auth.uid()) = user_id
    and exists (select 1 from public.raffles r where r.id = raffle_id and r.closes_at > now())
  );

-- Los pronósticos propios se ven siempre; los ajenos, recién cuando arrancó el partido.
create policy "ver pronósticos" on public.predictions for select using (
  (select auth.uid()) = user_id
  or exists (select 1 from public.matches m where m.id = match_id and m.kickoff <= now())
);
create policy "cargar antes del partido" on public.predictions for insert
  to authenticated with check (
    (select auth.uid()) = user_id
    and exists (select 1 from public.matches m where m.id = match_id and m.kickoff > now() and m.status = 'scheduled')
  );
create policy "cambiar antes del partido" on public.predictions for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check (
    (select auth.uid()) = user_id
    and exists (select 1 from public.matches m where m.id = match_id and m.kickoff > now() and m.status = 'scheduled')
  );

-- Permisos de la Data API ----------------------------------------------------

grant usage on schema public to anon, authenticated;
grant select on
  public.profiles, public.competitions, public.teams, public.matches, public.standings,
  public.interviews, public.discounts, public.raffles, public.prode_ranking
  to anon, authenticated;
grant select on public.discount_codes to authenticated;
grant select, insert, delete on public.raffle_entries to authenticated;
grant select on public.predictions to anon;
grant select, insert, update on public.predictions to authenticated;
grant update (username) on public.profiles to authenticated;
grant execute on function public.prediction_points(int, int, int, int) to anon, authenticated;
