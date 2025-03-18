{ config, ... }:
''
  # hyprland
  env = SDL_VIDEODRIVER, x11
  env = EDITOR, nvim
  env = CLUTTER_BACKEND, wayland
  env = GDK_BACKEND, wayland, x11
  env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
  env = QT_QPA_PLATFORM=wayland;xcb
  env = QT_QPA_PLATFORMTHEME, qt5ct
  env = QT_QPA_PLATFORMTHEME, qt6ct
  env = QT_SCALE_FACTOR, 1
  env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
  env = XDG_CURRENT_DESKTOP, Hyprland
  env = XDG_SESSION_TYPE, Hyprland
  env = XDG_SESSION_DESKTOP, Hyprland

  # hyprcursor
  env = HYPRCURSOR_THEME,${config.stylix.cursor.name}
  env = HYPRCURSOR_SIZE,${toString config.stylix.cursor.size}

  # hyprshot
  env = HYPRSHOT_DIR, $XDG_PICTURES_DIR/Screenshots

  # firefox
  env = MOZ_ENABLE_WAYLAND,1
  env = MOZ_DISABLE_RDD_SANDBOX,1

  # electron >28 apps (may help)
  env = ELECTRON_OZONE_PLATFORM_HINT,auto

  # nix
  env = NIXOS_OZONE_WL, 1
  env = NIXPKGS_ALLOW_UNFREE, 1

  # nvidia
  env = LIBVA_DRIVER_NAME,nvidia
  env = __GLX_VENDOR_LIBRARY_NAME,nvidia
  env = NVD_BACKEND,direct
  # nvidia-offload
  # env = __NV_PRIME_RENDER_OFFLOAD,1
  # env = __NV_PRIME_RENDER_OFFLOAD_PROVIDER,NVIDIA-G0
  # env = __GLX_VENDOR_LIBRARY_NAME,nvidia
  # env = __VK_LAYER_NV_optimus,NVIDIA_only
''
