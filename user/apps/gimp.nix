{
  pkgs,
  ...
}:
let
  pluginDerivation =
    attrs:
    let
      name = attrs.name or "${attrs.pname}-${attrs.version}";
    in
    pkgs.stdenv.mkDerivation (
      {
        prePhases = "extraLib";
        extraLib = ''
          installScripts(){
            mkdir -p $out/${pkgs.gimp.targetScriptDir}/${name};
            for p in "$@"; do cp "$p" -r $out/${pkgs.gimp.targetScriptDir}/${name}; done
          }
          installPlugin() {
            # The base name of the first argument is the plug-in name and the main executable.
            # GIMP only allows a single plug-in per directory:
            # https://gitlab.gnome.org/GNOME/gimp/-/commit/efae55a73e98389e38fa0e59ebebcda0abe3ee96
            pluginDir=$out/${pkgs.gimp.targetPluginDir}/$(basename "$1")
            install -Dt "$pluginDir" "$@"
          }
        '';
      }
      // attrs
      // {
        name = "${pkgs.gimp.pname}-plugin-${name}";
        buildInputs = [
          pkgs.gimp
          pkgs.gimp.gtk
          pkgs.glib
        ] ++ (attrs.buildInputs or [ ]);

        nativeBuildInputs = [
          pkgs.pkg-config
          pkgs.intltool
        ] ++ (attrs.nativeBuildInputs or [ ]);

        # Override installation paths.
        env = {
          PKG_CONFIG_GIMP_2_0_GIMPLIBDIR = "${placeholder "out"}/${pkgs.gimp.targetLibDir}";
          PKG_CONFIG_GIMP_2_0_GIMPDATADIR = "${placeholder "out"}/${pkgs.gimp.targetDataDir}";
        } // attrs.env or { };
      }
    );

  # Modified from:
  # https://github.com/NixOS/nixpkgs/blob/9f4128e00b0ae8ec65918efeba59db998750ead6/pkgs/applications/graphics/gimp/plugins/default.nix#L218C3-L244C1
  # Resynthesizer is broken right now bc python 2.7 is EOL, this doesn't use python
  resynthesizer-scm = pluginDerivation {
    /*
      menu:
      Edit/Fill with pattern seamless...
      Filters/Enhance/Heal selection...
      Filters/Enhance/Heal transparency...
      Filters/Enhance/Sharpen by synthesis...
      Filters/Enhance/Uncrop...
      Filters/Map/Style...
      Filters/Render/Texture...
    */
    pname = "resynthesizer-scm";
    version = "latest";
    buildInputs = with pkgs; [ fftw ];
    nativeBuildInputs = with pkgs; [ autoreconfHook ];
    makeFlags = [ "GIMP_LIBDIR=${placeholder "out"}/${pkgs.gimp.targetLibDir}" ];
    src = pkgs.fetchFromGitHub {
      owner = "itr-tert";
      repo = "gimp-resynthesizer-scm";
      rev = "master";
      hash = "sha256-Zc1wJaT7a9GCa6EaoyAwXaHk59lYYwrEHY1KGbPu6ic=";
    };
  };

  gimp-plugins = pkgs.gimp-with-plugins.override {
    plugins = [
      pkgs.gimpPlugins.gmic # Tons of filters, features, more photoshop-like stuff
      resynthesizer-scm # Content aware fill + more
    ];
  };

in
{
  home.packages = [ gimp-plugins ];
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/*" = "gimp.desktop";
    };
  };
}
