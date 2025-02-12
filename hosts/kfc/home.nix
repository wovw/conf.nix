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
  INTERNAL = "HDMI-1";
  EXTERNAL = "HDMI-A-4";
in
{
  home.stateVersion = "24.05";

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
    ../../user/apps/browser/zen.nix
    ../../user/programs/ssh.nix
    (import ../../user/programs/common.nix (args // { inherit gitUsername gitEmail; }))
  ];
}
