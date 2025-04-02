{
  description = "cmake example";

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

        # example project
        hazel = pkgs.stdenv.mkDerivation {
          pname = "Hazel"; # name of project defined in CMake
          version = "0.1.0";

          # Use the current directory as the source
          src = ./.;

          # Build dependencies
          nativeBuildInputs = with pkgs; [
            cmake
          ];

          # Runtime dependencies (if any)
          buildInputs = with pkgs; [
            # Add any runtime dependencies here
          ];

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Debug"
          ];

          # use all available cores
          buildPhase = ''
            make -j $NIX_BUILD_CORES
          '';

          # ensure binary is in right place
          installPhase = ''
            mkdir -p $out/bin
            cp Hazel $out/bin/
          '';
        };
      in
      {
        # `nix build`
        packages.default = hazel;

        # `nix run`
        apps.default = flake-utils.lib.mkApp {
          drv = hazel;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            cmake
          ];

          # Include the build inputs from the main package
          inputsFrom = [ hazel ];

          shellHook = ''
            exec zsh
          '';
        };
      }
    );
}

