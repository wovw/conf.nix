{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    vt = 3;
    settings = {
      default_session = {
        user = "greeter";
        # start Hyprland with a TUI login manager
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -t -r -c 'uwsm start hyprland-uwsm.desktop'";
      };
    };
  };

  imports = [
    ./user.nix
  ];
}
