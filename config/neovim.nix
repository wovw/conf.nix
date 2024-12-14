{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    lua51Packages.lua
    lua51Packages.luarocks
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
        lua51Packages.jsregexp
      ];
    };
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/config/nvim";
}
