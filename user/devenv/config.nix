{
  pkgs,
  terminal,
  username,
  host,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    sccache
    nodejs_22
    python312
    uv
    go
    tokei
    repomix
    jdk23
    code-cursor
    yaak
    mysql-workbench
    pgadmin4
    pscale
    (import ./bin/tmux-sessionizer.nix { inherit pkgs; })
    (import ./bin/rebuild.nix { inherit pkgs username host; })
  ];

  imports = [
    ./ghostty.nix
    ./neovim.nix
    ./starship.nix
    ./yazi/yazi.nix
  ];

  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
    TERMINAL = "${terminal}";
    TERMCMD = "${terminal}";

    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";

    # Go
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";

    # nvim marksman
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = 1;
  };

  programs = {
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
            rev = "master";
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
      initContent = let
        zshConfigEarlyInit = lib.mkBefore ''
        # autoenv config
        AUTOENV_ENV_FILENAME=".envrc"
        AUTOENV_ASSUME_YES=true
        '';
        zshConfig =''
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

      in
        lib.mkMerge [ zshConfigEarlyInit zshConfig ];
      shellAliases = {
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
        catppuccin
        yank
        pain-control
      ];

      extraConfig = ''
        # Terminal overrides
        set -g terminal-overrides ",xterm-ghostty:RGB"

        # yazi
        set -g allow-passthrough on
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM

        # image.nvim
        set -g visual-activity off

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

        # catppuccin plugin
        set -g @catppuccin_flavor "mocha"
        set -g status-left ""
        set -g status-right "#{E:@catppuccin_status_application}"
        set -ag status-right "#{E:@catppuccin_status_session}"
      '';
    };
  };
}
