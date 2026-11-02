# セットアップ

## 前提条件

- Apple Silicon Mac (aarch64-darwin)
- [Lix](https://lix.systems/) のインストール

```sh
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

## Xcode Command Line Tools のインストール

```sh
xcode-select --install
```

## Homebrew のインストール

nix-darwin の `homebrew` モジュール（`modules/darwin/homebrew.nix`）は Homebrew 本体をインストールせず、既存の `brew` を使って cask / brews を管理するだけなので、`make bootstrap` より前に手動でインストールしておく。

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

インストール完了後に表示される `brew shellenv` を `.zprofile` に追記する案内は不要（PATH は dotfiles 側の zsh 設定で管理する）。現在のシェルで `brew` を使いたい場合のみ以下を実行する:

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## リポジトリのクローン

```sh
git clone https://github.com/noboru-i/.dotfiles.git ~/.dotfiles
```

## 新しいホストの追加

1. `hosts/<hostname>/default.nix` を作成し、共通設定をimport:
   ```nix
   { ... }: {
     imports = [ ../../modules/darwin ];
     # ホスト固有の設定があればここに追加
   }
   ```
2. `flake.nix` の `hosts` リストにホスト名を追加

## 適用

**初回のみ** — `darwin-rebuild` はまだ存在しないため `nix run` でブートストラップする。事前に [Homebrew のインストール](#homebrew-のインストール) を済ませておくこと:

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
