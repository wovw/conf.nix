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
    groups.greeter = { };
    mutableUsers = true;
    users = {
      # user for greetd
      "greeter" = {
        isSystemUser = true;
        group = "greeter"; # Dedicated group for isolated login manager
        shell = "${pkgs.shadow}/bin/nologin"; # Prevent interactive login
      };
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
          "podman"
        ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        packages = with pkgs; [
          rclone
          google-chrome
          qbittorrent
          spotify
          (callPackage ../../user/apps/xmcl.nix { })
          (callPackage ../../user/apps/lm-studio.nix { })
          (callPackage ../../user/apps/lunar.nix { })
          yt-dlp
          qalculate-gtk
        ];
        openssh.authorizedKeys.keys = [ ];
      };
    };
  };
}
