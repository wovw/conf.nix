# https://github.com/luisnquin/nixos-config/blob/main/home/modules/programs/browser/zen.nix
{
  inputs,
  system,
  pkgs,
  ...
}:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  programs.zen-browser = {
    enable = true;
    policies =
      let
        mkLockedAttrs = builtins.mapAttrs (
          _: value: {
            Value = value;
            Status = "locked";
          }
        );
      in
      {
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
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        Preferences = mkLockedAttrs {
          "browser.cache.disk.enable" = false;
          "browser.cache.memory.enable" = true;
          "browser.cache.memory.capacity" = 1000000; # 1 MB

          "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
          "browser.tabs.hoverPreview.enabled" = true;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.topsites.contile.enabled" = false;

          "privacy.resistFingerprinting" = true;
          "privacy.firstparty.isolate" = true;
          "network.cookie.cookieBehavior" = 5;
          "dom.battery.enabled" = false;

          "gfx.webrender.all" = true;
          "network.http.http3.enabled" = true;
        };
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
              zen-browser.meta.desktopFileName;
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
