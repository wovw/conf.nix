{ pkgs, ... }:
{
  programs.dconf.enable = true;
  imports = [
    (import ./nautilus.nix ({ inherit pkgs; }))
  ];

  security.pam.services.login.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [
    seahorse
  ];
}
