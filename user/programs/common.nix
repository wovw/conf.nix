{
  gitUsername,
  gitEmail,
  ...
}:
{
  programs = {
    home-manager.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
        clock_format = "";
        show_battery = false;
        presets = "cpu:0:default,gpu0:0:default,mem:0:default,net:0:default";
      };
    };
    git = {
      enable = true;
      userName = gitUsername;
      userEmail = gitEmail;
      extraConfig = {
        user.name = gitUsername;
        user.email = gitEmail;

        # https://blog.gitbutler.com/how-git-core-devs-configure-git/

        column.ui = "auto";
        branch.sort = "-committerdate";
        tag.sort = "version:refname";
        init.defaultBranch = "main";
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = "true";
          renames = "true";
        };
        push = {
          autoSetupRemote = "true";
          followTags = "true";
        };
        fetch = {
          prune = "true";
          pruneTags = "true";
          all = "true";
        };

        help.autocorrect = "prompt";
        commit.verbose = "true";
        rerere = {
          enabled = "true";
          autoupdate = "true";
        };
        rebase = {
          autoSquash = "true";
          autoStash = "true";
          updateRefs = "true";
        };
        pull.rebase = "true";
      };
    };
  };
}
