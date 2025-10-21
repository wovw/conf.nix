{
  pkgs,
  username,
  options,
  ...
}:
let
  inherit (import ./variables.nix) wallpaper;
in
{
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/system/hardware/tools.nix
    ../../modules/system/hardware/nvidia-drivers.nix
    ../../modules/system/hardware/nvidia-prime-drivers.nix
    ../../modules/system/hardware/intel-drivers.nix
    ../../modules/system/hardware/ddcci.nix
    ../../modules/system/hardware/mouse.nix
    ../../modules/system/config/virtualization.nix
    ../../modules/system/config/common.nix
    (import ../../modules/theme/system.nix ({ inherit pkgs wallpaper; }))
    ../../modules/system/config/nix.nix
    ../../modules/system/config/programs.nix
    ../../modules/system/config/resolved.nix
    ../../modules/system/apps/obs.nix
    ../../modules/system/apps/gaming.nix
    ../../modules/system/apps/gnome/default.nix
    ../../modules/de/hyprland/system.nix
    ../../modules/de/greetd/login.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernelPatches = [
      {
        name = "Rust Support";
        patch = null;
        features = {
          rust = true;
        };
      }
    ];
    kernelParams = [
      "8250.nr_uarts=0" # disable unused legacy serial ports

      # https://wiki.nixos.org/wiki/Swap#Zswap_swap_cache
      "zswap.enabled=1" # enables zswap
      "zswap.compressor=lz4" # compression algorithm
      "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use
    ];
    kernelModules = [
      "uinput"
    ];
    # Bootloader
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };

  # Extra Module Options
  drivers.intel.enable = true;
  drivers.nvidia.enable = true;
  drivers.nvidia-prime.enable = true;
  hardware.ddcci.enable = true;

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
    nix-ld = {
      libraries = with pkgs; [
        libplist
        libimobiledevice
      ];
    };
    kdeconnect.enable = true;
  };

  environment = {
    etc = {
      "libinput/local-overrides.quirks".text = ''
        [Never Debounce]
        MatchUdevType=mouse
        ModelBouncingKeys=1
      '';
    };
    shells = [
      pkgs.zsh # add to /etc/shells
    ];
    systemPackages = with pkgs; [
      lz4 # for zswap
      appimage-run
      networkmanagerapplet
      playerctl
      imv
    ];
  };

  services = {
    scx.enable = true; # by default uses scx_rustland scheduler
    libinput.enable = true;
    fstrim.enable = true;
    flatpak.enable = true;
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
    syncthing = {
      enable = false;
      user = "${username}";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
    };
    tailscale.enable = false;
  };
  systemd = {
    services = {
      flatpak-repo = {
        path = [ pkgs.flatpak ];
        script = ''
          flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
          flatpak update
        '';
      };
    };
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
