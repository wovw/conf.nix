{ ... }:
{
  security.pam = {
    services = {
      hyprlock = { };
    };
  };

  services = {
    # to make hyprland / hypridle work
    logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandlePowerKeyLongPress = "poweroff";
      HandlePowerKey = "suspend";
    };
  };
}
