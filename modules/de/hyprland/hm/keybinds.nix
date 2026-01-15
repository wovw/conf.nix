{
  pkgs,
  terminal,
}:
let
  wlogout = "${pkgs.callPackage ../../wlogout/launcher.nix { }}/bin/wlogout-launcher";
in
{
  wayland.windowManager.hyprland.settings = {
    # Mouse binds
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # Repeating binds
    binde = [
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ];

    # Main Keybinds
    bind = [
      # --- Applications ---
      "$mainMod, Return, exec, ${terminal}"
      "$mainMod, B, exec, pidof waybar >/dev/null && pkill -SIGUSR1 waybar || waybar &"
      "$mainMod SHIFT, N, exec, swaync-client -t -sw"
      "$mainMod ALT, L, exec, pidof hyprlock || hyprlock -q"
      "CTRL ALT, P, exec, ${wlogout}"
      "$mainMod SHIFT, C, exec, hyprpicker -a"
      "CTRL ALT, Delete, exec, hyprctl dispatch exit 0"

      # --- Window Management ---
      "$mainMod, Q, killactive,"
      "$mainMod SHIFT, Q, exec, kill $(hyprctl activewindow | grep -o 'pid: [0-9]*' | cut -d' ' -f2)"
      "$mainMod, F, fullscreen,"
      "$mainMod SHIFT, F, togglefloating,"

      # Cycle windows (Floating bring to top)
      "ALT, tab, cyclenext"
      "ALT, tab, alterzorder, top"

      # --- Focus (Vim Style) ---
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
      "$mainMod, h, movefocus, l"
      "$mainMod, l, movefocus, r"
      "$mainMod, k, movefocus, u"
      "$mainMod, j, movefocus, d"

      # --- Move Windows (Vim Style) ---
      "$mainMod SHIFT, left, movewindow, l"
      "$mainMod SHIFT, right, movewindow, r"
      "$mainMod SHIFT, up, movewindow, u"
      "$mainMod SHIFT, down, movewindow, d"
      "$mainMod SHIFT, h, movewindow, l"
      "$mainMod SHIFT, l, movewindow, r"
      "$mainMod SHIFT, k, movewindow, u"
      "$mainMod SHIFT, j, movewindow, d"

      # --- Media & Hardware ---
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioPlayPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioStop, exec, playerctl stop"

      # --- Screenshots & Tools ---
      "$mainMod, S, exec, hyprshot -m window"
      "$mainMod SHIFT, S, exec, hyprshot -m region --clipboard-only"
      ", Print, exec, hyprshot -m output"
      "$mainMod SHIFT, T, exec, normcap" # text extract
      "$mainMod, D, exec, wayscriber --active" # draw on screen

      # --- Workspace Navigation ---
      "$mainMod, tab, workspace, m+1"
      "$mainMod SHIFT, tab, workspace, m-1"
      "$mainMod SHIFT, m, movecurrentworkspacetomonitor, +1"
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
      "$mainMod, period, workspace, e+1"
      "$mainMod, comma, workspace, e-1"

      # --- Special Workspaces ---
      "$mainMod SHIFT, U, movetoworkspace, special"
      "$mainMod, U, togglespecialworkspace"
    ]
    ++ (
      # Binds $mainMod + {1..9, 0} to workspace {1..10}
      builtins.concatLists (
        builtins.genList (
          x:
          let
            ws =
              let
                c = (x + 1) / 10;
              in
              builtins.toString (x + 1 - (c * 10));
          in
          [
            "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
            "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        ) 10
      )
    );
  };
}
