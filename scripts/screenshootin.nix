{ pkgs }:

pkgs.writeShellApplication {
    name = "screenshootin";

    runtimeInputs = with pkgs; [
        grim
        slurp
        wl-clipboard
        libnotify
        hyprland
        jq
        swappy    ];

    text = ''
        # Screenshot scripts

        ICON_DIR="$HOME/.config/swaync/icons"

        SS_DIR="$HOME/Pictures/Screenshots"
        mkdir -p "$SS_DIR"

        readonly NOTIFY_CMD="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i $ICON_DIR/picture.png"

        get_filename() {
            local time
            time=$(date "+%d-%b_%H-%M-%S")
            echo "Screenshot_{$time}_$RANDOM.png"
        }

        # notify and view screenshot
        notify_view() {
            local mode="$1"

            case "$mode" in
                "active")
                    local file_path="$2"
                    if [[ -e "$file_path" ]]; then
                        $NOTIFY_CMD "Screenshot of '$3' Saved."
                    else
                        $NOTIFY_CMD "Screenshot of '$3' not Saved"
                    fi
                    ;;
                "swappy")
                    $NOTIFY_CMD "Screenshot Captured."
                    ;;
                *)
                    local file_path="$2"
                    if [[ -e "$file_path" ]]; then
                        $NOTIFY_CMD "Screenshot Saved."
                    else
                        $NOTIFY_CMD "Screenshot NOT Saved."
                    fi
                    ;;
            esac
        }

        # Countdown function
        countdown() {
            local seconds="$1"
            for sec in $(seq "$seconds" -1 1); do
                notify-send -h string:x-canonical-private-synchronous:shot-notify -t 1000 \
                    -i "$ICON_DIR/timer.png" "Taking shot in : $sec"
                sleep 1
            done
        }

        # Screenshot functions
        take_screenshot_now() {
            local file
            file=$(get_filename)
            cd "$SS_DIR" && grim - | tee "$file" | wl-copy
            notify_view "normal" "$SS_DIR/$file"
        }
        take_screenshot_delay() {
            local delay="$1"
            local file
            file=$(get_filename)
            countdown "$delay"
            cd "$SS_DIR" && grim - | tee "$file" | wl-copy
            notify_view "normal" "$SS_DIR/$file"
        }
        take_screenshot_window() {
            local file
            file=$(get_filename)
            local w_pos
            w_pos=$(hyprctl activewindow | grep 'at:' | cut -d':' -f2 | tr -d ' ' | tail -n1)
            local w_size
            w_size=$(hyprctl activewindow | grep 'size:' | cut -d':' -f2 | tr -d ' ' | tail -n1 | sed s/,/x/g)
            cd "$SS_DIR" && grim -g "$w_pos $w_size" - | tee "$file" | wl-copy
            notify_view "normal" "$SS_DIR/$file"
        }
        take_screenshot_area() {
            local file
            file=$(get_filename)
            local tmpfile
            tmpfile=$(mktemp)
            grim -g "$(slurp)" - >"$tmpfile"
            if [[ -s "$tmpfile" ]]; then
                wl-copy <"$tmpfile"
                mv "$tmpfile" "$SS_DIR/$file"
                notify_view "normal" "$SS_DIR/$file"
            else
                rm "$tmpfile"
                notify_view "normal" ""
            fi
        }
        take_screenshot_active() {
            local active_window_class
            active_window_class=$(hyprctl -j activewindow | jq -r '(.class)')
            local time
            time=$(date "+%d-%b_%H-%M-%S")
            local file="Screenshot_''${time}_''${active_window_class}.png"
            local file_path="$SS_DIR/$file"

            hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | \
                grim -g - "$file_path"
            notify_view "active" "$file_path" "$active_window_class"
        }
        take_screenshot_swappy() {
            local tmpfile
            tmpfile=$(mktemp)
            grim -g "$(slurp)" - >"$tmpfile" && notify_view "swappy"
            swappy -f - <"$tmpfile"
            rm "$tmpfile"
        }

        # Main execution
        case "$1" in
            "--now")
                take_screenshot_now
                ;;
            "--in5")
                take_screenshot_delay 5
                ;;
            "--in10")
                take_screenshot_delay 10
                ;;
            "--win")
                take_screenshot_window
                ;;
            "--area")
                take_screenshot_area
                ;;
            "--active")
                take_screenshot_active
                ;;
            "--swappy")
                take_screenshot_swappy
                ;;
            *)
                echo "Available Options: --now --in5 --in10 --win --area --active --swappy"
                exit 1
                ;;
        esac

        exit 0

         '';
}
