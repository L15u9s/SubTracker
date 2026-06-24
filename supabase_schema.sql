-- ─────────────────────────────────────────────────────────────
-- SubTrack GH — Supabase database schema
-- Run this in: Supabase Dashboard → SQL Editor → New query
-- ─────────────────────────────────────────────────────────────

-- Enable UUID generation
create extension if not exists "pgcrypto";

-- ── Users profile (extends Supabase auth.users) ───────────────
create table if not exists public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  display_name  text,
  momo_number   text,
  default_currency text default 'GHS',
  reminder_days_before int default 3,
  push_alerts   boolean default true,
  email_alerts  boolean default true,
  sms_alerts    boolean default false,
  created_at    timestamptz default now()
);

alter table public.profiles enable row level security;
create policy "Users can read/write own profile"
  on public.profiles for all
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Auto-create profile on sign-up
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, new.raw_user_meta_data->>'full_name');
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ── Subscriptions ────────────────────────────────────────────
create table if not exists public.subscriptions (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid references auth.users(id) on delete cascade not null,
  name            text not null,
  category        text not null default 'other',
  amount          numeric(10,2) not null,
  currency        text not null default 'GHS',
  billing_cycle   text not null default 'monthly',   -- weekly|monthly|quarterly|yearly
  start_date      date not null,
  next_renewal    date not null,
  payment_method  text not null default 'momo',      -- momo|visa|bank|cash
  momo_number     text,
  is_active       boolean default true,
  notes           text default '',
  created_at      timestamptz default now(),
  updated_at      timestamptz default now()
);

alter table public.subscriptions enable row level security;
create policy "Users manage own subscriptions"
  on public.subscriptions for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Auto-update updated_at
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger subscriptions_updated_at
  before update on public.subscriptions
  for each row execute procedure public.touch_updated_at();

-- ── Useful indexes ───────────────────────────────────────────
create index on public.subscriptions (user_id, next_renewal);
create index on public.subscriptions (user_id, is_active);
