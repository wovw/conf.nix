{ username, pkgs, ... }:
{
  # Needed For Some Steam Games
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # https://wiki.nixos.org/wiki/Lutris
  environment.systemPackages = with pkgs; [
    lutris
  ];
  systemd.settings.Manager.DefaultLimitNOFILE = 524288;
  security.pam = {
    loginLimits = [
      {
        domain = "${username}";
        type = "hard";
        item = "nofile";
        value = "524288";
      }
    ];
  };

}
