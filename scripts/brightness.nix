{ pkgs }:

pkgs.writeShellApplication {
  name = "brightness-control";

  runtimeInputs = with pkgs; [
    brightnessctl
    ddcutil
    libnotify
    coreutils
    gnused
  ];

  text = ''
    # Script for Monitor brightness

    iDIR="$HOME/.config/swaync/icons"
    step=10  # INCREASE/DECREASE BY THIS VALUE
    EXTERNAL_MONITOR_BUS="8"  # From `ddcutil detect` output

    # Get laptop brightness
    get_laptop_backlight() {
        brightnessctl -m | cut -d, -f4 | sed 's/%//'
    }

    # Get icons
    get_icon() {
        local current
        current=$(get_laptop_backlight)
        if   [ "$current" -le "20" ]; then
            icon="$iDIR/brightness-20.png"
        elif [ "$current" -le "40" ]; then
            icon="$iDIR/brightness-40.png"
        elif [ "$current" -le "60" ]; then
            icon="$iDIR/brightness-60.png"
        elif [ "$current" -le "80" ]; then
            icon="$iDIR/brightness-80.png"
        else
            icon="$iDIR/brightness-100.png"
        fi
    }

    # Notify
    notify_user() {
        notify-send -e \
          -h string:x-canonical-private-synchronous:brightness_notif \
          -h "int:value:$1" \
          -u low \
          -i "$icon" \
          "Brightness : $1%"
    }

    # Change brightness for all displays
    change_backlight() {
        current_brightness=$(get_laptop_backlight)
        new_brightness=current_brightness

        # Calculate new brightness
        if [[ "$1" == "+" ]]; then
            new_brightness=$((current_brightness + step))
        else
            new_brightness=$((current_brightness - step))
        fi

        # Ensure new brightness is within valid range
        if (( new_brightness < 10 )); then
            new_brightness=10
        elif (( new_brightness > 100 )); then
            new_brightness=100
        fi

        # laptop brightness
        brightnessctl set "$new_brightness%"

        # monitor brightness
        # Use || true to prevent script failure if monitor is disconnected
        ddcutil setvcp 10 "$new_brightness" \
          --bus "$EXTERNAL_MONITOR_BUS" \
          --noverify || true

        get_icon "$new_brightness"
        notify_user "$new_brightness"
    }

    # Execute accordingly
    case "$1" in
        "--get")
            get_laptop_backlight
            ;;
        "--inc")
            change_backlight "+"
            ;;
        "--dec")
            change_backlight "-"
            ;;
        *)
            get_laptop_backlight
            ;;
    esac
  '';
}
