{
lib,
host,
config,
pkgs,
...
}:

with lib;
{
    wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = true;
        extraConfig =
            let
                modifier = "SUPER";
            in
                concatStrings [
                    ''
                        ${builtins.readFile ./env.conf}
                        ${(import ./laptop.nix {
                            inherit pkgs;
                            inherit modifier;
                        })}
                        ${builtins.readFile ./startup.conf}
                        ${builtins.readFile ./decor.conf}
                        ${(import ./keybinds.nix {
                            inherit pkgs;
                            inherit modifier;
                            inherit host;
                        })}
                        ${(import ./settings.nix {
                            colors = config.stylix.base16Scheme;
                            inherit host;
                        })}
                        ${builtins.readFile ./window-rules.conf}
                    ''
                ];
    };
}
