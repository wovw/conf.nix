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
}
