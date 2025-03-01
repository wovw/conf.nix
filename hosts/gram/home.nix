{
  pkgs,
  ...
}@args:
let
  inherit (import ./variables.nix)
    gitUsername
    gitEmail
    wallpaper
    terminal
    keyboardLayout
    ;
  INTERNAL = "eDP-1";
  EXTERNAL = "HDMI-A-4";
in
{
  home.stateVersion = "23.11";

  # Import Program Configurations
  imports = [
    ../../user/config.nix
    (import ../../user/devenv/config.nix (args // { inherit terminal pkgs; }))
    (import ../../user/de/config.nix (
      args
      // {
        inherit
          terminal
          keyboardLayout
          wallpaper
          INTERNAL
          EXTERNAL
          ;
      }
    ))
    ../../user/de/lock.nix
    ../../user/apps/winapps/config.nix
    ../../user/apps/easyeffects/config.nix
    ../../user/apps/browser/zen.nix
    ../../user/apps/input-remapper.nix
    ../../user/apps/gimp.nix
    ../../user/programs/ssh.nix
    (import ../../user/programs/common.nix (args // { inherit gitUsername gitEmail; }))
  ];

  programs = {
    obs-studio.enable = true;
  };
}
