{
  pkgs,
  ...
}@args:
let
  inherit (import ./variables.nix)
    gitUsername
    gitEmail
    terminal
    ;
  INTERNAL = "HDMI-1";
  EXTERNAL = "HDMI-A-4";
in
{
  home.stateVersion = "24.05";

  # Import Program Configurations
  imports = [
    (import ../../modules/hm/config.nix (args // { inherit gitUsername gitEmail; }))
    ../../modules/hm/devenv/default.nix
    (import ../../modules/de/hm.nix (
      args
      // {
        inherit
          pkgs
          terminal
          INTERNAL
          EXTERNAL
          ;
      }
    ))
    ../../modules/hm/apps/ghostty.nix
    ../../modules/hm/apps/browser/zen.nix
    ../../modules/ssh/hm.nix
  ];
}
