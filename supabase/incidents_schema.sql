create extension if not exists "pgcrypto";

create table if not exists public.incidents (
  id uuid primary key default gen_random_uuid(),
  incident_code text not null unique,
  title text not null,
  incident_at timestamptz not null,
  severity text not null check (severity in ('Low', 'Medium', 'High')),
  incident_type text not null,
  soc_analyst text not null,
  description text not null,
  status text not null check (status in ('Open', 'Closed')),
  created_at timestamptz not null default now()
);

alter table public.incidents enable row level security;

drop policy if exists "anon_select_incidents" on public.incidents;
drop policy if exists "anon_insert_incidents" on public.incidents;
drop policy if exists "anon_update_incidents" on public.incidents;
drop policy if exists "anon_delete_incidents" on public.incidents;
drop policy if exists "auth_select_incidents" on public.incidents;
drop policy if exists "auth_insert_incidents" on public.incidents;
drop policy if exists "auth_update_incidents" on public.incidents;
drop policy if exists "auth_delete_incidents" on public.incidents;

create policy "anon_select_incidents"
on public.incidents
for select
to anon
using (true);

create policy "anon_insert_incidents"
on public.incidents
for insert
to anon
with check (true);

create policy "anon_update_incidents"
on public.incidents
for update
to anon
using (true)
with check (true);

create policy "anon_delete_incidents"
on public.incidents
for delete
to anon
using (true);

create policy "auth_select_incidents"
on public.incidents
for select
to authenticated
using (true);

create policy "auth_insert_incidents"
on public.incidents
for insert
to authenticated
with check (true);

create policy "auth_update_incidents"
on public.incidents
for update
to authenticated
using (true)
with check (true);

create policy "auth_delete_incidents"
on public.incidents
for delete
to authenticated
using (true);
