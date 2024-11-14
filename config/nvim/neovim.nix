{ pkgs, ... }:
{
    home.packages = with pkgs; [
        lua5_1
        lua51Packages.luarocks
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
            ];
        };
    };

    xdg.configFile = {
        # Ensure the Lua modules are copied to the appropriate location
        "nvim/lua".source = ./lua;
    };
}
