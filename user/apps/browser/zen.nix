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
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
      "application/pdf" = "zen.desktop";
    };
  };
}
