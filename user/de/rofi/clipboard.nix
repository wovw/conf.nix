{ pkgs }:

pkgs.writeShellApplication {
  name = "clip-manager";

  runtimeInputs = with pkgs; [
    cliphist
    rofi-wayland
    wl-clipboard
  ];

  text = ''
    # Actions:
    # CTRL Del to delete an entry
    # ALT Del to wipe clipboard contents

    msg='👀 **note**  CTRL DEL = cliphist del (entry)   or   ALT DEL - cliphist wipe (all)'

    # Check if rofi is already running
    if pidof rofi > /dev/null; then
      pkill rofi
    fi

    while true; do
        result=$(
            rofi -i -dmenu \
                -kb-custom-1 "Control-Delete" \
                -kb-custom-2 "Alt-Delete" \
                < <(cliphist list) \
                -mesg "$msg" 
        )

        case "$?" in
            1)
                notify-send "1";
                exit
                ;;
            0)
                notify-send "0";
                case "$result" in
                    "")
                        continue
                        ;;
                    *)
                        cliphist decode <<<"$result" | wl-copy
                        exit
                        ;;
                esac
                ;;
            10)
                notify-send "10";
                cliphist delete <<<"$result"
                ;;
            11)
                notify-send "11";
                cliphist wipe
                ;;
            *)
                notify-send "other";
                ;;
        esac
    done
  '';
}
