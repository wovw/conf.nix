{
  config,
  ...
}:
{
  services.vicinae = {
    enable = true;
    autoStart = true;
    settings = {
      faviconService = "twenty"; # twenty | google | none
      font.size = config.stylix.fonts.sizes.applications;
      popToRootOnClose = false;
      rootSearch.searchFiles = false;
      window = {
        csd = true;
        rounding = 10;
      };
    };
  };
}
