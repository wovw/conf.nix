{ pkgs, ... }:
{
  users = {
    groups.greeter = { };
    users = {
      # user for greetd
      "greeter" = {
        isSystemUser = true;
        group = "greeter"; # Dedicated group for isolated login manager
        shell = "${pkgs.shadow}/bin/nologin"; # Prevent interactive login
      };
    };
  };
}
