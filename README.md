# my dotfiles

nix-darwin + home-manager で管理する dotfiles。

## 構成

- `flake.nix` — Nix flake エントリーポイント
- `modules/darwin/` — nix-darwin の共通設定（Homebrew, macOS システム設定等）
- `hosts/<hostname>/` — ホスト固有の設定
- `home/` — home-manager 設定（パッケージ, シンボリックリンク）
- `config/` — 実際の設定ファイル群（zsh, git, vim 等、直接編集可）

## ツール管理

| 種別 | ツール |
|------|--------|
| CLI パッケージ | Nix (home-manager) |
| GUI アプリ / MAS | Homebrew (nix-darwin で宣言) |
| ランタイムバージョン | mise (.tool-versions) |
| macOS システム設定 | nix-darwin |

## セットアップ・更新

初回セットアップ、ホスト追加、`flake.lock` の更新方法などは [docs/SETUP.md](docs/SETUP.md) を参照。
