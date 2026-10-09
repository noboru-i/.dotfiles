# CLAUDE.md

このリポジトリは nix-darwin + home-manager で管理する個人 dotfiles。詳細な構成は @README.md を参照。

## このリポジトリでの作業の基本

- `config/` 配下が実体（直接編集する場所）。`home/default.nix` はそれを `~/` 以下へ symlink するマッピングを定義しているだけ。
- 新しい設定ファイルを `config/claude/` などに追加したときは、`home/default.nix` の `home.file` にリンク定義を追加しないと反映されない（symlinkされていないファイルは home-manager 管理外）。
- ディレクトリ丸ごと運用したい対象（例: `config/claude/skills/`）は、個別ファイルではなく **ディレクトリ単位** で `mkOutOfStoreSymlink` すること。今後中身が増えても `default.nix` を変更不要にするため。
  - 例: `".claude/skills".source = link "config/claude/skills";`
  - ディレクトリ全体を symlink に切り替える変更をするときは、適用前に実体ディレクトリ（例: `~/.claude/skills`）が既に存在していないか確認し、あれば削除してから `make switch` する（home-manager は既存の実体ディレクトリをリンクで自動上書きしない）。
- 一方 `config/claude/commands/` は現状ファイル単位でリンクしている（`create-pr.md` のみ）。新しいコマンドを追加したら `home/default.nix` にリンクが漏れていないか確認する。

## シェル設定の方針（AI ファースト）

- デフォルトは AI エージェント向けの素のシェル。人間向けの設定は opt-in とする。
- `config/zsh/zshenv` の `is_human`（TTY かつ AI 用環境変数なし）で人間/AI を判定する。AI 側では `EDITOR=true`・`PAGER=cat` などで入力待ちを防ぐ。
- `config/zsh/zshrc` は `is_human || return 0` より上に AI にも必要なもの（mise など）、下に人間向け（エイリアス、プロンプト、プラグイン、キーバインド）を書く。エイリアスは必ずガードより下に置く。
- GNU coreutils は PATH に入れない（AI が書く BSD 流のコマンドを壊さないため）。

## コミット運用

- 個人の dotfiles リポジトリであり PR フローは使わない運用のため、特別な指示がない限り `main` ブランチに直接コミットしてよい（ブランチを切らない）。

## 適用フロー

- 変更を試すには `make switch`（初回のみ `make bootstrap`）。
- `flake.lock` の更新は `make update` → `make switch` → `flake.lock` のみをコミット、という流れ（README参照）。
