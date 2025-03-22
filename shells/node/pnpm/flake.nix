{
  description = "Nodejs + pnpm";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_22
            (pnpm.override {
              version = "10.6.1";
              hash = "sha256-gSBIRaOWliqcS0nMLWyvu0mnWGUtPCQ/ISjLxjgIT+I=";
            })
            zsh
          ];

          shellHook = ''
            export VERCEL_ENV=development

            exec zsh
          '';
        };
      }
    );
}
