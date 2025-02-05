{
  keyboardLayout,
  colors,
  host,
}:
with colors;
''
  cursor {
      no_hardware_cursors = true
  }

  general {
      gaps_in = 6
      gaps_out = 8
      border_size = 2

      resize_on_border = true

      col.active_border = rgb(${base08}) rgb(${base0C}) 45deg
      col.inactive_border = rgb(${base01})

      layout = dwindle
  }

  input {
      kb_layout = ${keyboardLayout}
      repeat_rate = 50
      repeat_delay = 300

      sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      numlock_by_default = true
      follow_mouse = 1
      float_switch_override_focus = 0
      accel_profile = flat

      touchpad {
          natural_scroll = true
          disable_while_typing = true
          scroll_factor = 0.8
          middle_button_emulation = true
      }
  }

  gestures {
      workspace_swipe = true
      workspace_swipe_fingers = 3
  }

  misc {
      disable_hyprland_logo = true
      disable_splash_rendering = true
      initial_workspace_tracking = 0
      mouse_move_enables_dpms = true
      focus_on_activate = true
  }


  # Could help when scaling and not pixelating
  xwayland {
      force_zero_scaling = true
  }

  dwindle {
      pseudotile = yes
      preserve_split = yes
      special_scale_factor = 0.8
  }

  master {
      new_on_top = 1
      mfact = 0.5
  }

''
