{
lib,
host,
config,
pkgs,
...
}:

let
    inherit (import ../../hosts/${host}/variables.nix)
    terminal
    keyboardLayout;
in
    with lib;
{
    wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = true;
        extraConfig =
            let
                modifier = "SUPER";
            in
                concatStrings [
                    ''
                        ${builtins.readFile ./env.conf}
                        ${(import ./laptop.nix {
                            inherit pkgs;
                            inherit modifier;
                        })}
                        ${builtins.readFile ./startup.conf}


general {
gaps_in = 6
gaps_out = 8
border_size = 2
layout = dwindle
resize_on_border = true
col.active_border = rgb(${config.stylix.base16Scheme.base08}) rgb(${config.stylix.base16Scheme.base0C}) 45deg
col.inactive_border = rgb(${config.stylix.base16Scheme.base01})
}
input {
kb_layout = ${keyboardLayout}
follow_mouse = 1
touchpad {
natural_scroll = true
disable_while_typing = true
scroll_factor = 0.8
}
sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
accel_profile = flat
}
windowrule = noborder,^(wofi)$
windowrule = center,^(wofi)$
windowrule = center,^(steam)$
windowrule = float, nm-connection-editor|blueman-manager
windowrule = float, swayimg|vlc|Viewnior|pavucontrol
windowrule = float, nwg-look|qt5ct|mpv
windowrule = float, zoom
windowrulev2 = stayfocused, title:^()$,class:^(steam)$
windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$
windowrulev2 = opacity 0.9 0.7, class:^(thunar)$

windowrulev2 = opacity 0.0 override, class:^(xwaylandvideobridge)$
windowrulev2 = noanim, class:^(xwaylandvideobridge)$
windowrulev2 = noinitialfocus, class:^(xwaylandvideobridge)$
windowrulev2 = maxsize 1 1, class:^(xwaylandvideobridge)$
windowrulev2 = noblur, class:^(xwaylandvideobridge)$

gestures {
        workspace_swipe = true
workspace_swipe_fingers = 3
}
misc {
disable_hyprland_logo = true
disable_splash_rendering = true
initial_workspace_tracking = 0
mouse_move_enables_dpms = true
key_press_enables_dpms = false
}
                        ${builtins.readFile ./decor.conf}
plugin {
hyprtrails {
}
}
dwindle {
pseudotile = true
preserve_split = true
}
bind = ${modifier},Return,exec,${terminal}
bind = ${modifier}SHIFT,Return,exec,rofi-launcher
bind = ${modifier},E,exec,emopicker9000
bind = ${modifier},S,exec,screenshootin
bind = ${modifier},C,exec,hyprpicker -a
bind = ${modifier},T,exec,thunar
bind = ${modifier},Q,killactive,
bind = ${modifier}SHIFT,I,togglesplit,
bind = ${modifier},F,fullscreen,
bind = ${modifier}SHIFT,F,togglefloating,
bind = ${modifier}SHIFT,C,exit,
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
      bind = ${modifier}SHIFT,SPACE,movetoworkspace,special
  bind = ${modifier},SPACE,togglespecialworkspace
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
bind = ${modifier}CONTROL,right,workspace,e+1
bind = ${modifier}CONTROL,left,workspace,e-1
bind = ${modifier},mouse_down,workspace, e+1
bind = ${modifier},mouse_up,workspace, e-1
bindm = ${modifier},mouse:272,movewindow
bindm = ${modifier},mouse:273,resizewindow
bind = ALT,Tab,cyclenext
bind = ALT,Tab,bringactivetotop
bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bind = ,XF86AudioPlay, exec, playerctl play-pause
bind = ,XF86AudioPause, exec, playerctl play-pause
bind = ,XF86AudioNext, exec, playerctl next
bind = ,XF86AudioPrev, exec, playerctl previous
                    ''
                ];
    };
}
