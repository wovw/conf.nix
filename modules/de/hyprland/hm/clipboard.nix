{
  inputs,
  modifier,
  system,
}:
let
  clipboard = "${inputs.rofi-tools.packages.${system}.rofi-cliphist}/bin/rofi-cliphist";
in
''
  exec-once = wl-paste --type text --watch cliphist store
  exec-once = wl-paste --type image --watch cliphist store

  bind = ${modifier},V,exec,${clipboard}
''
