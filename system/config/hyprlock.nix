{ ... }:
{
  security.pam = {
    services = {
      # use with user/de/lock.nix
      hyprlock = { };
    };
  };
}
