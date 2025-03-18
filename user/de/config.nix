{ ... }@args:
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

  imports = [
    (import ./rofi/config.nix (args))
    (import ./hyprland/config.nix (args))
    (import ./waybar.nix (args))
    ./swaync/swaync.nix
    ./wlogout/config.nix
  ];

  home.file."Pictures/wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };
}
