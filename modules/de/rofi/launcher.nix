{ pkgs }:

pkgs.writeShellApplication {
  name = "rofi-launcher";

  runtimeInputs = with pkgs; [
    procps # for pgrep and pkill
  ];

  text = ''
    if pgrep -x "rofi" > /dev/null; then
      pkill -x rofi
      exit 0
    fi
    uwsm app -- rofi -show drun -modi drun,run,emoji
  '';
}
