{ ... }:
{
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
      extraConfig = ''
        set runtimepath^=${./lua}
      '';
    };
  };

  # Ensure the Lua modules are copied to the appropriate location
  xdg.configFile = {
    "nvim/lua".source = ./lua;
  };
}
