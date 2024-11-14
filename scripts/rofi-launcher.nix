{ pkgs }:

pkgs.writeShellApplication {
  name = "rofi-launcher";

  runtimeInputs = with pkgs; [
    rofi-wayland
    procps # for pgrep and pkill
  ];

  text = ''
    if pgrep -x "rofi" > /dev/null; then
      # Rofi is running, kill it
      pkill -x rofi
      exit 0
    fi
    rofi -show drun -modi drun,filebrowser,run,window
  '';
}

