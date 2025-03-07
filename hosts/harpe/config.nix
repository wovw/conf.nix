# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  lib,
  pkgs,
  system,
  ...
}@args:
let
  inherit (import ./variables.nix { inherit pkgs; }) keyboardLayout wallpaper;
in
{
  nixpkgs.hostPlatform = lib.mkDefault "${system}";

  imports = [
    ./users.nix
    ../../system/hardware/nvidia-drivers.nix
    ../../system/hardware/nvidia-prime-drivers.nix
    ../../system/hardware/intel-drivers.nix
    (import ../../system/config/common.nix (args // { inherit keyboardLayout; }))
    (import ../../system/config/theme.nix (args // { inherit wallpaper; }))
    ../../system/config/nix.nix
    ../../system/config/programs.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
