{
  pkgs,
  inputs,
  username,
  ...
}:

let
  inherit (import ./variables.nix) gitUsername;
in
{
  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = gitUsername;
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "input"
        "uinput"
        "i2c"
      ];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
      packages = with pkgs; [
        tree-sitter
        webcord
        nodejs_20
        (pnpm.override {
          version = "9.12.1";
          hash = "sha256-kUUv36RiNK5EfUbVxPxOfgpwWPkElcS293+L7ruxVOM=";
        })
        cliphist
        rclone
        python313
        uv
        inputs.zen-browser.packages."${system}".specific
        qbittorrent
        tokei
      ];
      openssh.authorizedKeys.keys = [ ];
    };
  };
}
