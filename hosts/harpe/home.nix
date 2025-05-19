{
  pkgs,
  ...
}@args:
let
  inherit (import ./variables.nix { inherit pkgs; })
    gitUsername
    gitEmail
    terminal
    ;
in
{
  # Home Manager Settings
  home.stateVersion = "24.05";

  # Import Program Configurations
  imports = [
    (import ../../modules/hm/config.nix (args // { inherit gitUsername gitEmail; }))
    (import ../../modules/hm/devenv/default.nix (args // { inherit terminal pkgs; }))
    ../../modules/ssh/hm.nix
  ];
}
