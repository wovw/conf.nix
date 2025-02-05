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
    zig.url = "github:mitchellh/zig-overlay";
    nil.url = "github:oxalica/nil";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.zig.follows = "zig";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      oskars-dotfiles,
      rust-overlay,
      nixos-wsl,
      zig,
      stylix,
      nix-index-database,
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
            stylix.nixosModules.stylix
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [
                  rust-overlay.overlays.default
                  zig.overlays.default
                ];
                environment.systemPackages = [
                  (pkgs.rust-bin.stable.latest.default.override {
                    extensions = [
                      "rust-src"
                      "rust-analyzer"
                    ];
                  })
                  pkgs.zigpkgs.default
                ];
              }
            )
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit
                    username
                    inputs
                    host
                    system
                    ;
                };
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.${username} = import ./hosts/${host}/home.nix;
              };
            }
          ] ++ modules;
        };
    in
    {
      nixosConfigurations = {
        gram = mkHostConfig {
          host = "gram";
          system = "x86_64-linux";
          username = "wovw";
          modules = [
            nix-index-database.nixosModules.nix-index
            (
              { ... }:
              {
                nixpkgs.overlays = [
                  oskars-dotfiles.overlays.spotx
                ];
              }
            )
          ];
        };
        harpe = mkHostConfig rec {
          host = "harpe";
          system = "x86_64-linux";
          username = "wovw";
          modules = [
            nixos-wsl.nixosModules.default
            {
              system.stateVersion = "24.05";
              wsl.enable = true;
              wsl.defaultUser = username;
            }
          ];
        };
      };
    };
}
