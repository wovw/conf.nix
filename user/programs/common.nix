{
  pkgs,
  gitUsername,
  gitEmail,
  ...
}:
{
  programs = {
    home-manager.enable = true;
    btop = {
      enable = true;
      package = pkgs.btop.override { cudaSupport = true; };
      settings = {
        vim_keys = true;
        clock_format = "";
        show_battery = false;
        presets = "cpu:0:default,mem:0:default,net:0:default";
      };
    };
    git = {
      enable = true;
      userName = gitUsername;
      userEmail = gitEmail;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
        user.name = gitUsername;
        user.email = gitEmail;
      };
    };
  };
}
