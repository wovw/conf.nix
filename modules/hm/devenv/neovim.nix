{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      lazygit
      tree-sitter

      lua51Packages.lua
      lua51Packages.luarocks

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
        inputs.nil.packages.${system}.default
      ];
    };
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/conf.nix/modules/hm/devenv/nvim";
}
