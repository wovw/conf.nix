# NixOS flake

- nixos config init'd from <https://gitlab.com/Zaney/zaneyos>
- nvim config init'd from <https://github.com/ThePrimeagen/init.lua> and <https://github.com/nvim-lua/kickstart.nvim>

> [!CAUTION]
>
> - [ ] fix rofi-wayland clipboard manager keybinds
> - [ ] fix screenkey / find alternatives
> - [ ] refactor/cleanup folder structure someday

## useful commands

```sh
nix repl ~/conf.nix#nixosConfigurations.{hostname}.config
```
```sh
journalctl -b --user -u {service-name} -f
```
