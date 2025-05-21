{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    tree-sitter

    # build avante
    gnumake
    gcc

    lua51Packages.lua
    lua51Packages.luarocks

    nixfmt-rfc-style # nix formatting
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
        python312Packages.pylatexenc # markdown preview
        lua51Packages.jsregexp # luasnip
        inputs.nil.packages.${system}.default

        # snacks.image
        imagemagick
        ghostscript # gs
        tectonic
        mermaid-cli # mmdc
      ];
    };
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/conf.nix/modules/hm/devenv/nvim";
}
