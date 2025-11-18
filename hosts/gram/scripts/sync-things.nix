{ pkgs, username, ... }:

# Script for rclone bisync, make sure to init with `--resync` flag before service runs

let
  authorizedUser = "wovw";
  driveSyncHelper = pkgs.writeShellApplication {
    name = "gdrive-sync-things";

    runtimeInputs = with pkgs; [
      rclone
      libnotify
      procps # pgrep
      gnused # sed
      gawk # awk
      coreutils # date, sleep, etc
    ];

    text = ''
      LOCAL_DIR="$HOME/things"
      REMOTE_NAME="personal-drive" # gdrive from rclone config
      REMOTE_PATH="things"

      # tag for swaync progress bar
      NOTIF_TAG="rclone-bisync-tag"

      # initial notification
      notify-send -h "string:x-canonical-private-synchronous:$NOTIF_TAG" \
          "Google Drive Sync" "Initializing synchronization..." \
          -i system-software-update

      # lock file safety check
      if pgrep -x "rclone" > /dev/null; then
          notify-send -h "string:x-canonical-private-synchronous:$NOTIF_TAG" \
              "Sync Skipped" "Another rclone process is already running." \
              -u critical
          exit 0
      fi

      ERR_LOG=$(mktemp)

      # run bisync
      # --stats 2s: Updates notification every 2 seconds
      # --stats-one-line: Makes it easy to grep
      # --force: Forces past minor non-critical errors
      # --recover: Attempts to heal the directory structure if desynced
      # 2>&1: Redirects stderr to stdout to pipe it
      # set +e: disable error exit for the pipe to catch the result

      set +e 
      rclone bisync "$LOCAL_DIR" "$REMOTE_NAME:$REMOTE_PATH" \
          --force \
          --recover \
          --verbose \
          --stats 2s \
          --stats-one-line 2>&1 | \
      while read -r line; do
          # Check if the line contains transfer stats
          if echo "$line" | grep -q "Transferred:"; then
              # awk extracts: "Transferred: 1.2M / 10M, 12%, 100k/s" -> "1.2M / 10M, 12%, 100k/s"
              CLEAN=$(echo "$line" | sed 's/Transferred: //g' | xargs)
              notify-send -h "string:x-canonical-private-synchronous:$NOTIF_TAG" \
                  "Syncing..." "$CLEAN" \
                  -t 4000 \
                  -i transfer
          fi

          # Capture errors
          if echo "$line" | grep -q "ERROR"; then
              echo "$line" >> "$ERR_LOG"
          fi
      done
      set -e

      if [ -s "$ERR_LOG" ]; then
           notify-send -h "string:x-canonical-private-synchronous:$NOTIF_TAG" \
              "Sync Completed with Errors" "Check logs with: journalctl --user -u gdrive-sync" \
              -u critical \
              -i dialog-error
      else
           notify-send -h "string:x-canonical-private-synchronous:$NOTIF_TAG" \
              "Sync Finished" "Your folder is up to date." \
              -i weather-clear
      fi

      rm -f "$ERR_LOG"
    '';
  };

in
{
  # specific to me
  assertions = [
    {
      assertion = username == authorizedUser;
      message = "SECURITY ERROR: The rclone-sync service is locked to user '${authorizedUser}' but was configured for '${username}'. Build aborted.";
    }
  ];

  # service definition
  systemd.user.services.gdrive-sync-things = {
    description = "rclone bisync things";
    unitConfig = {
      ConditionUser = username;
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${driveSyncHelper}/bin/gdrive-sync-things";
      Restart = "no";

      # required for swaync to receive notifications from the systemd service
      Environment = "DISPLAY=:0";
    };
  };

  # timer definition
  systemd.user.timers.gdrive-sync-things = {
    description = "Daily gdrive things sync (persistent)";
    unitConfig = {
      ConditionUser = username;
    };
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      OnBootSec = "5m";
      RandomizedDelaySec = "5m";
      Unit = "gdrive-sync-things.service";
    };
    wantedBy = [ "timers.target" ];
  };
}
