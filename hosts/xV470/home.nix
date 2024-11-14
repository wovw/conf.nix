{
pkgs,
username,
host,
...
}:
let
  inherit (import ./variables.nix) gitUsername gitEmail;
in
  {
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Import Program Configurations
  imports = [
    ../../config/emoji.nix
    ../../config/fastfetch
    ../../config/hyprland.nix
    ../../config/neovim.nix
    ../../config/rofi/rofi.nix
    ../../config/rofi/config-emoji.nix
    ../../config/rofi/config-long.nix
    ../../config/swaync.nix
    ../../config/waybar.nix
    ../../config/wlogout.nix
    ../../config/ssh/ssh.nix
    ../../config/fastfetch
  ];

  # Place Files Inside Home Directory
  home.file."Pictures/Wallpapers" = {
    source = ../../config/wallpapers;
    recursive = true;
  };
  home.file.".config/wlogout/icons" = {
    source = ../../config/wlogout;
    recursive = true;
  };
  home.file.".face.icon".source = ../../config/face.jpg;
  home.file.".config/face.jpg".source = ../../config/face.jpg;
  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=Ubuntu
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';

  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };

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

  # Styling Options
  stylix.targets.waybar.enable = false;
  stylix.targets.rofi.enable = false;
  stylix.targets.hyprland.enable = false;
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
    (import ../../scripts/emopicker9000.nix { inherit pkgs; })
    (import ../../scripts/task-waybar.nix { inherit pkgs; })
    (import ../../scripts/squirtle.nix { inherit pkgs; })
    (import ../../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ../../scripts/wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ../../scripts/web-search.nix { inherit pkgs; })
    (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../scripts/screenshootin.nix { inherit pkgs; })
    (import ../../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
  ];

  services = {
    hypridle = {
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
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
    gh.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = {
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
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "fzf"
        ];
      };
      initExtra = ''
        # Initialize rustup
        if [ -f $HOME/.cargo/env ]; then
          source $HOME/.cargo/env
        fi

        # Initialize pnpm
        export PNPM_HOME="$HOME/.local/share/pnpm"
        export PATH="$PNPM_HOME:$PATH"

        # Source personal configurations if they exist
        if [ -f $HOME/.zshrc-personal ]; then
          source $HOME/.zshrc-personal
        fi
      '';
      shellAliases = {
        v = "nvim";
        sv = "sudo nvim";
        ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        cat = "bat";
        ls = "eza --icons";
        ll = "eza -lh --icons --group-directories-first";
        la = "eza -lah --icons --group-directories-first";
        ".." = "cd ..";
        c = "code";
      };
    };
    tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      mouse = true;
      prefix = "C-Space";
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
      set -ag terminal-overrides ",xterm-256color:RGB"

      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      # Set vi mode
      set-window-option -g mode-keys vi

      # Vim-style copy mode bindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Reload configuration
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # Additional custom settings can go here
      '';
    };
    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 10;
          hide_cursor = true;
          no_fade_in = false;
        };
        background = [
          {
            path = "/home/${username}/Pictures/Wallpapers/Rainnight.jpg";
            blur_passes = 3;
            blur_size = 8;
          }
        ];
        image = [
          {
            path = "/home/${username}/.config/face.jpg";
            size = 150;
            border_size = 4;
            border_color = "rgb(0C96F9)";
            rounding = -1; # Negative means circle
            position = "0, 200";
            halign = "center";
            valign = "center";
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
    starship = {
      enable = true;
      settings = {
        aws = {
          format = "\\[[$symbol($profile)(\\($region\\))(\\[$duration\\])]($style)\\]";
        };
        bun = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        c = {
          format = "\\[[$symbol($version(-$name))]($style)\\]";
        };
        cmake = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        cmd_duration = {
          format = "\\[[⏱ $duration]($style)\\]";
        };
        cobol = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        conda = {
          format = "\\[[$symbol$environment]($style)\\]";
        };
        crystal = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        daml = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        dart = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        deno = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        docker_context = {
          format = "\\[[$symbol$context]($style)\\]";
        };
        dotnet = {
          format = "\\[[$symbol($version)(🎯 $tfm)]($style)\\]";
        };
        elixir = {
          format = "\\[[$symbol($version \\(OTP $otp_version\\))]($style)\\]";
        };
        elm = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        erlang = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        fennel = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        fossil_branch = {
          format = "\\[[$symbol$branch]($style)\\]";
        };
        gcloud = {
          format = "\\[[$symbol$account(@$domain)(\\($region\\))]($style)\\]";
        };
        git_branch = {
          format = "\\[[$symbol$branch]($style)\\]";
        };
        git_status = {
          format = "(\\[[$all_status$ahead_behind\\]]($style))";
        };
        golang = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        gradle = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        guix_shell = {
          format = "\\[[$symbol]($style)\\]";
        };
        haskell = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        haxe = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        helm = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        hg_branch = {
          format = "\\[[$symbol$branch]($style)\\]";
        };
        java = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        julia = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        kotlin = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        kubernetes = {
          format = "\\[[$symbol$context( \\($namespace\\))]($style)\\]";
        };
        lua = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        memory_usage = {
          format = "\\[$symbol[$ram( | $swap)]($style)\\]";
        };
        meson = {
          format = "\\[[$symbol$project]($style)\\]";
        };
        nim = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        nix_shell = {
          format = "\\[[$symbol$state( \\($name\\))]($style)\\]";
        };
        nodejs = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        ocaml = {
          format = "\\[[$symbol($version)(\\($switch_indicator$switch_name\\))]($style)\\]";
        };
        opa = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        openstack = {
          format = "\\[[$symbol$cloud(\\($project\\))]($style)\\]";
        };
        os = {
          format = "\\[[$symbol]($style)\\]";
        };
        package = {
          format = "\\[[$symbol$version]($style)\\]";
        };
        perl = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        php = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        pijul_channel = {
          format = "\\[[$symbol$channel]($style)\\]";
        };
        pulumi = {
          format = "\\[[$symbol$stack]($style)\\]";
        };
        purescript = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        python = {
          format = "\\[[$symbol$pyenv_prefix($version)(\\($virtualenv\\))]($style)\\]";
        };
        raku = {
          format = "\\[[$symbol($version-$vm_version)]($style)\\]";
        };
        red = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        ruby = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        rust = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        scala = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        spack = {
          format = "\\[[$symbol$environment]($style)\\]";
        };
        sudo = {
          format = "\\[[as $symbol]($style)\\]";
        };
        swift = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        terraform = {
          format = "\\[[$symbol$workspace]($style)\\]";
        };
        time = {
          format = "\\[[$time]($style)\\]";
        };
        username = {
          format = "\\[[$user]($style)\\]";
        };
        vagrant = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        vlang = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        zig = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
        solidity = {
          format = "\\[[$symbol($version)]($style)\\]";
        };
      };
    };
  };
}
