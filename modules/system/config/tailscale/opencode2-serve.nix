# opencode2 API + web server, reachable via Tailscale Serve HTTPS.
#
# Loopback-only backend on 127.0.0.1:4096; tailscaled terminates tailnet TLS on
# :8443 (443 already serves t3code at /, see t3code-serve.nix). Pair new
# clients with `opencode2 pair` on the host, then open
# https://<host>.<tailnet>.ts.net:8443 from any tailnet device, or point a
# local TUI at it with `opencode2`.
#
# Note: `serve --service` makes this unit THE registered background service
# (same `~/.local/state/opencode/service.json` local CLIs discover), with the
# persistent password from `~/.config/opencode/service.json` — so `opencode2
# pair`, plain `opencode2`, and `--server` clients all work with stable creds.
# Plain `serve` instead mints an ephemeral password per start (printed once on
# stdout), which would break remote clients on every unit restart. Do not run
# a second server as this user (e.g. `opencode2 service start`); local TUIs
# attach to this unit automatically via service discovery.
{
  inputs,
  pkgs,
  username,
  ...
}:
let
  opencode2 = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2;
  backend = "http://127.0.0.1:4096";
in
{
  environment.systemPackages = [
    opencode2 # for `opencode2 pair` and local `--server` clients
  ];

  # Same operator grant as t3code-serve.nix so the serve mapping below can be
  # managed without sudo. Merges with that module's identical entry on hosts
  # importing both.
  services.tailscale.extraSetFlags = [ "--operator=${username}" ];

  systemd.services.opencode2-serve = {
    description = "opencode2 API + web server (loopback, via Tailscale Serve)";
    wantedBy = [ "multi-user.target" ];
    after = [
      "tailscaled.service"
      "tailscaled-set.service" # runs `tailscale set --operator` before the mapping needs it
    ];
    path = [ pkgs.tailscale ];
    # Re-applied on every (re)start; the mapping otherwise persists in
    # tailscaled state until `tailscale serve --https=8443 off`. --bg is
    # load-bearing: without it `tailscale serve` stays in the foreground
    # ("Press Ctrl+C to exit") and preStart times out, restart-looping the unit.
    preStart = ''
      tailscale serve --yes --bg --https=8443 ${backend}
    '';
    serviceConfig = {
      User = username;
      WorkingDirectory = "/home/${username}";
      ExecStart = "${opencode2}/bin/opencode2 serve --service --hostname 127.0.0.1 --port 4096";
      Restart = "always";
      RestartSec = 5;
    };
  };
}
