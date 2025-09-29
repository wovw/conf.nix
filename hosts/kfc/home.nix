{
  pkgs,
  host,
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
    ../../modules/hm/config.nix
    (import ../../modules/theme/hm.nix { inherit pkgs; })
    (import ../../modules/hm/devenv/default.nix (args // { inherit gitUsername gitEmail; }))
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
    ../../modules/hm/apps/browser/zen.nix
    (import ../../modules/ssh/hm.nix { inherit host; })
  ];
}
