{
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
    ../../modules/hm/devenv/default.nix
    ../../modules/ssh/hm.nix
  ];
}
