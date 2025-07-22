{ host }:
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
      "kfc" = {
        host = "kfc";
        hostname = "kfc.local";
        user = "krispy";
        identityFile = "~/.ssh/${host}_ed25519";
      };
    };
  };
}
