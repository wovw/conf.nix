{ pkgs, ... }@args:
{
  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  home.sessionVariables = {
    # for pavucontrol in wl
    GDK_DISABLE = "vulkan";
  };

  home.packages = with pkgs; [
    cliphist
  ];

  imports = [
    (import ./rofi/rofi.nix (args))
    (import ./hyprland/hyprland.nix (args))
    (import ./waybar.nix (args))
    ./swaync/swaync.nix
    ./wlogout/config.nix
    ./screenshot/config.nix
  ];

  home.file."Pictures/wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };
}
