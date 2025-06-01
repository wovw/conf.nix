{
  pkgs,
  options,
  ...
}@args:
let
  inherit (import ./variables.nix) wallpaper;
in
{
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/system/hardware/amd-drivers.nix
    ../../modules/system/config/common.nix
    (import ../../modules/system/config/theme.nix (args // { inherit wallpaper; }))
    ../../modules/system/config/nix.nix
    ../../modules/system/config/programs.nix
    ../../modules/system/config/resolved.nix
    ../../modules/de/hyprland/system.nix
    ../../modules/de/greetd/direct.nix
    ../../modules/ssh/system.nix
  ];

  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;
    kernelPatches = [
      {
        name = "Rust Support";
        patch = null;
        features = {
          rust = true;
        };
      }
    ];
    kernelModules = [
      "uinput"
      "i2c-dev"
    ];
    # Bootloader
    loader = {
      grub = {
        enable = true;
        device = "/dev/sdb";
        useOSProber = true;
      };
    };
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
  };

  # Extra Module Options
  drivers.amdgpu.enable = true;

  # Enable networking
  networking = {
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

    firewall.enable = true;
    # Open ports in the firewall.
    firewall.allowedTCPPorts = [
      25565 # mc lan
    ];
    firewall.allowedUDPPorts = [
      25565 # mc lan
    ];
  };

  environment.systemPackages = with pkgs; [
    gnumake
    networkmanagerapplet
    playerctl
    imv
    mpv
    clinfo
    vulkan-tools
  ];

  # Services to start
  services = {
    libinput.enable = true;
    fstrim.enable = true;
    printing = {
      enable = true;
      drivers = [
        # pkgs.hplipWithPlugin
      ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    tailscale.enable = false;
  };
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
