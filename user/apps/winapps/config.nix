{
  config,
  inputs,
  system,
  username,
  ...
}:
{
  home.packages = [
    inputs.winapps.packages."${system}".winapps
  ];
  home.file.".config/winapps/compose.yaml".text = ''${
    (import ./compose.nix { inherit config username; })
  }'';
  home.file.".config/winapps/winapps.conf".text = ''
    ##################################
    #   WINAPPS CONFIGURATION FILE   #
    ##################################

    # INSTRUCTIONS
    # - Leading and trailing whitespace are ignored.
    # - Empty lines are ignored.
    # - Lines starting with '#' are ignored.
    # - All characters following a '#' are ignored.

    # [WINDOWS USERNAME]
    RDP_USER="${username}"

    # [WINDOWS PASSWORD]
    # NOTES:
    # - If using FreeRDP v3.9.0 or greater, you *have* to set a password
    RDP_PASS="asdf"

    # [WINDOWS DOMAIN]
    # DEFAULT VALUE: "" (BLANK)
    RDP_DOMAIN=""

    # [WINDOWS IPV4 ADDRESS]
    # NOTES:
    # - If using 'libvirt', 'RDP_IP' will be determined by WinApps at runtime if left unspecified.
    # DEFAULT VALUE:
    # - 'docker': '127.0.0.1'
    # - 'podman': '127.0.0.1'
    # - 'libvirt': "" (BLANK)
    RDP_IP=""

    # [WINAPPS BACKEND]
    # DEFAULT VALUE: 'docker'
    # VALID VALUES:
    # - 'docker'
    # - 'podman'
    # - 'libvirt'
    # - 'manual'
    WAFLAVOR="podman"

    # [DISPLAY SCALING FACTOR]
    # NOTES:
    # - If an unsupported value is specified, a warning will be displayed.
    # - If an unsupported value is specified, WinApps will use the closest supported value.
    # DEFAULT VALUE: '100'
    # VALID VALUES:
    # - '100'
    # - '140'
    # - '180'
    RDP_SCALE="100"

    # [ADDITIONAL FREERDP FLAGS & ARGUMENTS]
    # NOTES:
    # - You can try adding /network:lan to these flags in order to increase performance, however, some users have faced issues with this.
    # DEFAULT VALUE: '/cert:tofu /sound /microphone'
    # VALID VALUES: See https://github.com/awakecoding/FreeRDP-Manuals/blob/master/User/FreeRDP-User-Manual.markdown
    RDP_FLAGS="/cert:tofu /sound /microphone"

    # [MULTIPLE MONITORS]
    # NOTES:
    # - If enabled, a FreeRDP bug *might* produce a black screen.
    # DEFAULT VALUE: 'false'
    # VALID VALUES:
    # - 'true'
    # - 'false'
    MULTIMON="true"

    # [DEBUG WINAPPS]
    # NOTES:
    # - Creates and appends to ~/.local/share/winapps/winapps.log when running WinApps.
    # DEFAULT VALUE: 'true'
    # VALID VALUES:
    # - 'true'
    # - 'false'
    DEBUG="true"

    # [AUTOMATICALLY PAUSE WINDOWS]
    # NOTES:
    # - This is currently INCOMPATIBLE with 'docker' and 'manual'.
    # - See https://github.com/dockur/windows/issues/674
    # DEFAULT VALUE: 'off'
    # VALID VALUES:
    # - 'on'
    # - 'off'
    AUTOPAUSE="on"

    # [AUTOMATICALLY PAUSE WINDOWS TIMEOUT]
    # NOTES:
    # - This setting determines the duration of inactivity to tolerate before Windows is automatically paused.
    # - This setting is ignored if 'AUTOPAUSE' is set to 'off'.
    # - The value must be specified in seconds (to the nearest 10 seconds e.g., '30', '40', '50', etc.).
    # - For RemoteApp RDP sessions, there is a mandatory 20-second delay, so the minimum value that can be specified here is '20'.
    # - Source: https://techcommunity.microsoft.com/t5/security-compliance-and-identity/terminal-services-remoteapp-8482-session-termination-logic/ba-p/246566
    # DEFAULT VALUE: '300'
    # VALID VALUES: >=20
    AUTOPAUSE_TIME="300"

    # [FREERDP COMMAND]
    # NOTES:
    # - WinApps will attempt to automatically detect the correct command to use for your system.
    # DEFAULT VALUE: "" (BLANK)
    # VALID VALUES: The command required to run FreeRDPv3 on your system (e.g., 'xfreerdp', 'xfreerdp3', etc.).
    FREERDP_COMMAND=""
  '';
}
