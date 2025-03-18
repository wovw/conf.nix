{ pkgs, wallpaper }:
{
  home.packages = with pkgs; [
    hyprpaper
  ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${toString wallpaper}
    wallpaper = , ${toString wallpaper}
  '';
}
