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
    ../../user/config.nix
    (import ../../user/devenv/config.nix (args // { inherit terminal pkgs; }))
    ../../user/programs/ssh.nix
    (import ../../user/programs/common.nix (args // { inherit gitUsername gitEmail; }))
  ];
}
