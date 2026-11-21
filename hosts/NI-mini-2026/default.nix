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

  # ホスト固有の CLI パッケージ（home/packages.nix の共通リストに連結される）
  home-manager.users.${username}.home.packages = with pkgs; [
    lima # Apple Virtualization.framework 上で Linux VM を動かすため
  ];

  # Hermes Agent の gateway を常時稼働させるため、システムをスリープさせない（ディスプレイは対象外）
  power.sleep.computer = "never";
}
