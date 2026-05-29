# ADR 0001: yarn を Nix で管理する

- Date: 2026-05-18
- Status: Accepted

## Context

JavaScript プロジェクトで yarn を利用するために、パッケージマネージャーとして yarn のインストール方法を検討した。
候補は以下の2つ：

1. `home/packages.nix` に追加（Nix 管理）
2. mise で管理（`mise use -g yarn`）

## Decision

`home/packages.nix` に yarn を追加し、Nix で管理する。

## Reasons

- yarn のバージョン切り替えをする用途がない
- mise はバージョン切り替えが必要なランタイムの管理に専念させる
- dotfiles 内で設定が完結し、見通しが良い

## Consequences

- 全ホストで同一バージョンの yarn が nixpkgs に固定されてインストールされる
- プロジェクト別に yarn バージョンを変えたい場合は、mise への移行を再検討する
