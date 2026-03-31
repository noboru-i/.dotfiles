# my dotfiles

nix-darwin + home-manager で管理する dotfiles。

## 構成

- `flake.nix` — Nix flake エントリーポイント
- `modules/darwin/` — nix-darwin の共通設定（Homebrew, macOS システム設定等）
- `hosts/<hostname>/` — ホスト固有の設定
- `home/` — home-manager 設定（パッケージ, シンボリックリンク）
- `config/` — 実際の設定ファイル群（zsh, git, vim 等、直接編集可）

## セットアップ

### 前提条件

- Apple Silicon Mac (aarch64-darwin)
- [Lix](https://lix.systems/) のインストール

```sh
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

### Xcode Command Line Tools のインストール

```sh
xcode-select --install
```

### リポジトリのクローン

```sh
git clone https://github.com/noboru-i/.dotfiles.git ~/.dotfiles
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
make bootstrap
```

**2回目以降:**

```sh
make switch
```

> `make help` で利用可能なコマンド一覧を確認できる。

## 更新

nixpkgs や nix-darwin、home-manager を最新化したいときは `flake.lock` を更新する。

```sh
make update   # flake.lock を最新コミットに更新
make switch   # 更新内容を適用
git add flake.lock
git commit -m "chore: update flake inputs"
```

`flake.lock` は依存関係のコミットを固定するファイルで、これを更新しない限り `make switch` を何度実行しても同じバージョンが使われる（再現性が保たれる）。
定期的（月1回程度）に更新するか、特定のパッケージを最新化したいタイミングで実行する。

## ツール管理

| 種別 | ツール |
|------|--------|
| CLI パッケージ | Nix (home-manager) |
| GUI アプリ / MAS | Homebrew (nix-darwin で宣言) |
| ランタイムバージョン | mise (.tool-versions) |
| macOS システム設定 | nix-darwin |
