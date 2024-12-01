{
  description = "cpp";

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

        wrappedClang = pkgs.symlinkJoin {
          name = "wrapped-clang";
          paths = [ pkgs.llvmPackages.libcxxClang ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            for prog in $out/bin/*; do
              wrapProgram "$prog" \
                --set NIX_LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc ]}" \
                --set NIX_LD "${pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"}"
            done
          '';
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            wrappedClang
          ];

          shellHook = ''
            exec zsh
          '';
        };
      }
    );
}
