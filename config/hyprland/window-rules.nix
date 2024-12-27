{ INTERNAL, EXTERNAL }:
''
  # windowrule v2 to avoid idle for fullscreen apps
  windowrulev2 = idleinhibit fullscreen, class:^(*)$
  windowrulev2 = idleinhibit fullscreen, title:^(*)$
  windowrulev2 = idleinhibit fullscreen, fullscreen:1

  # workspace rules
  workspace = 1, monitor:${EXTERNAL}
  workspace = 2, monitor:${INTERNAL}
  workspace = 3, monitor:${INTERNAL}
  workspace = 4, monitor:${INTERNAL}
  workspace = 5, monitor:${INTERNAL}

  # windowrule v2 move to workspace
  windowrulev2 = workspace 1, class:^([Tt]hunderbird|com.mitchellh.ghostty)$
  windowrulev2 = workspace 2, class:^(zen-beta)$
  windowrulev2 = workspace 3, class:^([Dd]iscord|[Ww]ebCord|[Vv]esktop|[Ss]potify)$
  windowrulev2 = workspace 4, class:^(com.obsproject.Studio)$
  windowrulev2 = workspace 5, class:^([Ll]utris)$

  # windowrule v2 move to workspace (silent)
  windowrulev2 = workspace 6 silent, class:^(virt-manager)$

  # windowrule v2 - float
  windowrulev2 = float, class:^(org.kde.polkit-kde-authentication-agent-1)$
  windowrulev2 = float, class:([Zz]oom|onedriver|onedriver-launcher)$
  windowrulev2 = float, class:([Tt]hunar), title:(File Operation Progress)
  windowrulev2 = float, class:([Tt]hunar), title:(Confirm to replace files)
  windowrulev2 = float, class:(xdg-desktop-portal-gtk)
  windowrulev2 = float, class:(org.gnome.Calculator), title:(Calculator)
  windowrulev2 = float, class:^([Rr]ofi)$
  windowrulev2 = float, class:^(eog|org.gnome.Loupe)$ # image viewer
  windowrulev2 = float, class:^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$
  windowrulev2 = float, class:^(nwg-look|qt5ct|qt6ct)$
  windowrulev2 = float, class:^(mpv|com.github.rafostar.Clapper)$
  windowrulev2 = float, class:^(nm-applet|nm-connection-editor|blueman-manager)$
  windowrulev2 = float, class:^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$ # system monitor
  windowrulev2 = float, class:^([Yy]ad)$
  windowrulev2 = float, class:^(wihotspot(-gui)?)$ # wifi hotspot
  windowrulev2 = float, class:^(file-roller|org.gnome.FileRoller)$ # archive manager
  windowrulev2 = float, class:^([Bb]aobab|org.gnome.[Bb]aobab)$ # Disk usage analyzer
  windowrulev2 = float, title:(Kvantum Manager)
  windowrulev2 = float, class:^([Qq]alculate-gtk)$
  windowrulev2 = float, class:^([Ff]erdium)$
  windowrulev2 = float, title:^(Picture-in-Picture)$

  # windowrule v2 - size
  windowrulev2 = size 70% 70%, class:^(mpv)$
  windowrulev2 = size 70% 70%, class:^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$
  windowrulev2 = size 70% 70%, class:^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$
  windowrulev2 = size 70% 70%, class:^(xdg-desktop-portal-gtk)$
  windowrulev2 = size 60% 70%, title:(Kvantum Manager)
  windowrulev2 = size 60% 70%, class:^(qt6ct)$
  windowrulev2 = size 70% 70%, class:^(evince|wihotspot(-gui)?)$
  windowrulev2 = size 60% 70%, class:^(file-roller|org.gnome.FileRoller)$
  windowrulev2 = size 60% 70%, class:^([Ff]erdium)$
  windowrulev2 = size 25% 25%, title:^(Picture-in-Picture)$

  # windowrule v2 - pinning
  windowrulev2 = pin,title:^(Picture-in-Picture)$

  # xwaylandvideobridge
  windowrulev2 = opacity 0.0 override, class:^(xwaylandvideobridge)$
  windowrulev2 = noanim, class:^(xwaylandvideobridge)$
  windowrulev2 = noinitialfocus, class:^(xwaylandvideobridge)$
  windowrulev2 = maxsize 1 1, class:^(xwaylandvideobridge)$
  windowrulev2 = noblur, class:^(xwaylandvideobridge)$

  # screenkey
  windowrulev2 = float,title:^(screenkey)$
  windowrulev2 = pin,title:^(screenkey)$
  windowrulev2 = size 15% 50,title:^(screenkey)$
  windowrulev2 = move onscreen 80% 20%,title:^(screenkey)$
  windowrulev2 = nodim,title:^(screenkey)$
  windowrulev2 = noblur,title:^(screenkey)$
  windowrulev2 = noshadow,title:^(screenkey)$

  # steam
  windowrule = center,^(steam)$
  windowrulev2 = stayfocused, title:^()$,class:^(steam)$
  windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$
  windowrulev2 = float, class:^([Ss]team)$,title:^((?![Ss]team).*|[Ss]team [Ss]ettings)$
''
