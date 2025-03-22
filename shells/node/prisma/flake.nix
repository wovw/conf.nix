{
  description = "Nodejs + pnpm + prisma";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    prisma-utils.url = "github:VanCoding/nix-prisma-utils";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      prisma-utils,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        prisma =
          (prisma-utils.lib.prisma-factory {
            inherit pkgs;
            prisma-fmt-hash = "sha256-aBRInT5la9jpDicaOWoOeFXhpobZ/7eX2+XjpwGq4jg=";
            query-engine-hash = "sha256-WYDR5B4+bTYGQcnCXt/G1yOKnkK5EvW1g5ssE31IdBc=";
            libquery-engine-hash = "sha256-EynSJBeJgsz8ybap+6oKgaHQQfD7rQaZYf3FopvvsPY=";
            schema-engine-hash = "sha256-wr0qnOOoi31PVIL6Ql/Qd+K0/MR1+loZ2kYOZjhqy1Y=";
          }).fromPnpmLock
            ./pnpm-lock.yaml;
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
            ${prisma.shellHook}
            export VERCEL_ENV=development

            exec zsh
          '';
        };
      }
    );
}
