{
  pkgs,
  INTERNAL,
  EXTERNAL,
}:

pkgs.writeShellApplication {
  name = "toggle-mirror";

  runtimeInputs = with pkgs; [
    wl-mirror
  ];

  text = ''
    if pgrep wl-mirror >/dev/null; then
        pkill wl-mirror
    else
        wl-present mirror ${INTERNAL} --fullscreen-output ${EXTERNAL} --fullscreen
    fi
  '';
}
