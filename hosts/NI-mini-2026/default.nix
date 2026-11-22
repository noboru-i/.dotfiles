{ pkgs, username, ... }: {
  imports = [ ../../modules/darwin ];

  # ホスト固有の設定があればここに追加
  # homebrew のリストは modules/darwin/homebrew.nix の共通リストに連結される
  homebrew.brews = [
    "hermes-agent" # CLI は原則 Nix 管理だが、nixpkgs に存在しないため例外的に Homebrew で管理する。
  ];
  homebrew.casks = [
    "hermes-desktop"
  ];

  # Apple Virtualization.framework 上で Linux VM を動かすため。
  # 他ユーザー（agent）や launchd の plist からも参照できるよう、home-manager ではなく
  # システムパッケージにして /run/current-system/sw/bin/limactl という安定したパスで提供する。
  # （nix store の絶対パスを plist に書くと、更新や GC のたびに壊れるため）
  environment.systemPackages = with pkgs; [
    lima
  ];

  # Hermes Agent の gateway を常時稼働させるため、システムをスリープさせない（ディスプレイは対象外）
  power.sleep.computer = "never";
}
