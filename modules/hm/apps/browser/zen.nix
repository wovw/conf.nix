# https://github.com/luisnquin/nixos-config/blob/main/home/modules/browser.nix
{ inputs, system, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  programs.zen-browser = {
    enable = true;
    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = false; # save webs for later reading
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
    };
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "zen";
    BROWSER = "zen";

    # firefox
    MOZ_ENABLE_WAYLAND = 1;
    MOZ_DISABLE_RDD_SANDBOX = 1;
  };

  xdg.mimeApps =
    let
      associations = builtins.listToAttrs (
        map
        (name: {
          inherit name;
          value =
            let
              zen-browser = inputs.zen-browser.packages.${system}.beta;
            in
              zen-browser.meta.desktopFile;
        })
        [
          "application/x-extension-shtml"
          "application/x-extension-xhtml"
          "application/x-extension-html"
          "application/x-extension-xht"
          "application/x-extension-htm"
          "x-scheme-handler/unknown"
          "x-scheme-handler/mailto"
          "x-scheme-handler/chrome"
          "x-scheme-handler/about"
          "x-scheme-handler/https"
          "x-scheme-handler/http"
          "application/xhtml+xml"
          "application/json"
          "application/pdf"
          "text/plain"
          "text/html"
          "image/*"
        ]
      );
    in
      {
      associations.added = associations;
      defaultApplications = associations;
    };

}
