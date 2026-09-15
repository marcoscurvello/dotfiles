{
  description = "Marcos Curvello's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, nix-darwin, nix-homebrew, home-manager }:
    let
      username = "marcoscurvello";
      hostname = "mothership";
      darwinSystem = "aarch64-darwin";
      forDarwinSystems =
        function:
        nixpkgs.lib.genAttrs
          [
            "aarch64-darwin"
            "x86_64-darwin"
          ]
          (
            system:
            let
              pkgs = nixpkgs.legacyPackages.${system};
            in
            function system pkgs
          );
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${darwinSystem};
        modules = [ ./home.nix ];
      };

      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        specialArgs = { inherit inputs username; };
        modules = [
          ./configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = false;
              user = username;
              autoMigrate = true;
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = ./home.nix;
          }
        ];
      };

      apps = forDarwinSystems (
        system: pkgs: {
          rebuild = {
            type = "app";
            meta.description = "Apply nix-darwin and Home Manager configuration";
            program =
              let
                darwin-rebuild = nix-darwin.packages.${system}.darwin-rebuild;
              in
              toString (
                pkgs.writeShellScript "dotfiles-rebuild" ''
                  set -euo pipefail

                  if [[ ! -f flake.nix ]]; then
                    echo "Run this from the dotfiles repository root." >&2
                    exit 1
                  fi

                  export NIX_CONFIG="experimental-features = nix-command flakes"
                  exec ${darwin-rebuild}/bin/darwin-rebuild switch --flake ".#${hostname}"
                ''
              );
          };

          check = {
            type = "app";
            meta.description = "Validate the dotfiles flake and build the Darwin system without activating";
            program =
              toString (
                pkgs.writeShellScript "dotfiles-check" ''
                  set -euo pipefail

                  if [[ ! -f flake.nix ]]; then
                    echo "Run this from the dotfiles repository root." >&2
                    exit 1
                  fi

                  export NIX_CONFIG="experimental-features = nix-command flakes"
                  ${pkgs.nix}/bin/nix flake check
                  ${pkgs.nix}/bin/nix build ".#darwinConfigurations.${hostname}.system" --no-link
                ''
              );
          };

          switch = self.apps.${system}.rebuild;
          darwin-switch = self.apps.${system}.rebuild;
          default = self.apps.${system}.rebuild;
        }
      );
    };
}
