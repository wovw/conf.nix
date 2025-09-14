{ ... }@args:
{
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  imports = [
    (import ./rofi/config.nix (args))
    (import ./hyprland/hm/default.nix (args))
    ./waybar.nix
    ./swaync/config.nix
    ./wlogout/config.nix
  ];

  home.file."Pictures/wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };
}
