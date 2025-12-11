{
  pkgs,
  host,
  ...
}@args:
let
  inherit (import ./variables.nix) gitUsername;
in
{
  # Home Manager Settings
  home.stateVersion = "24.05";

  # Import Program Configurations
  imports = [
    ../../modules/hm/config.nix
    (import ../../modules/ssh/hm.nix { inherit host; })
    ../../modules/ssh/sops.nix
    (import ../../modules/theme/hm.nix { inherit pkgs; })
    (import ../../modules/hm/devenv/default.nix (args // { inherit gitUsername; }))
  ];
}
