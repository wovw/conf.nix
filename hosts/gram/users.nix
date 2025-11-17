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
          (callPackage ../../modules/hm/apps/xmcl.nix { })
          lunar-client
          qalculate-gtk
          code-cursor
          yaak
          yt-dlp
          gptfdisk
          zoom-us
          inputs.affinity-nix.packages.x86_64-linux.v3
        ];
        openssh.authorizedKeys.keys = [ ];
      };
    };
  };
}
