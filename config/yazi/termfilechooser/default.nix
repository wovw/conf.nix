{ pkgs, ... }:
let
  xdg-desktop-portal-termfilechooser = pkgs.callPackage ./package.nix { };
in
{
  xdg.portal = {
    enable = true;
    extraPortals = [
      xdg-desktop-portal-termfilechooser
    ];
    config.common = {
      "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
    };
    xdgOpenUsePortal = true;
  };
}
