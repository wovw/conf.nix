{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    oskars-dotfiles = {
      url = "github:oskardotglobal/.dotfiles/nix";
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
    rofi-tools = {
      url = "github:szaffarano/rofi-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    xmcl = {
      url = "github:x45iq/xmcl-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      oskars-dotfiles,
      nixos-wsl,
      stylix,
      nix-index-database,
      chaotic,
      lanzaboote,
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
            stylix.nixosModules.stylix
            nix-index-database.nixosModules.nix-index
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
            # secure boot
            lanzaboote.nixosModules.lanzaboote
            (
              { pkgs, lib, ... }:
              {

                environment.systemPackages = [
                  # For debugging and troubleshooting Secure Boot.
                  pkgs.sbctl
                ];

                # Lanzaboote currently replaces the systemd-boot module.
                # This setting is usually set to true in configuration.nix
                # generated at installation time. So we force it to false
                # for now.
                boot.loader.systemd-boot.enable = lib.mkForce false;

                boot.lanzaboote = {
                  enable = true;
                  pkiBundle = "/var/lib/sbctl";
                };
              }
            )

            chaotic.nixosModules.default
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
          modules = [
            chaotic.nixosModules.default
          ];
        };
      };
    };
}
