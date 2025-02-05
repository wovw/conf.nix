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

    handle_selection() {
        local result="$1"
        if [ -n "$result" ]; then
            cliphist decode <<<"$result" | wl-copy
            exit 0
        fi
    }

    handle_delete() {
        local result="$1"
        if [ -n "$result" ]; then
            cliphist delete <<<"$result"
        fi
    }

    handle_wipe() {
        cliphist wipe
    }

    # Use process substitution to avoid subshell issues
    result=$(rofi \
        -i \
        -dmenu \
        -kb-custom-1 "Control+Delete" \
        -kb-custom-2 "Alt+Delete" \
        -kb-accept-entry "Return" \
        -kb-cancel "Escape" \
        < <(cliphist list))

    exit_code=$?
    echo "Exit code: $exit_code" >&2

    case $exit_code in
        0)  # Normal selection
            handle_selection "$result"
            ;;
        1)  # User cancelled
            exit 0
            ;;
        10) # Ctrl+Delete pressed
            handle_delete "$result"
            exec "$0"  # Restart the script to show updated list
            ;;
        11) # Alt+Delete pressed
            handle_wipe
            exec "$0"  # Restart the script to show updated list
            ;;
        *)  # Unknown exit code
            exit 1
            ;;
    esac
  '';
}
