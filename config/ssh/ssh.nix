{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    openssh
  ];

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        host = "github.com";
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/git_rsa";
      };
    };
  };

  services.ssh-agent.enable = true;
}

