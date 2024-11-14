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
                        ${builtins.readFile ./decor.conf}
                        ${(import ./keybinds.nix {
                            inherit pkgs;
                            inherit modifier;
                            inherit host;
                        })}
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
plugin {
hyprtrails {
}
}
dwindle {
pseudotile = true
preserve_split = true
}
                    ''
                ];
    };
}
