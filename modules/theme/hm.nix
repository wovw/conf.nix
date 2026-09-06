{
  pkgs,
  ...
}:
{
  stylix = {
    targets = {
      hyprland.enable = false;
      starship.enable = false;
      zen-browser.enable = false;
      neovim.enable = false;
    };
    icons = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      dark = "Adwaita";
    };
  };
  home.pointerCursor.enable = true;
}
