{ inputs, ... }:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];
  services.vicinae = {
    enable = true;
    autoStart = true;
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
