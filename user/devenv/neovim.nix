{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    lua51Packages.lua
    lua51Packages.luarocks
    nixfmt-rfc-style
    tree-sitter
  ];
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraPackages = with pkgs; [
        lua-language-server
        python312Packages.pylatexenc # for markdown preview
        python312Packages.jupytext
        lua51Packages.jsregexp
        inputs.nil.packages.${system}.default
        imagemagick
      ];
      extraLuaPackages = ps: [ ps.magick ];
      extraPython3Packages =
        ps: with ps; [
          pynvim
          jupyter-client
          cairosvg # for image rendering
          pnglatex # for image rendering
          plotly # for image rendering
          pyperclip
          nbformat
        ];
    };
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/conf.nix/user/devenv/nvim";
}
