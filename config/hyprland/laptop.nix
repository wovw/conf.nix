{ pkgs, modifier }:
let
  INTERNAL = "eDP-1";
  EXTERNAL = "HDMI-A-4";
  brightness = pkgs.callPackage ../../scripts/brightness.nix { inherit pkgs; };
  toggleMirror = pkgs.callPackage ../../scripts/toggle-mirror.nix { inherit pkgs; };
in
''
  # https://wiki.hyprland.org/Configuring/Monitors/
  monitor=${INTERNAL},preferred,0x0,1.25
  monitor=${EXTERNAL},preferred,auto-right,1

  binde = , xf86MonBrightnessDown, exec, ${brightness}/bin/brightness-control --dec
  binde = , xf86MonBrightnessUp, exec, ${brightness}/bin/brightness-control --inc

  # mirror vs extend, TODO: extend is being weird
  bind = ${modifier}, P, exec, ${toggleMirror}/bin/toggle-mirror

  # `hyprctl devices`
  $Touchpad_Device=elan0412:00-04f3:3162-touchpad
  $TOUCHPAD_ENABLED = true
  device {
    name = $Touchpad_Device
    enabled = $TOUCHPAD_ENABLED
  }

''
