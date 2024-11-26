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
        sccache
        nodejs_22
        go
        python313
        uv
        tree-sitter
        webcord
        cliphist
        rclone
        inputs.zen-browser.packages."${system}".specific
        qbittorrent
        tokei
        screenkey
      ];
      openssh.authorizedKeys.keys = [ ];
    };
  };
}
