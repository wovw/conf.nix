{
  pkgs,
}:
{
  stylix = {
    targets = {
      waybar.enable = false;
      rofi.enable = false;
      hyprland.enable = false;
      tmux.enable = false;

      # https://github.com/nix-community/home-manager/issues/5175#issuecomment-2227203880
      neovim.enable = false;
      neovide.enable = false;

      starship.enable = false;
    };
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
    };
  };
}
