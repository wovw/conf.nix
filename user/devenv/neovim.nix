{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    tree-sitter

    lua51Packages.lua
    lua51Packages.luarocks

    # nix formatting
    nixfmt-rfc-style
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
        lua51Packages.jsregexp # luasnip
        inputs.nil.packages.${system}.default
        imagemagick # jupyter image rendering
      ];
      extraLuaPackages = ps: [
        ps.magick # jupyter image rendering
      ];
      extraPython3Packages =
        # for jupyter
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
