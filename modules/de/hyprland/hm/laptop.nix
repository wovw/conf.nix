{
  pkgs,
  modifier,
  INTERNAL,
}:
let
  brightness = pkgs.callPackage ../../scripts/brightness.nix { };
  toggleMirror = pkgs.callPackage ../../scripts/toggle-mirror.nix { inherit INTERNAL; };
in
''
  # https://wiki.hyprland.org/Configuring/Monitors/
  monitor=${INTERNAL},preferred,0x0,1.25
  monitor=,preferred,auto,1

  # https://wiki.hyprland.org/Configuring/Binds/#switches
  bindl = , switch:on:Lid Switch,exec,pidof hyprlock || hyprlock -q
  bindl = , switch:on:Lid Switch,exec,hyprctl keyword monitor "${INTERNAL},disable"
  bindl = , switch:off:Lid Switch,exec,hyprctl keyword monitor "${INTERNAL},preferred,0x0,1.25"

  binde = , xf86MonBrightnessDown, exec, ${brightness}/bin/brightness-control --dec
  binde = , xf86MonBrightnessUp, exec, ${brightness}/bin/brightness-control --inc

  bind = ${modifier}, P, exec, ${toggleMirror}/bin/toggle-mirror
''
