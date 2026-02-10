{ pkgs, ... }:
{
  imports = [
    ./lock/system.nix
  ];

  environment.systemPackages = with pkgs; [
    libnotify
    brightnessctl
    ddcutil
    i2c-tools
    pavucontrol
    pulseaudio
    alsa-utils
    swaynotificationcenter
    wev

    normcap
    grim # wayland support for normcap

    wl-clipboard
    ifuse
    libimobiledevice
    hyprpicker
    hyprshot
    hyprland-qtutils
    wl-mirror
    wayscriber
  ];

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    nix-ld = {
      libraries = with pkgs; [
        # for oklch-color-picker.nvim
        wayland
        libxkbcommon
        libGL
        libglvnd
      ];
    };
  };

  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  services = {
    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      # @see https://discourse.nixos.org/t/bluetooh-not-working/48430/3
      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
          monitor.bluez.properties = {
            bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
            bluez5.codecs = [ sbc sbc_xq aac ]
            bluez5.enable-sbc-xq = true
            bluez5.hfphsp-backend = "native"
          }
        '')
      ];
    };
  };

  # ddcutil
  hardware.i2c.enable = true;

  # Bluetooth Support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;
}
