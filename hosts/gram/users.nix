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
      "${username}" = {
        homeMode = "755";
        isNormalUser = true;
        description = gitUsername;
        extraGroups = [
          "networkmanager"
          "wheel"
          "kvm"
          "scanner"
          "lp"
          "input"
          "uinput"
          "i2c"
          "dialout"
          "podman"
        ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        packages = with pkgs; [
          rclone
          google-chrome
          qbittorrent
          spotify
          (callPackage ../../modules/hm/apps/xmcl.nix { })
          (callPackage ../../modules/hm/apps/lunar.nix { })
          qalculate-gtk
          code-cursor
          yaak
          yt-dlp
          gptfdisk
        ];
        openssh.authorizedKeys.keys = [ ];
      };
    };
  };
}
