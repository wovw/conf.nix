{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];
  home.packages = with pkgs; [
    sops
  ];

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets.git_config = { };
  };
}
