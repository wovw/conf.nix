{ inputs, system, ... }:
{
  home.packages = [
    inputs.zen-browser.packages."${system}".default
  ];
  home.sessionVariables = {
    DEFAULT_BROWSER = "zen";
    BROWSER = "zen";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
      "application/pdf" = "zen-beta.desktop";
    };
  };
}
