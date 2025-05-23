{ username, ... }:
{
  services.greetd = {
    enable = true;
    vt = 3;
    settings = {
      default_session = {
        user = username;
        # start Hyprland without login
        command = "uwsm start hyprland-uwsm.desktop";
      };
    };
  };

  imports = [
    ./user.nix
  ];
}
