{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.nvidia-prime;
in
{
  options.drivers.nvidia-prime = {
    enable = mkEnableOption "Enable Nvidia Prime Hybrid GPU Offload";
    intelBusID = mkOption {
      type = types.str;
      default = "PCI:0:2:0";
    };
    nvidiaBusID = mkOption {
      type = types.str;
      default = "PCI:1:0:0";
    };
  };

  # https://wiki.nixos.org/wiki/NVIDIA
  config = mkIf cfg.enable {
    hardware.nvidia.prime = {
      # offload = {
      #   enable = true;
      #   enableOffloadCmd = true; # use with `nvidia-offload` command to start specific apps with dGPU
      # };
      reverseSync.enable = true;

      # lspci | grep -e VGA -e 3D
      intelBusId = "${cfg.intelBusID}";
      nvidiaBusId = "${cfg.nvidiaBusID}";
    };
  };
}
