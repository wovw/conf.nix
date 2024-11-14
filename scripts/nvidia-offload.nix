{ pkgs }:

pkgs.writeShellScriptBin "nvidia-offload" ''
  export __NV_PRIME_RENDER_OFFLOAD=1
  export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
  export MOZ_DISABLE_RDD_SANDBOX=1
  export LIBVA_DRIVER_NAME=nvidia
  export GBM_BACKEND=nvidia-drm
  export __GLX_VENDOR_LIBRARY_NAME=nvidia
  export NVD_BACKEND,direct
  export __VK_LAYER_NV_optimus=NVIDIA_only
  exec "$@"
''
