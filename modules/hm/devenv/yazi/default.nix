{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    ripdrag
  ];

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    settings = {
      mgr = {
        show_hidden = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };

    plugins = {
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "master";
        sha256 = "sha256-YkDkMC2SJIfpKrt93W/v5R3wOrYcat7QTbPrWqIKXG8=";
      };
      smart-paste = ./plugins/smart-paste.yazi;
      arrow = ./plugins/arrow.yazi;
      wl-clipboard = pkgs.fetchFromGitHub {
        owner = "grappas";
        repo = "wl-clipboard.yazi";
        rev = "master";
        sha256 = "sha256-jlZgN93HjfK+7H27Ifk7fs0jJaIdnOyY1wKxHz1wX2c=";
      };
      folder-rules = ./plugins/folder-rules.yazi;
    };

    initLua = ./init.lua;

    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "Q" ];
          run = "quit";
          desc = "Quit the process";
        }
        {
          on = [ "q" ];
          run = "quit --no-cwd-file";
          desc = "Quit without outputting cwd-file";
        }
        {
          on = [
            "p"
          ];
          run = "plugin smart-paste";
          desc = "Past into the hovered directory or CWD";
        }
        {
          on = [
            "y"
          ];
          run = [
            ''
              shell 'for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list'
            ''
            "yank"
          ];
          desc = "Copy the hovered file or CWD to the clipboard";
        }
        {
          on = [
            "g"
            "r"
          ];
          run = ''
            shell 'ya emit cd "$(git rev-parse --show-toplevel)"'
          '';
          desc = "`cd` to root of current git repository";
        }
        {
          on = [ "k" ];
          run = "plugin arrow -1";
        }
        {
          on = [ "j" ];
          run = "plugin arrow 1";
        }
        {
          on = [ "<C-y>" ];
          run = "plugin wl-clipboard";
        }
        {
          on = [ "!" ];
          run = "shell '$SHELL --block'";
          desc = "Open shell here";
        }
        {
          on = [ "<C-n>" ];
          run = "shell 'ripdrag \"$@\" -x 2>/dev/null &' --confirm";
        }
      ];
    };
  };
}
