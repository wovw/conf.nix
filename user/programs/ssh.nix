{ host, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        host = "github.com";
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/${host}_ed25519";
      };
      "raspberrypi" = {
        host = "raspberrypi";
        hostname = "raspberrypi.local";
        user = "pants";
        identityFile = "~/.ssh/${host}_ed25519";
      };
    };
  };

  services.ssh-agent.enable = true;
}
