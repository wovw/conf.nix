{ inputs, system, ... }:
{
  home.packages = [
    inputs.ghostty.packages."${system}".default
  ];
  xdg.configFile."ghostty/config".text = ''
    background = 000000
    background-opacity = 0.50
    font-size = 12
    font-family = "JetBrainsMono Nerd Font Mono"
    window-padding-x = 4
    confirm-close-surface = false
    window-decoration = none
    theme = tokyonight
  '';
}
