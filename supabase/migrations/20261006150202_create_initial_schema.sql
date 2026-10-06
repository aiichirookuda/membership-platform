-- =========================================
-- profiles
-- Supabase Auth のユーザーに紐づくプロフィール情報
-- auth.users と 1:1 の関係
-- =========================================
create table public.profiles (
  -- auth.users.id をそのまま主キーとして利用
  -- ユーザー削除時はプロフィールも自動削除
  user_id uuid primary key
    references auth.users(id)
    on delete cascade,

  -- 画面上に表示するユーザー名
  -- 1〜50文字に制限
  display_name text not null
    check (char_length(display_name) between 1 and 50),

  -- 任意のアバター画像URL
  avatar_url text
);


-- =========================================
-- games
-- ゲームタイトルの基本情報
-- =========================================
create table public.games (
  -- ゲームごとの一意なIDを自動生成
  id uuid primary key default gen_random_uuid(),

  -- ゲームタイトル
  title text not null,

  -- URLなどで使用する一意な識別子
  -- 例: /games/example-game
  slug text not null unique
);


-- =========================================
-- favorites
-- ユーザーとゲームのお気に入り関係を管理
-- User : Game = 多対多
-- =========================================
create table public.favorites (
  -- お気に入りを登録したユーザー
  -- ユーザー削除時はお気に入りも自動削除
  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  -- お気に入り対象のゲーム
  -- ゲーム削除時は関連するお気に入りも自動削除
  game_id uuid not null
    references public.games(id)
    on delete cascade,

  -- 同じユーザーが同じゲームを重複登録できないようにする
  primary key (user_id, game_id)
);