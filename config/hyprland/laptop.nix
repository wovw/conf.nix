{
  pkgs,
  modifier,
  INTERNAL,
  EXTERNAL,
}:
let
  brightness = pkgs.callPackage ../../scripts/brightness.nix { };
  toggleMirror = pkgs.callPackage ../../scripts/toggle-mirror.nix { inherit INTERNAL EXTERNAL; };
in
''
  # https://wiki.hyprland.org/Configuring/Monitors/
  monitor=${INTERNAL},preferred,0x0,1.25
  monitor=${EXTERNAL},preferred,auto-right,1

  # https://wiki.hyprland.org/Configuring/Binds/#switches
  bindl = , switch:Lid Switch, exec, pidof hyprlock || hyprlock
  bindl = , switch:on:Lid Switch,exec,hyprctl keyword monitor "${INTERNAL}, disable"
  bindl = , switch:off:Lid Switch,exec,hyprctl keyword monitor "${INTERNAL},preferred,0x0,1.25"

  binde = , xf86MonBrightnessDown, exec, ${brightness}/bin/brightness-control --dec
  binde = , xf86MonBrightnessUp, exec, ${brightness}/bin/brightness-control --inc

  # TODO: no waybar when extending
  bind = ${modifier}, P, exec, ${toggleMirror}/bin/toggle-mirror

  # `hyprctl devices`
  $Touchpad_Device=elan0412:00-04f3:3162-touchpad
  $TOUCHPAD_ENABLED = true
  device {
    name = $Touchpad_Device
    enabled = $TOUCHPAD_ENABLED
  }

''
