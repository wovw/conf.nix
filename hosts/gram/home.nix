{
  ...
}@args:
let
  inherit (import ./variables.nix)
    gitUsername
    gitEmail
    terminal
    ;
  INTERNAL = "eDP-1";
  EXTERNAL = "HDMI-A-4";
in
{
  home.stateVersion = "23.11";

  # Import Program Configurations
  imports = [
    (import ../../modules/hm/config.nix (args // { inherit gitUsername gitEmail; }))
    ../../modules/hm/devenv/default.nix
    (import ../../modules/de/hm.nix (
      args
      // {
        inherit
          terminal
          INTERNAL
          EXTERNAL
          ;
      }
    ))
    ../../modules/hm/apps/ghostty.nix
    ../../modules/hm/apps/winapps/default.nix
    ../../modules/hm/apps/easyeffects/config.nix
    ../../modules/hm/apps/browser/zen.nix
    ../../modules/hm/apps/input-remapper.nix
    ../../modules/hm/apps/gimp.nix
    ../../modules/ssh/hm.nix
    ../../modules/obs/hm.nix
  ];
}
