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

- github repos
- rclone
- winapps
