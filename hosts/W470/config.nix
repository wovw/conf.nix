# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  lib,
  pkgs,
  ...
}:
let
  inherit (import ./variables.nix) keyboardLayout;
in
{
  imports = [
    ./users.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
      sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    polarity = "dark";
    cursor = {
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
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
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    whois
    file
    gnumake
    vim
    wget
    killall
    eza
    git
    cmatrix
    lolcat
    lxqt.lxqt-policykit
    lm_sensors
    unzip
    unrar
    libnotify
    v4l-utils
    ydotool
    duf
    ncdu
    wl-clipboard
    pciutils
    ffmpeg
    socat
    cowsay
    ripgrep
    fd
    lshw
    bat
    pkg-config
    meson
    hyprpicker
    ninja
    nh
    nixfmt-rfc-style
    tree
    fzf
    zip
    fastfetch
    jq
    curl
  ];

  environment.sessionVariables = {
    # Rust
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";

    # Go
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";

    # nvim marksman
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = 1;

  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
      material-icons
    ];
  };

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
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
