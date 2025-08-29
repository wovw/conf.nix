{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    oskars-dotfiles = {
      url = "github:oskardotglobal/.dotfiles/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nil.url = "github:oxalica/nil";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
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
      stylix,
      nix-index-database,
      chaotic,
      ...
    }@inputs:
    let
      mkHostConfig =
        {
          host,
          username,
          system ? "x86_64-linux",
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
            chaotic.nixosModules.default
            stylix.nixosModules.stylix
            nix-index-database.nixosModules.nix-index
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [
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
            (
              { pkgs, ... }:
              {
                home-manager = {
                  extraSpecialArgs = {
                    inherit
                      pkgs
                      username
                      inputs
                      host
                      system
                      ;
                  };
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  users.${username}.imports = [ ./hosts/${host}/home.nix ];
                };
              }
            )
          ]
          ++ modules;
        };
    in
    {
      nixosConfigurations = {
        gram = mkHostConfig {
          host = "gram";
          username = "wovw";
          modules = [
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
        kfc = mkHostConfig {
          host = "kfc";
          username = "krispy";
        };
      };
    };
}
