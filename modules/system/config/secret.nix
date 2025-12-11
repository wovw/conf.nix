{ pkgs, ... }:
{
  # https://wiki.nixos.org/wiki/Secret_Service#GNOME_Keyring
  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [
    seahorse
  ];
}
