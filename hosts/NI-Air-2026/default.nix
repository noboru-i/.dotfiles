{ pkgs, username, ... }: {
  imports = [ ../../modules/darwin ];

  # ホスト固有の設定があればここに追加
  # homebrew のリストは modules/darwin/homebrew.nix の共通リストに連結される
  homebrew.casks = [
    "arduino-ide"
    "bambu-studio"
    "discord"
    "lm-studio"
    "openscad@snapshot"
  ];

  # ホスト固有の CLI パッケージ（home/packages.nix の共通リストに連結される）
  home-manager.users.${username}.home.packages = with pkgs; [
    ollama
  ];
}
