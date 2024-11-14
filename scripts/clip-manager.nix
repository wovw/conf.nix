{ pkgs }:

pkgs.writeShellApplication {
  name = "clipboard-manager";

  runtimeInputs = with pkgs; [
    cliphist
    rofi-wayland
    wl-clipboard
  ];

  text = ''
    # Clipboard Manager. This script uses cliphist, rofi, and wl-copy.
    #
    # Actions:
    # CTRL Del to delete an entry
    # ALT Del to wipe clipboard contents

    while true; do
        result=$(
            rofi -i -dmenu \
                -kb-custom-1 "Control-Delete" \
                -kb-custom-2 "Alt-Delete" < <(cliphist list)
        )

        exit_code=$?
        case "$exit_code" in
            1)
                exit
                ;;
            0)
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
                cliphist delete <<<"$result"
                ;;
            11)
                cliphist wipe
                ;;
        esac
    done
  '';
}
