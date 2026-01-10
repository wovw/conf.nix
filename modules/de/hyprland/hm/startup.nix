{ pkgs, ... }:
let
  monitor-connect = "${
    pkgs.callPackage ../scripts/handle-monitor-connect.nix { }
  }/bin/handle-monitor-connect";
in
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "swaync"
      "${monitor-connect}"
    ];
  };
}
