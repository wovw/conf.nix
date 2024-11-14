{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    openssh
  ];

  # ssh files
  home.file.".ssh/git_rsa".source = ./git_rsa;
  home.file.".ssh/git_rsa.pub".source = ./git_rsa.pub;

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

