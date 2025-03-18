{ }:
''
  exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
  exec-once = systemctl start tzupdate
  exec-once = nm-applet --indicator
  exec-once = swaync
  exec-once = waybar
  exec-once = hyprpaper
  exec-once = lxqt-policykit-agent

  # clipboard manager
  exec-once = wl-paste --type text --watch cliphist store
  exec-once = wl-paste --type image --watch cliphist store
''
