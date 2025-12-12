args: {
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  imports = [
    ./vicinae.nix
    (import ./hyprland/hm/default.nix args)
    ./waybar.nix
    ./swaync.nix
    ./wlogout/config.nix
  ];

  home.file."Pictures/wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };
}
