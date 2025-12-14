{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      clang # cc for nvim-treesitter
      tree-sitter

      lua51Packages.lua
      lua51Packages.luarocks

      statix
      nixfmt-rfc-style
    ];

    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };

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
        inputs.nil.packages.${pkgs.stdenv.hostPlatform.system}.default

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
