.PHONY: switch bootstrap update help

FLAKE := ~/.dotfiles

## switch: darwin-rebuild switch を実行する（通常の適用）
switch:
	sudo darwin-rebuild switch --flake $(FLAKE)

## bootstrap: 初回セットアップ（darwin-rebuild がまだ存在しない場合）
bootstrap:
	sudo nix --extra-experimental-features "nix-command flakes" \
		run nix-darwin/master#darwin-rebuild -- switch --flake $(FLAKE)

## update: flake.lock を更新する
update:
	nix flake update --flake $(FLAKE)

## help: このヘルプを表示する
help:
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/^## //'
