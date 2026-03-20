# my dotfiles

nix-darwin + home-manager で管理する dotfiles。

## 構成

- `flake.nix` — Nix flake エントリーポイント
- `hosts/ishikuranoborunoMacBook-Air/` — nix-darwin のホスト設定
  - `default.nix` — 基本設定
  - `homebrew.nix` — Homebrew (cask / MAS / brew)
  - `macos.nix` — macOS システム設定
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

### 適用

```sh
darwin-rebuild switch --flake ~/.dotfiles
```

## ツール管理

| 種別 | ツール |
|------|--------|
| CLI パッケージ | Nix (home-manager) |
| GUI アプリ / MAS | Homebrew (nix-darwin で宣言) |
| ランタイムバージョン | mise (.tool-versions) |
| macOS システム設定 | nix-darwin |
