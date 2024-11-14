{ ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        host = "github.com";
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/git_ed25519";
      };
    };
  };

  services.ssh-agent.enable = true;
}

