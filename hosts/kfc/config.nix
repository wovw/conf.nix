{
  pkgs,
  options,
  ...
}@args:
let
  inherit (import ./variables.nix) keyboardLayout wallpaper;
in
{
  imports = [
    ./hardware.nix
    ./users.nix
    ../../system/hardware/amd-drivers.nix
    (import ../../system/config/common.nix (args // { inherit keyboardLayout; }))
    (import ../../system/config/theme.nix (args // { inherit wallpaper; }))
    ../../system/config/nix.nix
    ../../system/config/programs.nix
    ../../system/config/de.nix
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
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
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

  programs = {
    # thunar settings
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    xfconf.enable = true;
  };

  environment.systemPackages = with pkgs; [
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
    gvfs.enable = true;
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
  system.stateVersion = "23.11"; # Did you read the comment?
}
