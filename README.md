# NixOS flake

- nixos config init'd from <https://gitlab.com/Zaney/zaneyos> and <https://gitlab.com/librephoenix/nixos-config>
- nvim config init'd from <https://github.com/ThePrimeagen/init.lua> and <https://github.com/nvim-lua/kickstart.nvim>

> [!CAUTION]
>
> - [ ] fix rofi-wayland clipboard manager keybinds

## useful commands

```sh
nix repl ~/conf.nix#nixosConfigurations.{hostname}.config
```
```sh
journalctl -b --user -u {service-name} -f
```

## manual things

- `ssh-keygen -t ed25519` with `{host}_ed25519` as the filename
- github repos
- rclone
- winapps

## wsl setup

- install steps at <https://nix-community.github.io/NixOS-WSL/install.html>
- `sudo nano /etc/nixos/configuration.nix`
  - add `environment.systemPackages = with pkgs; [git vim];`
  - edit `wsl.defaultUser` to desired username
  - follow <https://nix-community.github.io/NixOS-WSL/how-to/change-username.html>
- set NixOS as default distro to prevent startup errors (`wsl -s NixOS`)
- `git clone --recurse-submodules --remote-submodules https://github.com/wovw/conf.nix.git`
- `cd ~/conf.nix && sudo nixos-rebuild boot --flake .#harpe` and follow the above link to restart NixOS
