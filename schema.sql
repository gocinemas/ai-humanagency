-- ═══════════════════════════════════════════════════════════════
-- AI Human Agency — Supabase Schema
-- Run once in Supabase → SQL Editor → New Query
-- ═══════════════════════════════════════════════════════════════

create table if not exists ai_basics (
  id         uuid primary key default gen_random_uuid(),
  icon       text, tag text, title text not null,
  body       text, body2 text, plain text,
  search_kw  text, sort_order integer default 0,
  active     boolean default true, created_at timestamptz default now()
);

create table if not exists ai_usecases (
  id         uuid primary key default gen_random_uuid(),
  icon       text, title text not null,
  roles      jsonb default '[]',
  intro      text, examples jsonb default '[]',
  search_kw  text,
  active     boolean default true, created_at timestamptz default now()
);

create table if not exists ai_researchers (
  id         uuid primary key default gen_random_uuid(),
  initials   text, avatar_bg text, avatar_fg text,
  name       text not null, role text, bio text, quote text,
  links      jsonb default '[]',
  search_kw  text, sort_order integer default 0,
  active     boolean default true, created_at timestamptz default now()
);

create table if not exists ai_dummies (
  id         uuid primary key default gen_random_uuid(),
  emoji      text, question text not null, answer text,
  search_kw  text, sort_order integer default 0,
  active     boolean default true, created_at timestamptz default now()
);

create table if not exists ai_jargon (
  id         uuid primary key default gen_random_uuid(),
  term       text not null, full_name text, category text,
  definition text, search_kw text,
  active     boolean default true, created_at timestamptz default now()
);

create table if not exists ai_articles (
  id          uuid primary key default gen_random_uuid(),
  title       text not null, source text, url text,
  description text, tag text, date text, search_kw text,
  active      boolean default true, created_at timestamptz default now()
);

create table if not exists ai_videos (
  id          uuid primary key default gen_random_uuid(),
  video_id    text, title text not null, channel text,
  description text, tag text, duration text, search_kw text,
  active      boolean default true, created_at timestamptz default now()
);

create table if not exists ai_podcasts (
  id          uuid primary key default gen_random_uuid(),
  emoji       text, show_name text, title text not null,
  description text, url text, search_kw text,
  active      boolean default true, created_at timestamptz default now()
);

create table if not exists ai_models (
  id          uuid primary key default gen_random_uuid(),
  name        text not null, company text not null,
  type        text not null, access text not null,
  open_weight boolean default false,
  best_for    text, url text,
  sort_order  integer default 0,
  active      boolean default true, created_at timestamptz default now()
);

-- ── Row Level Security ───────────────────────────────────────────
alter table ai_basics      enable row level security;
alter table ai_usecases    enable row level security;
alter table ai_researchers enable row level security;
alter table ai_dummies     enable row level security;
alter table ai_jargon      enable row level security;
alter table ai_articles    enable row level security;
alter table ai_videos      enable row level security;
alter table ai_podcasts    enable row level security;
alter table ai_models      enable row level security;

-- Personal content site — allow anon full access (read + write for self-seeding)
do $$ declare t text;
begin
  for t in select unnest(array[
    'ai_basics','ai_usecases','ai_researchers','ai_dummies',
    'ai_jargon','ai_articles','ai_videos','ai_podcasts','ai_models'
  ]) loop
    execute format(
      'create policy "anon all on %s" on %s using (true) with check (true)', t, t
    );
  end loop;
end $$;
