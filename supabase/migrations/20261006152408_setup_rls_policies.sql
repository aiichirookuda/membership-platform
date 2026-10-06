-- =========================================
-- RLS有効化
-- =========================================
alter table public.profiles enable row level security;
alter table public.games enable row level security;
alter table public.favorites enable row level security;


-- =========================================
-- profiles
-- ログインユーザーは自分のプロフィールのみ操作可能
-- =========================================

-- 自分のプロフィールだけ取得可能
create policy "users can read own profile"
on public.profiles
for select
to authenticated
using (
  auth.uid() = user_id
);

-- 自分自身のプロフィールだけ登録可能
create policy "users can create own profile"
on public.profiles
for insert
to authenticated
with check (
  auth.uid() = user_id
);

-- 自分のプロフィールだけ更新可能
create policy "users can update own profile"
on public.profiles
for update
to authenticated
using (
  auth.uid() = user_id
)
with check (
  auth.uid() = user_id
);


-- =========================================
-- games
-- ゲーム情報は未ログインでも閲覧可能
-- =========================================

-- ゲーム情報の参照のみ公開
create policy "games are publicly readable"
on public.games
for select
to anon, authenticated
using (true);


-- =========================================
-- favorites
-- ログインユーザーは自分のお気に入りのみ操作可能
-- =========================================

-- 自分のお気に入りだけ取得可能
create policy "users can read own favorites"
on public.favorites
for select
to authenticated
using (
  auth.uid() = user_id
);

-- 自分のお気に入りだけ登録可能
create policy "users can create own favorites"
on public.favorites
for insert
to authenticated
with check (
  auth.uid() = user_id
);

-- 自分のお気に入りだけ削除可能
create policy "users can delete own favorites"
on public.favorites
for delete
to authenticated
using (
  auth.uid() = user_id
);