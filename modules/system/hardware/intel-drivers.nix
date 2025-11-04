{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.intel;
in
{
  options.drivers.intel = {
    enable = mkEnableOption "Enable Intel Graphics Drivers";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "modesetting" ]; # Intel graphics + work with Nvidia prime

    nixpkgs.config.packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    };

    # OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # https://wiki.nixos.org/wiki/Accelerated_Video_Playback#Intel
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
        intel-compute-runtime
        vpl-gpu-rt # or intel-media-sdk for QSV, https://wiki.nixos.org/wiki/Intel_Graphics#Quick_Sync_Video
      ];
    };
  };
}
