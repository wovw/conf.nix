{
  pkgs,
  ...
}:
let
  gimp-plugins = pkgs.gimp3-with-plugins.override {
    plugins = with pkgs; [
      gimp3Plugins.gmic # Tons of filters, features, more photoshop-like stuff
      # gimpPlugins.resynthesizer # Content aware fill + more
    ];
  };
in
{
  home.packages = [ gimp-plugins ];
  xdg.mimeApps.defaultApplications = {
    "image/*" = "gimp.desktop";
  };
}
