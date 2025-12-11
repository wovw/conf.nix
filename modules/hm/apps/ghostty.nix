{
  config,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.ghostty
  ];
  xdg.configFile."ghostty/config".text = ''
    background = 000000
    background-opacity = 0.50
    font-size = ${toString config.stylix.fonts.sizes.applications}
    font-family = "${config.stylix.fonts.monospace.name} Mono"
    window-padding-x = 4
    confirm-close-surface = false
    window-decoration = none
    theme = TokyoNight

    keybind = ctrl+enter=ignore
  '';
  xdg.mimeApps = {
    defaultApplications = {
      "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";
    };
    associations.added = {
      "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";
    };
  };
}
