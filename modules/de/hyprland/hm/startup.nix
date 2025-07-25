{ pkgs }:
let
  monitor-connect = "${
    pkgs.callPackage ../../scripts/handle-monitor-connect.nix { }
  }/bin/handle-monitor-connect";
in
''
  exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
  exec-once = uwsm app -- nm-applet --indicator
  exec-once = uwsm app -- swaync

  # clipboard manager
  exec-once = uwsm app -- wl-paste --type text --watch cliphist store
  exec-once = uwsm app -- wl-paste --type image --watch cliphist store

  exec-once = ${monitor-connect}
''
