{ pkgs }:

pkgs.writeShellApplication {
    name = "task-waybar";

    runtimeInputs = with pkgs; [
        swaynotificationcenter
        gnused
    ];

    text = ''
        swaync-client -t -sw
    '';
}
