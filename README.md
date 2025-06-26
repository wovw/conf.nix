# NixOS flake

## useful commands

```sh
nix repl ~/conf.nix#nixosConfigurations.{hostname}.config
```

```sh
journalctl -b --user -u {service-name} -f
```

## manual things

- `ssh-keygen -t ed25519` with `{host}_ed25519` as the filename
- `sudo passwd {username}` to change password
- github repos
- rclone
- [winapps](https://github.com/winapps-org/winapps)
  - reset: `podman compose --file ~/.config/winapps/compose.yaml down --rmi=all --volumes`
  - install: `podman compose --file ~/.config/winapps/compose.yaml up -d`, windows will be available at `http://127.0.0.1:8006`, sign out
  - [changing `compose.yaml`](https://github.com/winapps-org/winapps/blob/main/docs/docker.md#changing-composeyaml)
  - `podman-compose --file ~/.config/winapps/compose.yaml start`
  - `winapps-setup` to install windows
  - directly start windows through rofi after boot

## wsl setup

- install steps at <https://nix-community.github.io/NixOS-WSL/install.html>
- `sudo nano /etc/nixos/configuration.nix`
  - add `environment.systemPackages = with pkgs; [git vim];`
  - edit `wsl.defaultUser` to desired username
  - follow <https://nix-community.github.io/NixOS-WSL/how-to/change-username.html>
- set NixOS as default distro to prevent startup errors (`wsl -s NixOS`)
- `git clone --recurse-submodules --remote-submodules https://github.com/wovw/conf.nix.git`
- set username and hostname in `flake.nix` `nixosConfigurations.{hostname}`
  - if changing hostname, change folder's name in `hosts` folder
- change variables in `hosts/{hostname}/variables.nix`
- ensure all changes are tracked in git (e.g. `git add .`)
  - push, replace https remote with ssh remote in git and `.gitmodules`, etc
- `cd ~/conf.nix && sudo nixos-rebuild boot --flake .#{hostname}` and follow the above install link to restart NixOS

## References

- nixos config

  - <https://github.com/Zaney/zaneyos>
  - <https://github.com/librephoenix/nixos-config>

- nvim config
  - <https://github.com/ThePrimeagen/init.lua>
  - <https://github.com/nvim-lua/kickstart.nvim>
  - <https://www.lazyvim.org>
