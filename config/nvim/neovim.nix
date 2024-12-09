{ pkgs, ... }:
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
      extraLuaConfig = ''
        ${builtins.readFile ./init.lua}
      '';
      extraPackages = with pkgs; [
        lua-language-server
        python312Packages.pylatexenc # for markdown preview
        lua51Packages.jsregexp
      ];
    };
  };

  xdg.configFile = {
    # Ensure the Lua modules are copied to the appropriate location
    "nvim/lua".source = ./lua;
  };
}
