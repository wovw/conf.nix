{
  pkgs,
  terminal,
}:
let
  swaync = "${pkgs.callPackage ../../swaync/launcher.nix { }}/bin/swaync-launcher";
  wlogout = "${pkgs.callPackage ../../wlogout/launcher.nix { }}/bin/wlogout-launcher";
in
''
  bind = $mainMod,Return,exec,${terminal}
  bind = $mainMod, B, exec, pidof waybar >/dev/null && pkill -SIGUSR1 waybar || waybar &
  bind = $mainMod SHIFT,N,exec, ${swaync}

  bind = CTRL ALT, Delete, exec, hyprctl dispatch exit 0
  bind = $mainMod,Q,killactive,
  bind = $mainMod SHIFT,Q, exec, kill $(hyprctl activewindow | grep -o 'pid: [0-9]*' | cut -d' ' -f2)
  bind = $mainMod,F,fullscreen,
  bind = $mainMod SHIFT,F,togglefloating,
  bind = $mainModALT,L, exec, pidof hyprlock || hyprlock -q
  bind = CTRL ALT, P, exec, ${wlogout}

  bind = $mainMod SHIFT,C,exec,hyprpicker -a

  # move windows
  bind = $mainMod SHIFT,left,movewindow,l
  bind = $mainMod SHIFT,right,movewindow,r
  bind = $mainMod SHIFT,up,movewindow,u
  bind = $mainMod SHIFT,down,movewindow,d
  bind = $mainMod SHIFT,h,movewindow,l
  bind = $mainMod SHIFT,l,movewindow,r
  bind = $mainMod SHIFT,k,movewindow,u
  bind = $mainMod SHIFT,j,movewindow,d

  bind = $mainMod,left,movefocus,l
  bind = $mainMod,right,movefocus,r
  bind = $mainMod,up,movefocus,u
  bind = $mainMod,down,movefocus,d
  bind = $mainMod,h,movefocus,l
  bind = $mainMod,l,movefocus,r
  bind = $mainMod,k,movefocus,u
  bind = $mainMod,j,movefocus,d

  # Cycle windows if floating bring to top
  bind = ALT, tab, cyclenext
  bind = ALT, tab, alterzorder, top

  # fn keys
  bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
  bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

  # media controls
  bind = ,XF86AudioPlayPause, exec, playerctl play-pause
  bind = ,XF86AudioPlay, exec, playerctl play-pause
  bind = ,XF86AudioPause, exec, playerctl play-pause
  bind = ,XF86AudioNext, exec, playerctl next
  bind = ,XF86AudioPrev, exec, playerctl previous
  bind = ,XF86AudioStop, exec, playerctl stop

  # screenshot bindings
  bind = $mainMod, S, exec, hyprshot -m window
  bind =$mainMod SHIFT, S, exec, hyprshot -m region --clipboard-only
  bind = , Print, exec, hyprshot -m output
  bind = $mainMod SHIFT, T, exec, normcap # text extract

  bind = SUPER ALT, S, exec, speech-to-text

  # Workspaces related
  bind = $mainMod, tab, workspace, m+1
  bind = $mainMod SHIFT, tab, workspace, m-1
  bind = $mainMod SHIFT, m, movecurrentworkspacetomonitor, +1

  # switch workspaces
  bind = $mainMod,1,workspace,1
  bind = $mainMod,2,workspace,2
  bind = $mainMod,3,workspace,3
  bind = $mainMod,4,workspace,4
  bind = $mainMod,5,workspace,5
  bind = $mainMod,6,workspace,6
  bind = $mainMod,7,workspace,7
  bind = $mainMod,8,workspace,8
  bind = $mainMod,9,workspace,9
  bind = $mainMod,0,workspace,10

  # special workspace
  bind = $mainMod SHIFT,U,movetoworkspace,special
  bind = $mainMod,U,togglespecialworkspace

  # move active window to workspace
  bind = $mainMod SHIFT,1,movetoworkspace,1
  bind = $mainMod SHIFT,2,movetoworkspace,2
  bind = $mainMod SHIFT,3,movetoworkspace,3
  bind = $mainMod SHIFT,4,movetoworkspace,4
  bind = $mainMod SHIFT,5,movetoworkspace,5
  bind = $mainMod SHIFT,6,movetoworkspace,6
  bind = $mainMod SHIFT,7,movetoworkspace,7
  bind = $mainMod SHIFT,8,movetoworkspace,8
  bind = $mainMod SHIFT,9,movetoworkspace,9
  bind = $mainMod SHIFT,0,movetoworkspace,10

  # Scroll through existing workspaces with mainMod + scroll
  bind = $mainMod, mouse_down, workspace, e+1
  bind = $mainMod, mouse_up, workspace, e-1
  bind = $mainMod, period, workspace, e+1
  bind = $mainMod, comma, workspace, e-1

  # Move/resize windows with mainMod + LMB/RMB and dragging
  bindm = $mainMod,mouse:272,movewindow
  bindm = $mainMod,mouse:273,resizewindow
''
