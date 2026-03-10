alter table public.incidents
  add column if not exists incident_code text,
  add column if not exists incident_type text,
  add column if not exists soc_analyst text;

with numbered as (
  select
    id,
    concat(
      'INC-',
      to_char(incident_at at time zone 'UTC', 'YYYY-MMDD'),
      '-',
      lpad(
        row_number() over (
          partition by date(incident_at at time zone 'UTC')
          order by created_at, id
        )::text,
        2,
        '0'
      )
    ) as generated_code
  from public.incidents
)
update public.incidents t
set incident_code = numbered.generated_code
from numbered
where t.id = numbered.id
  and t.incident_code is null;

update public.incidents
set incident_type = 'Phishing'
where incident_type is null;

update public.incidents
set soc_analyst = 'Unknown Analyst'
where soc_analyst is null;

alter table public.incidents
  alter column incident_code set not null,
  alter column incident_type set not null,
  alter column soc_analyst set not null;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'incidents_incident_code_key'
  ) then
    alter table public.incidents
      add constraint incidents_incident_code_key unique (incident_code);
  end if;
end $$;

drop policy if exists "auth_select_incidents" on public.incidents;
drop policy if exists "auth_insert_incidents" on public.incidents;
drop policy if exists "auth_update_incidents" on public.incidents;
drop policy if exists "auth_delete_incidents" on public.incidents;

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
