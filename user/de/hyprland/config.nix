{
  lib,
  host,
  pkgs,
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
    ./lock.nix
  ];
  services = {
    hyprpaper.enable = true; # config in stylix
    hyprpolkitagent.enable = true;
  };
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
