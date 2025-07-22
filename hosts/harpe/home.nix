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
    (import ../../modules/hm/config.nix (args // { inherit gitUsername gitEmail; }))
    (import ../../modules/theme/hm.nix { inherit pkgs; })
    (import ../../modules/ssh/hm.nix { inherit host; })
    ../../modules/hm/devenv/default.nix
  ];
}
