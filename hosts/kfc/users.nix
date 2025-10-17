{
  pkgs,
  username,
  ...
}:

let
  inherit (import ./variables.nix) gitUsername;
in
{
  services.userborn.enable = true;
  users = {
    mutableUsers = true;
    users = {
      # remote deployment
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIyaPm21KDiQAXbzoG0IS7KO8rwcrP2ZqwJjW6uvh29A wovw@gram"
      ];
      "${username}" = {
        homeMode = "755";
        isNormalUser = true;
        description = gitUsername;
        extraGroups = [
          "networkmanager"
          "wheel"
          "scanner"
          "lp"
          "input"
          "uinput"
          "i2c"
          "dialout"
        ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIyaPm21KDiQAXbzoG0IS7KO8rwcrP2ZqwJjW6uvh29A wovw@gram"
        ];
      };
    };
  };
}
