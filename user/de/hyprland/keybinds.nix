{
  pkgs,
  modifier,
  host,
  terminal,
}:
let
  rofi = pkgs.callPackage ../rofi/launcher.nix { };
  swaync = pkgs.callPackage ../swaync/launcher.nix { };
  wlogout = pkgs.callPackage ../wlogout/launcher.nix { };
  clipboard = pkgs.callPackage ../rofi/clipboard.nix { };
  screenshot = pkgs.callPackage ../screenshot/script.nix { };
in
''
  $mainMod=${modifier}

  bind = ${modifier}SHIFT,Return,exec,${rofi}/bin/rofi-launcher
  bind = ${modifier},Return,exec,${terminal}
  bind = ${modifier},T,exec,${terminal} -e yazi
  bind = ${modifier}, B, exec, pkill -SIGUSR1 waybar
  bind = ${modifier}SHIFT,N,exec, ${swaync}/bin/swaync-launcher

  bind = CTRL ALT, Delete, exec, hyprctl dispatch exit 0
  bind = ${modifier},Q,killactive,
  bind = ${modifier}SHIFT,Q, exec, kill $(hyprctl activewindow | grep -o 'pid: [0-9]*' | cut -d' ' -f2)
  bind = ${modifier},F,fullscreen,
  bind = ${modifier}SHIFT,F,togglefloating,
  bind = ${modifier}ALT,L, exec, pidof hyprlock || hyprlock -q
  bind = CTRL ALT, P, exec, ${wlogout}/bin/wlogout-launcher

  bind = ${modifier},E,exec,rofi -show emoji -modi emoji
  bind = ${modifier},V,exec,${clipboard}/bin/clip-manager
  bind = ${modifier}SHIFT,C,exec,hyprpicker -a

  # move windows
  bind = ${modifier}SHIFT,left,movewindow,l
  bind = ${modifier}SHIFT,right,movewindow,r
  bind = ${modifier}SHIFT,up,movewindow,u
  bind = ${modifier}SHIFT,down,movewindow,d
  bind = ${modifier}SHIFT,h,movewindow,l
  bind = ${modifier}SHIFT,l,movewindow,r
  bind = ${modifier}SHIFT,k,movewindow,u
  bind = ${modifier}SHIFT,j,movewindow,d

  bind = ${modifier},left,movefocus,l
  bind = ${modifier},right,movefocus,r
  bind = ${modifier},up,movefocus,u
  bind = ${modifier},down,movefocus,d
  bind = ${modifier},h,movefocus,l
  bind = ${modifier},l,movefocus,r
  bind = ${modifier},k,movefocus,u
  bind = ${modifier},j,movefocus,d

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
  bind = ${modifier}, Print,exec,${screenshot}/bin/screenshootin --now
  bind =${modifier} SHIFT, Print, exec,${screenshot}/bin/screenshootin --area
  bind = ${modifier} CTRL, Print, exec,  ${screenshot}/bin/screenshootin --in5 #screenshot in 5 secs
  bind = ${modifier} CTRL SHIFT, Print, exec, ${screenshot}/bin/screenshootin --in10 #screenshot in 10 secs
  bind = ALT, Print, exec, ${screenshot}/bin/screenshootin --active #take screenshot of active window
  bind = ${modifier} SHIFT, T, exec, normcap # text extract
  bind = ${modifier} SHIFT, S, exec, ${screenshot}/bin/screenshootin --swappy # another screenshot tool

  bind = SUPER ALT, S, exec, speech-to-text

  # Workspaces related
  bind = $mainMod, tab, workspace, m+1
  bind = $mainMod SHIFT, tab, workspace, m-1
  bind = $mainMod SHIFT, m, movecurrentworkspacetomonitor, +1

  # switch workspaces
  bind = ${modifier},1,workspace,1
  bind = ${modifier},2,workspace,2
  bind = ${modifier},3,workspace,3
  bind = ${modifier},4,workspace,4
  bind = ${modifier},5,workspace,5
  bind = ${modifier},6,workspace,6
  bind = ${modifier},7,workspace,7
  bind = ${modifier},8,workspace,8
  bind = ${modifier},9,workspace,9
  bind = ${modifier},0,workspace,10

  # special workspace
  bind = ${modifier}SHIFT,U,movetoworkspace,special
  bind = ${modifier},U,togglespecialworkspace

  # move active window to workspace
  bind = ${modifier}SHIFT,1,movetoworkspace,1
  bind = ${modifier}SHIFT,2,movetoworkspace,2
  bind = ${modifier}SHIFT,3,movetoworkspace,3
  bind = ${modifier}SHIFT,4,movetoworkspace,4
  bind = ${modifier}SHIFT,5,movetoworkspace,5
  bind = ${modifier}SHIFT,6,movetoworkspace,6
  bind = ${modifier}SHIFT,7,movetoworkspace,7
  bind = ${modifier}SHIFT,8,movetoworkspace,8
  bind = ${modifier}SHIFT,9,movetoworkspace,9
  bind = ${modifier}SHIFT,0,movetoworkspace,10

  # Scroll through existing workspaces with mainMod + scroll
  bind = $mainMod, mouse_down, workspace, e+1
  bind = $mainMod, mouse_up, workspace, e-1
  bind = $mainMod, period, workspace, e+1
  bind = $mainMod, comma, workspace, e-1

  # Move/resize windows with mainMod + LMB/RMB and dragging
  bindm = ${modifier},mouse:272,movewindow
  bindm = ${modifier},mouse:273,resizewindow
''
