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

  # theme
  stylix = {
    targets = {
      waybar.enable = false;
      rofi.enable = false;
      hyprland.enable = false;
      tmux.enable = false;
      neovim.enable = false;
      starship.enable = false;
    };
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
    };
  };
  gtk = {
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
}
