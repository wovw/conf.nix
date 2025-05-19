{ pkgs }:

pkgs.writeShellApplication {
  name = "swaync-launcher";

  runtimeInputs = with pkgs; [
    swaynotificationcenter
  ];

  text = ''
    swaync-client -t -sw
  '';
}
