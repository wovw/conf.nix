# Secrets auto-generate in /var/lib/karakeep/settings.env on first
# boot; sops environmentFile only when AI keys are added later.
{ pkgs, globals, host, ... }:
let
  port = 3434;
  url = "https://${host}.${globals.tailnet.suffix}:${toString port}";
in
{
  services.karakeep = {
    enable = true;
    meilisearch.enable = true;
    browser.enable = true;
    extraEnvironment = {
      PORT = "3000";
      NEXTAUTH_URL = url;
      DISABLE_SIGNUPS = "true"; # disabled after first user signup
      DISABLE_NEW_RELEASE_CHECK = "true";
    };
  };

  # tailscaled terminates tailnet TLS on :3434 and proxies
  # to the loopback backend. `--bg` is load-bearing (without it serve stays in
  # the foreground and the oneshot times out). Mapping persists in tailscaled
  # state until `tailscale serve --https=3434 off`.
  systemd.services.karakeep-serve = {
    description = "Karakeep via Tailscale Serve HTTPS :${toString port}";
    wantedBy = [ "multi-user.target" ];
    after = [
      "tailscaled.service"
      "tailscaled-set.service"
      "karakeep-web.service"
    ];
    partOf = [ "tailscaled.service" ];
    path = [ pkgs.tailscale ];
    script = ''
      tailscale serve --yes --bg --https=${toString port} http://127.0.0.1:3000
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
