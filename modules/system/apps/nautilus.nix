{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      nautilus
      libheif
      libheif.out
      ntfs3g
      dislocker
    ];
    pathsToLink = [ "/share/thumbnailers" ];
  };
  programs.nautilus-open-any-terminal.enable = true;
  services = {
    gnome.sushi.enable = true;
    gvfs.enable = true;
  };
}
