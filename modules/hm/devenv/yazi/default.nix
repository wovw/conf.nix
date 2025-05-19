{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    xdragon
  ];

  programs.yazi = {
    enable = true;

    settings = {
      manager = {
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
        sha256 = "sha256-XiEsykudwYmwSNDO41b5layP1DqVa89e6Emv9Qf0mz0=";
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
    flavors = {
      tokyo-night = ./flavors/tokyo-night.yazi;
    };
    theme = {
      flavor = {
        dark = "tokyo-night";
        light = "tokyo-night";
      };
    };

    initLua = ./init.lua;

    keymap = {
      manager.prepend_keymap = [
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
          run = "shell 'dragon -x -i -T \"%1\"'";
        }
      ];
    };
  };
}
