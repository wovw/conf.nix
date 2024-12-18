{
  pkgs,
  lib,
  username,
  host,
  ...
}@args:
let
  inherit (import ./variables.nix) gitUsername gitEmail wallpaper;
  INTERNAL = "eDP-1";
  EXTERNAL = "HDMI-A-4";
in
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Import Program Configurations
  imports = [
    ../../config/emoji.nix
    (import ../../config/hyprland/hyprland.nix (args // { inherit wallpaper INTERNAL EXTERNAL; }))
    ../../config/neovim.nix
    ../../config/rofi/rofi.nix
    ../../config/rofi/config-emoji.nix
    ../../config/rofi/config-long.nix
    ../../config/swaync/swaync.nix
    (import ../../config/waybar.nix (args // { inherit INTERNAL EXTERNAL; }))
    ../../config/wlogout/wlogout.nix
    ../../config/ssh.nix
    ../../config/starship.nix
  ];

  # Place Files Inside Home Directory
  home.file."Pictures/wallpapers" = {
    source = ../../config/wallpapers;
    recursive = true;
  };
  home.file.".config/wlogout/icons" = {
    source = ../../config/wlogout/icons;
    recursive = true;
  };
  home.file.".config/swaync/icons" = {
    source = ../../config/swaync/icons;
    recursive = true;
  };
  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    paint_mode=brush
    early_exit=false
    fill_shape=false
  '';
  home.file.".config/easyeffects/input/masc_voice_noise_reduction.json".text = ''${builtins.readFile ../../config/masc_voice_noise_reduction.json}'';

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  stylix.targets.waybar.enable = false;
  stylix.targets.rofi.enable = false;
  stylix.targets.hyprland.enable = false;
  stylix.targets.kitty.enable = false;
  stylix.targets.tmux.enable = false;
  stylix.targets.neovim.enable = false;
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme.name = "gtk3";
  };

  # Scripts
  home.packages = [
    (import ../../scripts/task-waybar.nix { inherit pkgs; })
    (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../scripts/wlogout-launcher.nix { inherit pkgs; })
    (import ../../scripts/tmux-sessionizer.nix { inherit pkgs; })
    (import ../../scripts/screenshootin.nix { inherit pkgs; })
    (import ../../scripts/clip-manager.nix { inherit pkgs; })
  ];

  home.sessionVariables = {
    DEFAULT_BROWSER = "zen";
    BROWSER = "zen";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # browser
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";

      # text
    };
  };

  services = {
    easyeffects = {
      enable = true;
      preset = "masc_voice_noise_reduction";
    };
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock -q";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock -q";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  programs = {
    home-manager.enable = true;
    btop = {
      enable = true;
      package = pkgs.btop.override { cudaSupport = true; };
      settings = {
        vim_keys = true;
        clock_format = "";
        show_battery = false;
        presets = "cpu:0:default,mem:0:default,net:0:default";
      };
    };
    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = {
        background_opacity = "0.60";
        background_blur = 1;
        font_size = 14;
        font_family = "JetBrainsMono Nerd Font Mono";
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold
      '';
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      history = {
        ignoreDups = true;
        ignoreAllDups = true;
        expireDuplicatesFirst = true;
      };
      plugins = [
        {
          name = "autoenv";
          src = pkgs.fetchFromGitHub {
            owner = "hyperupcall";
            repo = "autoenv";
            rev = "90241f182d6a7c96e9de8a25c1eccaf2a2d1b43a";
            sha256 = "sha256-vZrsMPhuu+xPVAww04nKyoOl7k0upvpIaxeMrCikDio=";
          };
        }
      ];
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "fzf"
          "autoenv"
        ];
      };
      initExtraFirst = ''
        # autoenv config
        AUTOENV_ENV_FILENAME=".envrc"
        AUTOENV_ASSUME_YES=true
      '';
      initExtra = ''
        # Source personal configurations if they exist
        if [ -f $HOME/.zshrc-personal ]; then
          source $HOME/.zshrc-personal
        fi

        eval "$(uv generate-shell-completion zsh)"
        eval "$(uvx --generate-shell-completion zsh)"

        function y() {
            local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
            yazi "$@" --cwd-file="$tmp"
            if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                builtin cd -- "$cwd"
            fi
            rm -f -- "$tmp"
        }

        function session-widget() {
            # Preserve terminal context by using zsh's BUFFER
            BUFFER="tmux-sessionizer"
            # Execute the command
            zle accept-line
        }
        zle -N session-widget
        bindkey '^f' session-widget
      '';
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake '/home/${username}/conf.nix?submodules=1#${host}'";
        v = "nvim";
        sv = "sudo nvim";
        ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        cat = "bat";
        ls = "eza --icons";
        ll = "eza -lh --icons --group-directories-first";
        la = "eza -lah --icons --group-directories-first";
        ".." = "cd ..";
      };
    };
    tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      mouse = true;
      prefix = "C-a";
      escapeTime = 0;
      baseIndex = 1;

      # Plugin management
      plugins = with pkgs.tmuxPlugins; [
        sensible
        vim-tmux-navigator
        catppuccin
        yank
      ];

      extraConfig = ''
        # Terminal overrides
        set -g default-terminal "tmux-256color"
        set -ag terminal-overrides ",xterm-kitty:RGB"

        # Shift Alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        # Set vi mode
        set-window-option -g mode-keys vi

        # Vim-style copy mode bindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        bind-key -r f run-shell "tmux neww tmux-sessionizer"
      '';
    };
    hyprlock = {
      enable = true;
      settings = lib.mkForce {
        general = {
          disable_loading_bar = true;
          grace = 0;
          hide_cursor = true;
          no_fade_in = false;
          ignore_empty_input = false;
        };
        background = [
          {
            path = "~/Pictures/wallpapers/Rainnight.jpg";
          }
        ];
        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(CFE6F4)";
            inner_color = "rgb(657DC2)";
            outer_color = "rgb(0D0E15)";
            outline_thickness = 5;
            placeholder_text = "Password...";
            shadow_passes = 2;
          }
        ];
      };
    };
    git = {
      enable = true;
      userName = gitUsername;
      userEmail = gitEmail;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
        user.name = gitUsername;
        user.email = gitEmail;
      };
    };
    obs-studio.enable = true;
  };
}
