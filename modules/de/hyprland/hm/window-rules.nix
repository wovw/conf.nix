{
  wayland.windowManager.hyprland.settings = {
    
    # Assign specific workspaces to monitors
    workspace = [
      "1, monitor:$EXTERNAL"
      "2, monitor:$EXTERNAL"
    ];

    windowrulev2 = [
      #  Idle Inhibit
      "idleinhibit fullscreen, class:^(.*)$"

      # Workspace Assignments
      "workspace 1, class:^(com.mitchellh.ghostty|cursor)$"
      "workspace 2, class:^(zen.*)$"
      "workspace 3, class:^(((google\\-)?chrome.*)|com.obsproject.Studio|xmcl|steam|net.lutris.Lutris|lunarclient|Lunar\\s+Client.*)$"
      "workspace 4, class:^([Ss]potify)$"
      "workspace 6 silent, class:^(virt-manager)$"

      # Floats
      "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
      "float, class:([Zz]oom|onedriver|onedriver-launcher)$"
      "float, class:([Tt]hunar), title:(File Operation Progress)"
      "float, class:([Tt]hunar), title:(Confirm to replace files)"
      "float, class:(xdg-desktop-portal-gtk)"
      "float, class:^([Rr]ofi)$"
      "float, class:^(eog|org.gnome.Loupe)$" # image viewer
      "float, class:^(org.gnome.Nautilus)$"
      "float, class:^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"
      "float, class:^(nwg-look|qt5ct|qt6ct)$"
      "float, class:^(mpv|com.github.rafostar.Clapper)$"
      "float, class:^(nm-applet|nm-connection-editor|.blueman-manager-wrapped)$"
      "float, class:^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" # system monitor
      "float, class:^([Yy]ad)$"
      "float, class:^(wihotspot(-gui)?)$" # wifi hotspot
      "float, class:^(file-roller|org.gnome.FileRoller)$" # archive manager
      "float, class:^([Bb]aobab|org.gnome.[Bb]aobab)$" # Disk usage analyzer
      "float, title:(Kvantum Manager)"
      "float, class:^([Qq]alculate-gtk)$"
      "float, class:^([Ff]erdium)$"
      "float, title:^(Picture-in-Picture)$"
      "float, title:^(Authentication Required)$"

      # Window Sizing
      "size 70% 70%, class:^(mpv)$"
      "size 70% 70%, class:^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"
      "size 70% 70%, class:^(nm-applet|nm-connection-editor|.blueman-manager-wrapped)$"
      "size 70% 70%, class:^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$"
      "size 70% 70%, class:^(xdg-desktop-portal-gtk)$"
      "size 60% 70%, title:(Kvantum Manager)"
      "size 60% 70%, class:^(qt6ct)$"
      "size 70% 70%, class:^(evince|wihotspot(-gui)?)$"
      "size 60% 70%, class:^(file-roller|org.gnome.FileRoller)$"
      "size 60% 70%, class:^([Ff]erdium)$"
      "size 25% 25%, title:^(Picture-in-Picture)$"

      # Pinning
      "pin, title:^(Picture-in-Picture)$"
    ];
  };
}
