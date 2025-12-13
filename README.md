# NixOS flake

## manual things

* [lanzaboote setup](https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md)
  * just reverse and redo the steps on a new machine
* `ssh-keygen -t ed25519` with `{host}_ed25519` as the filename
* `sudo passwd {username}` to change password
* github repos
* rclone
* [winapps](https://github.com/winapps-org/winapps)
  * reset: `podman compose --file ~/.config/winapps/compose.yaml down --rmi=all --volumes`
  * install: `podman compose --file ~/.config/winapps/compose.yaml up -d`, windows will be available at `http://127.0.0.1:8006`, sign out
  * [changing `compose.yaml`](https://github.com/winapps-org/winapps/blob/main/docs/docker.md#changing-composeyaml)
  * `podman-compose --file ~/.config/winapps/compose.yaml start`
  * `winapps-setup` to install windows
  * directly start windows through vicinae after boot
* [setting up garnix with autoupdates](https://blake.bruell.com/articles/automatic-flake-updates-with-garnix)

### useful commands

```sh
nix repl ~/conf.nix#nixosConfigurations.{hostname}.config
```

```sh
journalctl -b --user -u {service-name} -f
```

#### mounting bitlocker drive

```sh
sudo dislocker-fuse -v -V /dev/nvme1n1p1 -p{recovery_key} -- /mnt/bitlocker-fuse && sudo mount -o loop -t ntfs-3g /mnt/bitlocker-fuse/dislocker-file /mnt/windows
```

```sh
sudo umount /mnt/windows && sudo sudo umount /mnt/bitlocker-fuse
```

## wsl setup

* install steps at <https://nix-community.github.io/NixOS-WSL/install.html>
* `sudo nano /etc/nixos/configuration.nix`
  * add `environment.systemPackages = with pkgs; [git vim];`
  * edit `wsl.defaultUser` to desired username
  * follow <https://nix-community.github.io/NixOS-WSL/how-to/change-username.html>
* set NixOS as default distro to prevent startup errors (`wsl -s NixOS`)
* `git clone --recurse-submodules --remote-submodules https://github.com/wovw/conf.nix.git`
* set username and hostname in `flake.nix` `nixosConfigurations.{hostname}`
  * if changing hostname, change folder's name in `hosts` folder
* change variables in `hosts/{hostname}/variables.nix`
* ensure all changes are tracked in git (e.g. `git add .`)
  * push, replace https remote with ssh remote in git and `.gitmodules`, etc
* `cd ~/conf.nix && sudo nixos-rebuild boot --flake .#{hostname}` and follow the above install link to restart NixOS

## References / Inspirations

* nixos
  * <https://github.com/Zaney/zaneyos>
  * <https://github.com/librephoenix/nixos-config>
* nvim
  * <https://github.com/ThePrimeagen/init.lua>
  * <https://github.com/nvim-lua/kickstart.nvim>
  * <https://www.lazyvim.org>

## Windows setup steps 😔

### Prereqs

* check VBSCRIPT: `DISM /Online /Add-Capability /CapabilityName:VBSCRIPT~~~~`
* enable Developer Mode in Windows Settings
* `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

### github ssh

```pwsh
ssh-keygen -t ed25519 -C "email@example.com"
Get-Service -Name ssh-agent | Set-Service -StartupType Manual
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519
```

```pwsh
# paste in github
cat ~/.ssh/id_ed25519.pub | clip 
```

### Bootstrap

```pwsh
# Install Winget & Git
winget install --id Microsoft.AppInstaller --source winget --force
winget install -e --id Git.Git
```

```pwsh
# Install VS Build Tools (Launch and select C++ development)
winget install -e --id Microsoft.VisualStudio.BuildTools
```

```pwsh
git config --global core.autocrlf input
```

```pwsh
git clone git@github.com:wovw/conf.nix.git
```

```pwsh
# Run setup script
cd conf.nix
.\hosts\midd\setup.ps1
```
