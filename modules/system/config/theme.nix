{ pkgs, wallpaper }:
{
  stylix = {
    enable = true;
    image = wallpaper;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    polarity = "dark";
    cursor = {
      name = "Bibata-Original-Classic";
      package = pkgs.bibata-cursors;
      size = 16;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        desktop = 12;
        popups = 12;
      };
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
      material-icons
    ];
  };
}
