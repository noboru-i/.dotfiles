{
  description = "noboru-i dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      hosts = [
        "ishikuranoborunoMacBook-Air"
        "NI-Air-2026"
      ];
      mkDarwin = hostname: {
        name = hostname;
        value = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/${hostname}
            home-manager.darwinModules.home-manager
            {
              networking.hostName = hostname;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "before-home-manager";
              home-manager.users.noboruishikura = import ./home;
            }
          ];
        };
      };
    in
    {
      darwinConfigurations = builtins.listToAttrs (map mkDarwin hosts);
    };
}
