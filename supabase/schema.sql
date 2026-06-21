-- Кабинет интенсива «AI-команда» — схема БД + RLS.
-- Применять в Supabase → SQL Editor (вставить целиком, Run).
-- Идемпотентно: можно прогонять повторно.

-- ============ ТАБЛИЦЫ ============

-- профиль ученика (расширяет auth.users)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  paid boolean not null default false,
  paid_at timestamptz,
  is_admin boolean not null default false,
  created_at timestamptz not null default now()
);

-- email-ы, оплатившие ДО регистрации (webhook кладёт сюда, триггер применяет при регистрации)
create table if not exists public.paid_emails (
  email text primary key,
  paid_at timestamptz not null default now()
);

-- уроки (контент)
create table if not exists public.lessons (
  id int primary key,
  slug text unique not null,
  title text not null,
  day int not null default 0,
  body_html text not null default '',
  sort int not null default 0
);

-- прогресс: какой урок ученик отметил пройденным
create table if not exists public.progress (
  user_id uuid references auth.users(id) on delete cascade,
  lesson_id int references public.lessons(id) on delete cascade,
  done boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (user_id, lesson_id)
);

-- домашки
create table if not exists public.homework (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users(id) on delete cascade,
  lesson_id int references public.lessons(id),
  file_path text not null,
  note text,
  status text not null default 'submitted',
  created_at timestamptz not null default now()
);

-- ============ RLS ============

alter table public.profiles enable row level security;
alter table public.lessons  enable row level security;
alter table public.progress enable row level security;
alter table public.homework enable row level security;

-- профиль: ученик видит только свой; админ видит все
drop policy if exists "own profile" on public.profiles;
create policy "own profile" on public.profiles
  for select using (
    auth.uid() = id
    or exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin)
  );

-- уроки: видны ТОЛЬКО оплаченным аутентифицированным
drop policy if exists "lessons for paid" on public.lessons;
create policy "lessons for paid" on public.lessons
  for select using (
    exists (select 1 from public.profiles p
            where p.id = auth.uid() and p.paid = true)
  );

-- прогресс: ученик читает/пишет только свой
drop policy if exists "own progress" on public.progress;
create policy "own progress" on public.progress
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- домашки: ученик создаёт/видит свои; админ видит все
drop policy if exists "own homework" on public.homework;
create policy "own homework" on public.homework
  for all using (
    auth.uid() = user_id
    or exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin)
  ) with check (auth.uid() = user_id);

-- ============ ТРИГГЕР АВТО-ПРОФИЛЯ ============
-- при регистрации создаём профиль; если email уже оплачен — сразу paid=true

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
declare prepaid boolean;
begin
  select true into prepaid from public.paid_emails where email = new.email;
  insert into public.profiles (id, email, paid, paid_at)
    values (new.id, new.email, coalesce(prepaid,false),
            case when prepaid then now() else null end);
  return new;
end; $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
