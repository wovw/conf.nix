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
          "libvirt"
          "kvm"
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
          webcord
          rclone
          google-chrome
          qbittorrent
          spotify
          (callPackage ../../user/apps/xmcl.nix { })
          (callPackage ../../user/apps/lm-studio.nix { })
          yt-dlp
        ];
        openssh.authorizedKeys.keys = [ ];
      };
    };
  };
}
