{ host }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        compression = false;
        addKeysToAgent = "no";
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
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
