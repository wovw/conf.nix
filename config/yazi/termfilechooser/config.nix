{ pkgs, ... }:
let
  yazi-wrapper = pkgs.callPackage ./yazi-wrapper.nix { };
in
''
  [filechooser]
  cmd=${yazi-wrapper}/bin/yazi-wrapper
  default_dir=$HOME
''
