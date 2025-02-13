{
  pkgs,
  username,
  host,
}:

pkgs.writeShellApplication {
  name = "rebuild";

  text = ''
    if [ $# -eq 0 ]; then
        sudo nixos-rebuild switch --flake "/home/${username}/conf.nix?submodules=1#${host}"
    else 
        nixos-rebuild switch --flake "/home/${username}/conf.nix?submodules=1#$1" --target-host "root@$1"
    fi
  '';
}
