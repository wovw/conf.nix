{
  pkgs,
  INTERNAL,
}:
let
  brightness = "${pkgs.callPackage ../../scripts/brightness.nix { }}/bin/brightness-control";
  toggleMirror = "${
    pkgs.callPackage ../../scripts/toggle-mirror.nix { inherit INTERNAL; }
  }/bin/toggle-mirror";
in
{
  wayland.windowManager.hyprland.settings = {
    # https://wiki.hyprland.org/Configuring/Monitors/
    monitor = [
      "${INTERNAL}, preferred, 0x0, 1.25"
      ", preferred, auto, 1"
    ];

    # https://wiki.hyprland.org/Configuring/Binds/#switches
    bindl = [
      ", switch:on:Lid Switch, exec, pidof hyprlock || hyprlock -q"
      ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"${INTERNAL}, disable\""
      ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"${INTERNAL}, preferred, 0x0, 1.25\""
    ];

    # Brightness Controls
    binde = [
      ", xf86MonBrightnessDown, exec, ${brightness} --dec"
      ", xf86MonBrightnessUp, exec, ${brightness} --inc"
    ];

    bind = [
      "$mainMod, P, exec, ${toggleMirror}"
    ];
  };
}
