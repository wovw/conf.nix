{
  pkgs,
  ...
}:
let
  gimp-plugins = pkgs.gimp-with-plugins.override {
    plugins = with pkgs; [
      gimpPlugins.gmic # Tons of filters, features, more photoshop-like stuff
      # gimpPlugins.resynthesizer # Content aware fill + more # TODO: update to gim3
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
