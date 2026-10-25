{ ... }: {
  imports = [ ../../modules/darwin ];

  # ホスト固有の設定があればここに追加
  # homebrew のリストは modules/darwin/homebrew.nix の共通リストに連結される
  homebrew.casks = [
    "arduino-ide"
    "bambu-studio"
    "discord"
    "openscad@snapshot"
  ];
}
