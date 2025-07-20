{ ... }:
{
  security.pam = {
    services = {
      hyprlock = { };
    };
  };

  services = {
    # to make hyprland / hypridle work
    logind = {
      powerKeyLongPress = "poweroff";
      powerKey = "suspend";
      lidSwitch = "ignore";
    };
  };
}
