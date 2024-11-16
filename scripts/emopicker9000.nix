{ pkgs }:

pkgs.writeShellApplication {
  name = "emopicker9000";
  runtimeInputs = with pkgs; [
    rofi-wayland
    ydotool
    wl-clipboard
    libnotify
  ];
  text = ''
        # Get user selection via rofi from emoji file.
        chosen=$(rofi -i -dmenu -config ~/.config/rofi/config-emoji.rasi < "$HOME/.config/.emoji" | awk '{print $1}')

        # Exit if none chosen.
        [ -z "$chosen" ] && exit

        # If you run this command with an argument, it will automatically insert the
        # character. Otherwise, show a message that the emoji has been copied.
        if [ -n "$1" ]; then
    	    ydotool type "$chosen"
        else
            printf "%s" "$chosen" | wl-copy
    	      notify-send "'$chosen' copied to clipboard." &
        fi
  '';
}
