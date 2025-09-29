{
  pkgs,
  host,
  ...
}@args:
let
  inherit (import ./variables.nix) gitUsername gitEmail;
in
{
  # Home Manager Settings
  home.stateVersion = "24.05";

  # Import Program Configurations
  imports = [
    ../../modules/hm/config.nix
    (import ../../modules/theme/hm.nix { inherit pkgs; })
    (import ../../modules/hm/devenv/default.nix (args // { inherit gitUsername gitEmail; }))
    (import ../../modules/ssh/hm.nix { inherit host; })
  ];
}
