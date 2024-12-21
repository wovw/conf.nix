{
  pkgs,
  username,
  ...
}:

let
  inherit (import ./variables.nix) gitUsername;
in
{
  users = {
    mutableUsers = false;
    users = {
      "${username}" = {
        hashedPassword = "$y$j9T$jlVa6U34B8YQ1dtZloUJ9.$Q5b/o1PsykSpFGrg39h3O.VNcxPBYL/nXZE6K7A5tM.";
        homeMode = "755";
        isNormalUser = true;
        description = gitUsername;
        extraGroups = [
          "wheel"
          "scanner"
          "lp"
          "input"
          "uinput"
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
          cliphist
          tokei
          yazi
        ];
        openssh.authorizedKeys.keys = [ ];
      };
    };
  };
}
