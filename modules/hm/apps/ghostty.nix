{
  inputs,
  system,
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
    theme = tokyonight

    keybind = ctrl+enter=ignore
  '';
}
