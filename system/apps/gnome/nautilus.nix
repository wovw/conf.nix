{ pkgs, terminal, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      nautilus
      libheif
      libheif.out
    ];
    pathsToLink = [ "/share/thumbnailers" ];
  };
  programs.nautilus-open-any-terminal = {
    enable = true;
    inherit terminal;
  };
  services = {
    gnome.sushi.enable = true;
    gvfs.enable = true;
  };
}
