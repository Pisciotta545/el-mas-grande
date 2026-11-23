-- Nombres de hincha únicos sin distinguir mayúsculas, y el registro nunca falla por un nombre repetido.

alter table public.profiles drop constraint profiles_username_key;
create unique index profiles_username_lower_key on public.profiles (lower(username));

-- La web la consulta antes de crear la cuenta para avisar si el nombre está tomado.
create or replace function public.username_available(p_username text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select not exists (
    select 1 from public.profiles where lower(username) = lower(trim(p_username))
  );
$$;

grant execute on function public.username_available(text) to anon, authenticated;

-- Si dos personas eligen el mismo nombre a la vez, el segundo recibe un sufijo en vez de un error.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  wanted text := coalesce(
    nullif(trim(new.raw_user_meta_data ->> 'username'), ''),
    'hincha_' || substr(new.id::text, 1, 8)
  );
  candidate text := left(wanted, 24);
  n int := 1;
begin
  while exists (select 1 from public.profiles where lower(username) = lower(candidate)) loop
    n := n + 1;
    candidate := left(wanted, 24 - length(n::text) - 1) || '_' || n;
  end loop;

  insert into public.profiles (id, username) values (new.id, candidate);
  return new;
end;
$$;
