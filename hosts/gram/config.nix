{
  config,
  pkgs,
  host,
  username,
  options,
  ...
}:
let
  inherit (import ./variables.nix) keyboardLayout wallpaper;
in
{
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/virtualization.nix
    # ../../config/yazi/termfilechooser/default.nix
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
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernelModules = [
      "v4l2loopback"
      "nvidia"
      "nvidia_drm"
      "nvidia_uvm"
      "nvidia_modeset"
      "uinput"
      "i2c-dev"
    ];
    extraModprobeConfig = ''
      options nvidia_drm modeset=1 fbdev=1
      options kvm_intel nested=1
    '';
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Bootloader.
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

  # Styling Options
  stylix = {
    enable = true;
    image = wallpaper;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    polarity = "dark";
    cursor = {
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        desktop = 12;
        popups = 12;
      };
    };
  };

  # Extra Module Options
  drivers.intel.enable = true;
  drivers.nvidia.enable = true;
  drivers.nvidia-prime.enable = true;

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = host;
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

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  programs = {
    nix-ld = {
      enable = true;
      # https://www.reddit.com/r/nixos/comments/1d7zvgu/nvim_cant_find_standard_library_headers/
      libraries = with pkgs; [
        stdenv.cc.cc

        # iphone
        libplist
        libimobiledevice
      ];
    };
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    xfconf.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
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
    libnotify
    wl-clipboard
    pciutils
    usbutils
    ffmpeg
    cowsay
    ripgrep
    fd
    bat
    pkg-config
    hyprpicker
    brightnessctl
    i2c-tools
    ddcutil
    swappy
    appimage-run
    networkmanagerapplet
    nmap
    playerctl
    nh
    nixfmt-rfc-style
    swww
    grim
    slurp
    swaynotificationcenter
    imv
    mpv
    gimp
    pavucontrol
    pulseaudio
    alsa-utils
    tree
    greetd.tuigreet
    glib
    fzf
    wev
    xwaylandvideobridge
    zip
    fastfetch
    normcap
    jq
    curl
    podman-compose
    clinfo
    vulkan-tools
    libimobiledevice
    ifuse
    exiftool
    lutris
  ];

  environment.sessionVariables = {
    # Rust
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
      material-icons
    ];
  };

  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
    config.common.default = "gtk";
  };

  # Services to start
  services = {
    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
    tzupdate.enable = true;
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          # Wayland Desktop Manager is installed only for this user via home-manager!
          user = username;
          # .wayland-session is a script generated by home-manager, which links to the current wayland compositor(sway/hyprland or others).
          # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config here.
          # command = "$HOME/.wayland-session"; # start a wayland session directly without a login manager
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland"; # start Hyprland with a TUI login manager
        };
      };
    };
    # to make hyprland / hypridle work
    logind = {
      powerKeyLongPress = "poweroff";
      powerKey = "suspend";
      lidSwitch = "ignore";
    };
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    flatpak.enable = true;
    printing = {
      enable = true;
      drivers = [
        # pkgs.hplipWithPlugin
      ];
    };
    gnome.gnome-keyring.enable = true;
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
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    upower.enable = true;
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };
    tailscale.enable = false;
  };
  systemd = {
    services.flatpak-repo = {
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        flatpak update
      '';
    };
    extraConfig = "DefaultLimitNOFILE=524288"; # https://wiki.nixos.org/wiki/Lutris
  };
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };

  # ddcutil
  hardware.i2c.enable = true;

  # Extra Logitech Support
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

  # Bluetooth Support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
  security.pam = {
    services = {
      hyprlock = { };
      login.enableGnomeKeyring = true;
    };
    loginLimits = [
      {
        # https://wiki.nixos.org/wiki/Lutris
        domain = "wovw";
        type = "hard";
        item = "nofile";
        value = "524288";
      }
    ];
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # OpenGL
  hardware.graphics = {
    enable = true;
  };

  console.keyMap = "${keyboardLayout}";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
