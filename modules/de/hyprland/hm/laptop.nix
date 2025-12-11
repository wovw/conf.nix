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
''
  # https://wiki.hyprland.org/Configuring/Monitors/
  monitor=${INTERNAL},preferred,0x0,1.25
  monitor=,preferred,auto,1

  # https://wiki.hyprland.org/Configuring/Binds/#switches
  bindl = , switch:on:Lid Switch,exec,pidof hyprlock || hyprlock -q
  bindl = , switch:on:Lid Switch,exec,hyprctl keyword monitor "${INTERNAL},disable"
  bindl = , switch:off:Lid Switch,exec,hyprctl keyword monitor "${INTERNAL},preferred,0x0,1.25"

  binde = , xf86MonBrightnessDown, exec, ${brightness} --dec
  binde = , xf86MonBrightnessUp, exec, ${brightness} --inc

  bind = $mainMod, P, exec, ${toggleMirror}
''
