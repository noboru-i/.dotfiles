# my dotfiles

nix-darwin + home-manager で管理する dotfiles。

## 構成

- `flake.nix` — Nix flake エントリーポイント
- `modules/darwin/` — nix-darwin の共通設定
  - `default.nix` — 基本設定（Nix, ユーザー, zsh, pam 等）
  - `homebrew.nix` — Homebrew (cask / MAS / brew)
  - `macos.nix` — macOS システム設定
- `hosts/<hostname>/` — ホスト固有の設定（共通設定をimportし、差分を記述）
- `home/` — home-manager 設定
  - `default.nix` — ファイル配置 (シンボリックリンク)
  - `packages.nix` — Nix パッケージ一覧
- `config/` — 実際の設定ファイル群 (直接編集可)
  - `zsh/` — zsh 設定
  - `git/` — git 設定
  - `ghostty/` — Ghostty ターミナル設定
  - `vim/` — vim 設定
  - `fzf/` — fzf 設定
  - `gh/` — GitHub CLI 設定
  - `mise/` — mise (ランタイムバージョン管理)
  - `claude/commands/` — Claude Code カスタムコマンド

## セットアップ

### 前提条件

- Apple Silicon Mac (aarch64-darwin)
- [Lix](https://lix.systems/) のインストール

```sh
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

### 新しいホストの追加

1. `hosts/<hostname>/default.nix` を作成し、共通設定をimport:
   ```nix
   { ... }: {
     imports = [ ../../modules/darwin ];
     # ホスト固有の設定があればここに追加
   }
   ```
2. `flake.nix` の `hosts` リストにホスト名を追加

### 適用

**初回のみ** — `darwin-rebuild` はまだ存在しないため `nix run` でブートストラップする。途中で Homebrew のインストールを求めるプロンプトが表示された場合は、そのままインストールして問題ない（`homebrew.nix` で宣言された cask / MAS アプリの管理に必要なため）:

```sh
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/.dotfiles
```

**2回目以降:**

```sh
sudo darwin-rebuild switch --flake ~/.dotfiles
```

## ツール管理

| 種別 | ツール |
|------|--------|
| CLI パッケージ | Nix (home-manager) |
| GUI アプリ / MAS | Homebrew (nix-darwin で宣言) |
| ランタイムバージョン | mise (.tool-versions) |
| macOS システム設定 | nix-darwin |
