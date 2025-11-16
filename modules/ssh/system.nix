{ ... }:
{
  # sshd daemon for incoming connections
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  # ssh-agent for outgoing connections
  programs.ssh.startAgent = true;
}
