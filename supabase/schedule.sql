-- Схема расписания эфиров (добавлено отдельно). Применять в SQL Editor.
create table if not exists public.schedule (
  id int primary key,
  session_number int,
  title text not null,
  description text,
  starts_at timestamptz,
  zoom_url text,
  replay_url text,
  sort int not null default 0
);
alter table public.schedule enable row level security;
drop policy if exists "schedule for paid" on public.schedule;
create policy "schedule for paid" on public.schedule for select using (public.is_paid());
