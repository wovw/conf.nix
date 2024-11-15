{ username }:
''
exec-once = dbus-update-activation-environment --systemd --all
exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = swww init && swww img /home/${username}/Pictures/wallpapers/fei-spider-lilies-16x9.jpg
exec-once = nm-applet --indicator
exec-once = swaync
exec-once = waybar
exec-once = lxqt-policykit-agent

# Add sleep before starting noisetorch to ensure audio system is ready
exec-once = sleep 2 && noisetorch -s alsa_input.pci-0000_00_1f.3.analog-stereo -i

# clipboard manager
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store
''
