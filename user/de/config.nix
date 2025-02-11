{ pkgs, lib, ... }@args:
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

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock -q";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock -q";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  programs = {
    hyprlock = {
      enable = true;
      settings = lib.mkForce {
        general = {
          disable_loading_bar = true;
          grace = 0;
          hide_cursor = true;
          no_fade_in = false;
          ignore_empty_input = false;
        };
        background = [
          {
            path = "~/Pictures/wallpapers/Rainnight.jpg";
          }
        ];
        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(CFE6F4)";
            inner_color = "rgb(657DC2)";
            outer_color = "rgb(0D0E15)";
            outline_thickness = 5;
            placeholder_text = "Password...";
            shadow_passes = 2;
          }
        ];
      };
    };
  };
}
