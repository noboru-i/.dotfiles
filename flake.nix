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
      hostConfigs = [
        { hostname = "NI-Air-2020"; username = "noboruishikura"; }
        { hostname = "NI-Air-2026"; username = "noboruishikura"; }
        { hostname = "ML-00861";    username = "noboru_ishikura"; }
      ];
      mkDarwin = { hostname, username }: {
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
              home-manager.users.${username} = import ./home;
              home-manager.extraSpecialArgs = { inherit username; };
            }
          ];
        };
      };
    in
    {
      darwinConfigurations = builtins.listToAttrs (map mkDarwin hostConfigs);
    };
}
