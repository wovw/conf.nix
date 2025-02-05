{
  lib,
  host,
  config,
  pkgs,
  wallpaper,
  INTERNAL,
  EXTERNAL,
  terminal,
  keyboardLayout,
  ...
}:

with lib;
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig =
      let
        modifier = "SUPER";
      in
      concatStrings [
        ''
          ${builtins.readFile ./env.conf}
          ${
            (import ./laptop.nix {
              inherit
                pkgs
                modifier
                EXTERNAL
                INTERNAL
                ;
            })
          }
          ${
            (import ./startup.nix {
              inherit wallpaper;
            })
          }
          ${builtins.readFile ./decor.conf}
          ${
            (import ./keybinds.nix {
              inherit
                pkgs
                modifier
                host
                terminal
                ;
            })
          }
          ${
            (import ./settings.nix {
              colors = config.lib.stylix.colors;
              inherit host keyboardLayout;
            })
          }
          ${
            (import ./window-rules.nix {
              inherit EXTERNAL INTERNAL;
            })
          }
        ''
      ];
  };
}
