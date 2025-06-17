{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.amdgpu;
in
{
  options.drivers.amdgpu = {
    enable = mkEnableOption "Enable AMD Drivers";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics = {
      extraPackages = with pkgs; [
        rocmPackages.clr.icd # OpenCL support
        amdvlk # Vulkan support
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };

    nixpkgs.config.packageOverrides = pkgs: {
      btop = pkgs.btop.override { rocmSupport = true; };
      obs-studio = pkgs.obs-studio.override { rocmSupport = true; };
    };

    # Force radv
    environment.variables.AMD_VULKAN_ICD = "RADV";
  };
}
