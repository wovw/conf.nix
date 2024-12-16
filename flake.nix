{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    oskars-dotfiles = {
      url = "github:oskardotglobal/.dotfiles/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      oskars-dotfiles,
      rust-overlay,
      nixos-wsl,
      ...
    }@inputs:
    let
      mkHostConfig =
        {
          host,
          system,
          username,
          modules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              system
              inputs
              username
              host
              ;
          };
          modules = [
            ./hosts/${host}/config.nix
            inputs.stylix.nixosModules.stylix
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [
                  oskars-dotfiles.overlays.spotx
                  rust-overlay.overlays.default
                ];
                environment.systemPackages = [
                  (pkgs.rust-bin.stable.latest.default.override {
                    extensions = [
                      "rust-src"
                      "rust-analyzer"
                    ];
                  })
                ];
              }
            )
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit username inputs host;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./hosts/${host}/home.nix;
            }
          ] ++ modules;
        };
    in
    {
      nixosConfigurations = {
        xV470 = mkHostConfig {
          host = "xV470";
          system = "x86_64-linux";
          username = "wovw";
        };
        W470 = mkHostConfig {
          host = "W470";
          system = "x86_64-linux";
          username = "wovw";
          modules = [
            nixos-wsl.nixosModules.default
            {
              system.stateVersion = "24.05";
              wsl.enable = true;
              wsl.defaultUser = "wovw";
            }
          ];
        };
      };
    };
}
