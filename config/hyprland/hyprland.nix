{
  lib,
  host,
  config,
  pkgs,
  wallpaper,
  INTERNAL,
  EXTERNAL,
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
              inherit pkgs;
              inherit modifier;
              inherit EXTERNAL INTERNAL;
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
              inherit pkgs;
              inherit modifier;
              inherit host;
            })
          }
          ${
            (import ./settings.nix {
              colors = config.lib.stylix.colors;
              inherit host;
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
