{ config, ... }:
{
  xdg.configFile."uwsm/env".text = ''
    # hyprland
    export SDL_VIDEODRIVER=wayland
    export CLUTTER_BACKEND=wayland
    export GDK_DISABLE=vulkan
    export GDK_BACKEND=wayland,x11,*
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_QPA_PLATFORM=wayland;xcb
    export QT_QPA_PLATFORMTHEME=qt5ct
    export QT_QPA_PLATFORMTHEME=qt6ct
    export QT_SCALE_FACTOR=1
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=Hyprland

    # electron >28 apps (may help)
    export ELECTRON_OZONE_PLATFORM_HINT=auto

    # nix
    export NIXOS_OZONE_WL=1
    export NIXPKGS_ALLOW_UNFREE=1

    # nvidia
    export LIBVA_DRIVER_NAME=nvidia
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export NVD_BACKEND=direct
    export __GL_VRR_ALLOWED=0
    export __GL_GSYNC_ALLOWED=1
  '';

  xdg.configFile."uwsm/env-hyprland".text = ''
    # hyprcursor
    export HYPRCURSOR_THEME=${config.stylix.cursor.name}
    export HYPRCURSOR_SIZE=${toString config.stylix.cursor.size}

    # hyprshot
    export HYPRSHOT_DIR=Pictures/Screenshots
  '';
}
