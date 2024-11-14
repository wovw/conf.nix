{ pkgs }:

pkgs.writeShellApplication {
    name = "task-waybar";

    runtimeInputs = with pkgs; [
        swaynotificationcenter
    ];

    text = ''
        swaync-client -t -sw
    '';
}
