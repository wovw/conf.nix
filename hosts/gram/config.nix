{
  pkgs,
  username,
  options,
  ...
}@args:
let
  inherit (import ./variables.nix) keyboardLayout wallpaper terminal;
in
{
  imports = [
    ./hardware.nix
    ./users.nix
    ../../system/hardware/nvidia-drivers.nix
    ../../system/hardware/nvidia-prime-drivers.nix
    ../../system/hardware/intel-drivers.nix
    ../../system/config/virtualization.nix
    (import ../../system/config/common.nix (args // { inherit keyboardLayout; }))
    (import ../../system/config/theme.nix (args // { inherit wallpaper; }))
    ../../system/config/nix.nix
    ../../system/config/programs.nix
    ../../system/config/de/default.nix
    ../../system/config/de/greetd-login.nix
    ../../system/config/de/hyprlock.nix
    ../../system/apps/gaming.nix
    ../../system/apps/obs.nix
    (import ../../system/apps/gnome/default.nix (args // { inherit terminal; }))
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
      appimage-run
      networkmanagerapplet
      playerctl
      imv
      mpv
      clinfo
      vulkan-tools
      input-remapper
    ];
  };

  # Services to start
  services = {
    libinput.enable = true;
    input-remapper.enable = true;
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
