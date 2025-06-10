{
  inputs,
  system,
  config,
  ...
}:
{
  home.packages = [
    inputs.ghostty.packages."${system}".default
  ];
  xdg.configFile."ghostty/config".text = ''
    background = 000000
    background-opacity = 0.50
    font-size = ${toString config.stylix.fonts.sizes.applications}
    font-family = "${config.stylix.fonts.monospace.name}"
    window-padding-x = 4
    confirm-close-surface = false
    window-decoration = none
    theme = tokyonight
  '';
}
