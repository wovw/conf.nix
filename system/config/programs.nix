{ pkgs, ... }:
{
  programs = {
    nix-ld.enable = true;
    fuse.userAllowOther = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment.systemPackages = with pkgs; [
    pinentry-curses
    whois
    gnumake
    file
    vim
    killall
    eza
    git
    lolcat
    lxqt.lxqt-policykit
    unzip
    unrar
    pciutils
    usbutils
    ffmpeg
    cowsay
    ripgrep
    fd
    bat
    pkg-config
    nmap
    nh
    gimp
    tree
    glib
    fzf
    zip
    fastfetch
    jq
    curl
    podman-compose
    exiftool
  ];

  services = {
    tzupdate.enable = true;
    upower.enable = true;
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };
  };

}
