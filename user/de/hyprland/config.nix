{
  lib,
  host,
  pkgs,
  wallpaper,
  INTERNAL,
  EXTERNAL,
  terminal,
  keyboardLayout,
  config,
  ...
}:

with lib;
{
  imports = [
    (import ./hyprpaper.nix {
      inherit pkgs wallpaper;
    })
    ./lock.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    extraConfig =
      let
        modifier = "SUPER";
      in
      concatStrings [
        ''
          ${import ./env.nix { inherit config; }}
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
          ${(import ./startup.nix { })}
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
