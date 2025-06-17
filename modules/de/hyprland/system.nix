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
    kdePackages.xwaylandvideobridge

    normcap
    grim # wayland support for normcap

    wl-clipboard
    ifuse
    libimobiledevice
    cliphist
    hyprpicker
    hyprshot
    hyprland-qtutils
    wl-mirror
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
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
    # to make hyprland / hypridle work
    logind = {
      powerKeyLongPress = "poweroff";
      powerKey = "suspend";
      lidSwitch = "ignore";
    };
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
      "NetworkManager-wait-online".enable = false; # don't wait for network on startup
    };
  };

  # ddcutil
  hardware.i2c.enable = true;

  # Bluetooth Support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
}
