{ inputs, ... }:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];
  services.vicinae = {
    enable = true;
    systemd.enable = true;
    settings = {
      faviconService = "twenty";
      popToRootOnClose = true;
      rootSearch.searchFiles = false;
      window = {
        csd = false;
      };
    };
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "vicinae server"
    ];
    bind = [
      "$mainMod, Space, exec, vicinae vicinae://toggle"
      "$mainMod, V, exec, vicinae vicinae://extensions/vicinae/clipboard/history"
    ];
    layerrule = [
      "blur on, ignore_alpha 0, match:namespace vicinae"
    ];
  };
}
