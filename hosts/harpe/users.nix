{
  pkgs,
  username,
  ...
}:

let
  inherit (import ./variables.nix { inherit pkgs; }) gitUsername;
in
{
  services.userborn.enable = true;
  users = {
    mutableUsers = true;
    users = {
      "${username}" = {
        homeMode = "755";
        isNormalUser = true;
        description = gitUsername;
        extraGroups = [
          "wheel"
          "scanner"
          "kvm"
          "lp"
          "input"
          "uinput"
        ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        openssh.authorizedKeys.keys = [ ];
      };
    };
  };
}
