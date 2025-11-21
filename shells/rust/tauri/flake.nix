{
  description = "tauri flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      rust-overlay,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
            # https://wiki.nixos.org/wiki/Tauri
            nativeBuildInputs = [
              fnm
              pnpm
              (rust-bin.stable.latest.default.override {
                extensions = [
                  "rust-src"
                  "rust-analyzer"
                ];
              })
              pkg-config
              gobject-introspection
            ];

            buildInputs = [
              at-spi2-atk
              atkmm
              cairo
              gdk-pixbuf
              glib
              gtk3
              harfbuzz
              librsvg
              libsoup_3
              pango
              webkitgtk_4_1
              openssl
              zlib
              desktop-file-utils # `update-desktop-database` for tauri-plugin-deep-link
            ];

            # env vars
            GIO_MODULE_DIR = "${pkgs.glib-networking}/lib/gio/modules/"; # https://github.com/tauri-apps/tauri/issues/11647
          };
      }
    );
}
