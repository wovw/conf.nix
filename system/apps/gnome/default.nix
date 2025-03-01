{ ... }@args:
{
  programs.dconf.enable = true;
  imports = [
    (import ./nautilus.nix (args))
  ];

  security.pam.services.login.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
}
