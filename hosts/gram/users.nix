{
  pkgs,
  username,
  inputs,
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
        packages = with pkgs; [
          rclone
          google-chrome
          qbittorrent
          spotify
          lunar-client
          code-cursor
          yaak
          yt-dlp
          gptfdisk
          zoom-us
          inputs.xmcl.packages.${pkgs.stdenv.hostPlatform.system}.default
          inputs.affinity-nix.packages.${pkgs.stdenv.hostPlatform.system}.v3
        ];
        openssh.authorizedKeys.keys = [ ];
      };
    };
  };
  imports = [ ./scripts/sync-things.nix ];
}
