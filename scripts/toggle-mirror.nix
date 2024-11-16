{ pkgs }:

pkgs.writeShellApplication {
  name = "toggle-mirror";

  runtimeInputs = with pkgs; [
    hyprland
    libnotify
    gawk
    gnugrep
  ];

  text = ''
    INTERNAL="eDP-1"
    EXTERNAL="HDMI-A-4"

    set_mirror_mode() {
        hyprctl keyword monitor "$EXTERNAL,preferred,auto,1,mirror,$INTERNAL"
        notify-send "Monitor Layout: Mirror"
    }

    set_extended_mode() {
        hyprctl keyword monitor "$EXTERNAL,preferred,auto-right,1"
        notify-send "Monitor Layout: Extend"
    }

    if hyprctl monitors | grep -q "$EXTERNAL"; then
        set_mirror_mode
    else
        set_extended_mode
    fi
  '';
}
