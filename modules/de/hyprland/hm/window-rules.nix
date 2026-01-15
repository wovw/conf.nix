{
  wayland.windowManager.hyprland.settings = {

    # Assign specific workspaces to monitors
    workspace = [
      "1, monitor:$EXTERNAL"
      "2, monitor:$EXTERNAL"
    ];

    windowrule = [
      # Idle Inhibit
      {
        name = "inhibit-fullscreen-idle";
        match.class = "^(.*)$";
        match.fullscreen = true;
        idle_inhibit = "fullscreen";
      }

      # Workspace Assignments
      {
        name = "ghostty-cursor-workspace1";
        match.class = "^(com.mitchellh.ghostty|cursor)$";
        workspace = 1;
      }
      {
        name = "zen-workspace2";
        match.class = "^(zen.*)$";
        workspace = 2;
      }
      {
        name = "browsers-games-workspace3";
        match.class = "^(((google\\-)?chrome.*)|com.obsproject.Studio|xmcl|steam|net.lutris.Lutris|lunarclient|Lunar\\s+Client.*)$";
        workspace = 3;
      }
      {
        name = "spotify-workspace4";
        match.class = "^([Ss]potify)$";
        workspace = 4;
      }
      {
        name = "virt-manager-workspace6";
        match.class = "^(virt-manager)$";
        workspace = 6;
      }

      # Floats
      {
        name = "float-polkit";
        match.class = "^(org.kde.polkit-kde-authentication-agent-1)$";
        float = true;
      }
      {
        name = "float-zoom-onedrive";
        match.class = "([Zz]oom|onedriver|onedriver-launcher)";
        float = true;
      }
      {
        name = "float-thunar-operations";
        match.class = "([Tt]hunar)";
        match.title = "(File Operation Progress|Confirm to replace files)";
        float = true;
      }
      {
        name = "float-xdg-portal";
        match.class = "(xdg-desktop-portal-gtk)";
        float = true;
      }
      {
        name = "float-rofi";
        match.class = "^([Rr]ofi)$";
        float = true;
      }
      {
        name = "float-image-viewer";
        match.class = "^(eog|org.gnome.Loupe)$";
        float = true;
      }
      {
        name = "float-nautilus";
        match.class = "^(org.gnome.Nautilus)$";
        float = true;
      }
      {
        name = "float-pavucontrol";
        match.class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$";
        float = true;
      }
      {
        name = "float-theme-tools";
        match.class = "^(nwg-look|qt5ct|qt6ct)$";
        float = true;
      }
      {
        name = "float-media-player";
        match.class = "^(mpv|com.github.rafostar.Clapper)$";
        float = true;
      }
      {
        name = "float-network-tools";
        match.class = "^(nm-applet|nm-connection-editor|.blueman-manager-wrapped)$";
        float = true;
      }
      {
        name = "float-system-monitor";
        match.class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$";
        float = true;
      }
      {
        name = "float-yad";
        match.class = "^([Yy]ad)$";
        float = true;
      }
      {
        name = "float-wifi-hotspot";
        match.class = "^(wihotspot(-gui)?)$";
        float = true;
      }
      {
        name = "float-archive-manager";
        match.class = "^(file-roller|org.gnome.FileRoller)$";
        float = true;
      }
      {
        name = "float-baobab";
        match.class = "^([Bb]aobab|org.gnome.[Bb]aobab)$";
        float = true;
      }
      {
        name = "float-kvantum-manager";
        match.title = "(Kvantum Manager)";
        float = true;
      }
      {
        name = "float-qalculate";
        match.class = "^([Qq]alculate-gtk)$";
        float = true;
      }
      {
        name = "float-ferdium";
        match.class = "^([Ff]erdium)$";
        float = true;
      }
      {
        name = "float-pip";
        match.title = "^(Picture-in-Picture)$";
        float = true;
      }
      {
        name = "float-auth";
        match.title = "^(Authentication Required)$";
        float = true;
      }

      # Window Sizing
      {
        name = "size-mpv";
        match.class = "^(mpv)$";
        size = "70% 70%";
      }
      {
        name = "size-pavucontrol";
        match.class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$";
        size = "70% 70%";
      }
      {
        name = "size-network";
        match.class = "^(nm-applet|nm-connection-editor|.blueman-manager-wrapped)$";
        size = "70% 70%";
      }
      {
        name = "size-system-monitor";
        match.class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$";
        size = "70% 70%";
      }
      {
        name = "size-xdg-portal";
        match.class = "^(xdg-desktop-portal-gtk)$";
        size = "70% 70%";
      }
      {
        name = "size-kvantum";
        match.title = "(Kvantum Manager)";
        size = "60% 70%";
      }
      {
        name = "size-qt6ct";
        match.class = "^(qt6ct)$";
        size = "60% 70%";
      }
      {
        name = "size-document-tools";
        match.class = "^(evince|wihotspot(-gui)?)$";
        size = "70% 70%";
      }
      {
        name = "size-archive";
        match.class = "^(file-roller|org.gnome.FileRoller)$";
        size = "60% 70%";
      }
      {
        name = "size-ferdium";
        match.class = "^([Ff]erdium)$";
        size = "60% 70%";
      }
      {
        name = "size-pip";
        match.title = "^(Picture-in-Picture)$";
        size = "25% 25%";
      }

      # Pinning
      {
        name = "pin-pip";
        match.title = "^(Picture-in-Picture)$";
        pin = true;
      }
    ];
  };
}
