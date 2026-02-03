{
  inputs,
  pkgs,
  lib,
  ...
}:
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
      launcher_window = {
        opacity = lib.mkForce 0.7;
      };
    };
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      it-tools
    ];
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
