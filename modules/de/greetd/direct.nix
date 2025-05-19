{ username, ... }:
{
  services.greetd = {
    enable = true;
    vt = 3;
    settings = {
      default_session = {
        user = username;
        command = "Hyprland"; # start a wayland session directly without a login manager
      };
    };
  };
}
