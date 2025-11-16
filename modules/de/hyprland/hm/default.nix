{
  lib,
  host,
  pkgs,
  inputs,
  INTERNAL,
  EXTERNAL,
  terminal,
  system,
  ...
}:

with lib;
{
  imports = [
    ../lock/hm.nix
    ./env.nix
  ];
  services = {
    hyprpaper.enable = true; # config in stylix
    hyprpolkitagent.enable = true;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false; # using uwsm instead
    extraConfig =
      let
        modifier = "SUPER";
      in
      concatStrings [
        ''
          $EXTERNAL = ${EXTERNAL}
          ${
            (import ./laptop.nix {
              inherit
                pkgs
                modifier
                INTERNAL
                ;
            })
          }
          ${import ./startup.nix { inherit pkgs; }}
          ${import ./clipboard.nix { inherit inputs system modifier; }}
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
          ${builtins.readFile ./settings.conf}
          ${builtins.readFile ./window-rules.conf}
        ''
      ];
  };
}
