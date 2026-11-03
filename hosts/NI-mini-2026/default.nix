{ ... }: {
  imports = [ ../../modules/darwin ];

  # ホスト固有の設定があればここに追加
  # homebrew のリストは modules/darwin/homebrew.nix の共通リストに連結される
  homebrew.brews = [
    "hermes-agent" # CLI は原則 Nix 管理だが、nixpkgs に存在しないため例外的に Homebrew で管理する。
  ];

  # Hermes Agent の gateway を常時稼働させるため、システムをスリープさせない（ディスプレイは対象外）
  power.sleep.computer = "never";
}
