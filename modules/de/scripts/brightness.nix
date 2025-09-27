{ pkgs }:

pkgs.writeShellApplication {
  name = "brightness-control";

  runtimeInputs = with pkgs; [
    brightnessctl
    ddcutil
    coreutils
    gnused
  ];

  text = ''
    # Script for Monitor brightness

    step=1 # INCREASE/DECREASE BY THIS VALUE

    # Get laptop brightness
    get_laptop_backlight() {
        brightnessctl -m | cut -d, -f4 | sed 's/%//'
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
        if (( new_brightness < step )); then
            new_brightness=step
        elif (( new_brightness > 100 )); then
            new_brightness=100
        fi

        # laptop brightness
        brightnessctl set "$new_brightness%" &

        # monitor brightness
        ddcutil setvcp 10 $new_brightness \
          --sleep-multiplier .1 &
    }

    case "$1" in
        "--inc")
            change_backlight "+"
            ;;
        "--dec")
            change_backlight "-"
            ;;
        *)
            echo "Usage: brightness-control [--inc|--dec]"
            exit 1
            ;;
    esac
  '';
}
