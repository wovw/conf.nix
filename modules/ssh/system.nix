_: {
  # sshd daemon for incoming connections
  services.openssh = {
    enable = false;
    settings = {
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };
}
