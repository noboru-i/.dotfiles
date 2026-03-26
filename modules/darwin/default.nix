{ pkgs, ... }: {
  imports = [
    ./homebrew.nix
    ./macos.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "@admin" ];
  nix.settings.always-allow-substitutes = true;
  nix.settings.extra-trusted-substituters = [ "https://cache.lix.systems" ];
  nix.settings.extra-trusted-public-keys = [ "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" ];
  nix.settings.max-jobs = "auto";
  nix.settings.extra-nix-path = [ "nixpkgs=flake:nixpkgs" ];

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  users.users.noboruishikura = {
    name = "noboruishikura";
    home = "/Users/noboruishikura";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.primaryUser = "noboruishikura";

  environment.systemPackages = with pkgs; [];

  system.activationScripts.postActivation.text = ''
    for app in \
      "/Applications/GarageBand.app" \
      "/Applications/iMovie.app"; do
      if [ -d "$app" ]; then
        rm -rf "$app"
        echo "Removed $app"
      fi
    done
  '';

  system.stateVersion = 5;
}
