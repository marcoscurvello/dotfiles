{
  description = "Marcos Curvello's dotfiles";

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

  outputs =
    inputs@{ self, nixpkgs, nix-darwin, home-manager }:
    let
      username = "marcoscurvello";
      hostname = "MacBookPro";
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
          ./darwin.nix
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
          switch = {
            type = "app";
            program =
              let
                home-manager-bin = home-manager.packages.${system}.home-manager;
              in
              toString (
                pkgs.writeShellScript "dotfiles-switch" ''
                  set -euo pipefail

                  if [[ ! -f flake.nix ]]; then
                    echo "Run this from the dotfiles repository root." >&2
                    exit 1
                  fi

                  export NIX_CONFIG="experimental-features = nix-command flakes"
                  exec ${home-manager-bin}/bin/home-manager switch --flake ".#marcoscurvello"
                ''
              );
          };

          darwin-switch = {
            type = "app";
            program =
              let
                darwin-rebuild = nix-darwin.packages.${system}.darwin-rebuild;
              in
              toString (
                pkgs.writeShellScript "dotfiles-darwin-switch" ''
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

          default = self.apps.${system}.switch;
        }
      );
    };
}
