{
  pkgs,
  username,
  host,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    sccache
    nodejs_22
    pnpm
    python312
    zig
    uv
    go
    tokei
    repomix
    jdk23
    pscale
    (import ./scripts/tmux-sessionizer.nix { inherit pkgs; })
    (import ./scripts/rebuild.nix { inherit pkgs username host; })
  ];

  imports = [
    ./neovim.nix
    ./starship.nix
    ./yazi/default.nix
  ];

  home.sessionVariables = {
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";

    # Go
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";

    # nvim marksman
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = 1;
  };

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
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
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "fzf"
        ];
      };
      initContent =
        let
          zshConfig = ''
            # Source personal configurations if they exist
            if [ -f $HOME/.zshrc-personal ]; then
              source $HOME/.zshrc-personal
            fi

            eval "$(uv generate-shell-completion zsh)"
            eval "$(uvx --generate-shell-completion zsh)"

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
        lib.mkMerge [
          zshConfig
        ];
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
