{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    tmux-sessionizer
  ];

  xdg.configFile."tms/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/conf.nix/modules/hm/devenv/tms/config.toml";

  programs = {
    zsh.initContent =
      let
        tmsKeybind = ''
          function session-widget() {
              # Preserve terminal context by using zsh's BUFFER
              BUFFER="tms"
              # Execute the command
              zle accept-line
          }
          zle -N session-widget
          bindkey '^f' session-widget
        '';
      in
      lib.mkMerge [
        tmsKeybind
      ];
    tmux.extraConfig =
      let
        tmsKeybind = ''
          bind-key -r f run-shell "tmux neww tms"
        '';
      in
      lib.mkMerge [
        tmsKeybind
      ];
  };
}
