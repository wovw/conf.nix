{
  gitUsername,
  gitEmail,
  host,
}:
{
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          name = gitUsername;
          email = gitEmail;
          signingkey = "~/.ssh/${host}_ed25519.pub";
        };

        # commit signing
        commit.gpgsign = "true";
        gpg.format = "ssh";

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

        submodule.recurse = "true";
        push.recurseSubmodules = "on-demand";
      };
    };
    lazygit.enable = true;
  };
}
