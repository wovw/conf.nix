{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        # start Hyprland with a TUI login manager
        command = "${pkgs.tuigreet}/bin/tuigreet -t -r -c 'uwsm start hyprland-uwsm.desktop'";
      };
    };
  };

  imports = [
    ./user.nix
  ];
}
