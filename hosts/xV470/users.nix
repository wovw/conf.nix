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
  services.userborn.enable = true;
  users = {
    mutableUsers = false;
    users = {
      "${username}" = {
        hashedPassword = "$y$j9T$jlVa6U34B8YQ1dtZloUJ9.$Q5b/o1PsykSpFGrg39h3O.VNcxPBYL/nXZE6K7A5tM.";
        homeMode = "755";
        isNormalUser = true;
        description = gitUsername;
        extraGroups = [
          "networkmanager"
          "wheel"
          "libvirt"
          "kvm"
          "scanner"
          "lp"
          "input"
          "uinput"
          "i2c"
        ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        packages = with pkgs; [
          clang-tools
          clang
          sccache
          pnpm
          nodejs_22
          go
          python313
          uv
          tree-sitter
          webcord
          cliphist
          rclone
          inputs.zen-browser.packages."${system}".default
          qbittorrent
          tokei
          spotify
          (callPackage ../../modules/xmcl.nix { })
          yt-dlp
        ];
        openssh.authorizedKeys.keys = [ ];
      };
    };
  };
}
