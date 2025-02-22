{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    libnotify
    wl-clipboard
    hyprpicker
    brightnessctl
    i2c-tools
    ddcutil
    pavucontrol
    pulseaudio
    alsa-utils
    swappy
    swww
    grim
    slurp
    swaynotificationcenter
    wev
    xwaylandvideobridge
    normcap
    ifuse
    libimobiledevice
  ];

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
    config = {
      common.default = "gtk";
      hyprland = {
        default = [
          "gtk"
          "hyprland"
        ];
      };
    };
  };

  # Services to start
  services = {
    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
    # to make hyprland / hypridle work
    logind = {
      powerKeyLongPress = "poweroff";
      powerKey = "suspend";
      lidSwitch = "ignore";
    };
    gnome.gnome-keyring.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
  systemd = {
    services = {
      usbmuxd.serviceConfig = {
        # fix shutdown hanging
        TimeoutStopSec = 5;
        KillMode = "mixed";
      };
    };
  };

  # ddcutil
  hardware.i2c.enable = true;

  # Bluetooth Support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
}
