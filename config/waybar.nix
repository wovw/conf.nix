{
pkgs,
lib,
config,
...
}:

let
    betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in
    with lib;
{
    programs.waybar = {
        enable = true;
        package = pkgs.waybar;
        settings = [
            {
                layer = "top";
                position = "top";
                modules-center = [ "hyprland/workspaces" ];
                modules-left = [
                    "custom/startmenu"
                    "pulseaudio"
                    "cpu"
                    "memory"
                    "idle_inhibitor"
                ];
                modules-right = [
                    "custom/hyprbindings"
                    "custom/notification"
                    "custom/exit"
                    "battery"
                    "tray"
                    "clock"
                ];

                "hyprland/workspaces" = {
                    format = "{icon}";
                    format-icons = {
                        default = "󰊠";
                        active = "󰮯";
                        empty = "";
                    };
                    on-scroll-up = "hyprctl dispatch workspace e+1";
                    on-scroll-down = "hyprctl dispatch workspace e-1";
                    persistent-workspaces = {
                        "1" = [];
                        "2" = [];
                        "3" = [];
                        "4" = [];
                        "5" = [];
                    };
                };
                "clock" = {
                    interval = 1;
                    format = '' {:L%I:%M:%S %p}'';
                    format-alt = " {:%H:%M:%S   %Y, %d %B, %A}";
                    tooltip = true;
                    tooltip-format = "<tt><small>{calendar}</small></tt>";
                    calendar = {
                        mode = "year";
                        mode-mon-col = 3;
                        weeks-pos = "right";
                        on-scroll = 1;
                        format = {
                            months = "<span color='#ffead3'><b>{}</b></span>";
                            days = "<span color='#ecc6d9'><b>{}</b></span>";
                            weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
                        };
                    };
                };
                "memory" = {
                    interval = 5;
                    format = " {}%";
                    tooltip = true;
                };
                "cpu" = {
                    interval = 5;
                    format = " {usage:2}%";
                    tooltip = true;
                };
                "disk" = {
                    format = " {free}";
                    tooltip = true;
                };
                "network" = {
                    format-icons = [
                        "󰤯"
                        "󰤟"
                        "󰤢"
                        "󰤥"
                        "󰤨"
                    ];
                    format-ethernet = " {bandwidthDownOctets}";
                    format-wifi = "{icon} {signalStrength}%";
                    format-disconnected = "󰤮";
                    tooltip = false;
                };
                "tray" = {
                    spacing = 12;
                };
                "pulseaudio" = {
                    format = "{icon} {volume}% {format_source}";
                    format-bluetooth = "{volume}% {icon} {format_source}";
                    format-bluetooth-muted = " {icon} {format_source}";
                    format-muted = " {format_source}";
                    format-source = " {volume}%";
                    format-source-muted = "";
                    format-icons = {
                        headphone = "";
                        hands-free = "";
                        headset = "";
                        phone = "";
                        portable = "";
                        car = "";
                        default = [
                            ""
                            ""
                            ""
                        ];
                    };
                    on-click = "pavucontrol";
                };
                "custom/exit" = {
                    tooltip = false;
                    format = "";
                    on-click = "wlogout-launcher";
                };
                "custom/startmenu" = {
                    tooltip = false;
                    format = "";
                    # exec = "rofi -show drun";
                    on-click = "rofi-launcher";
                };
                "idle_inhibitor" = {
                    format = "{icon}";
                    format-icons = {
                        activated = "";
                        deactivated = "";
                    };
                    tooltip = "true";
                };
                "custom/notification" = {
                    tooltip = false;
                    format = "{icon} {}";
                    format-icons = {
                        notification = "<span foreground='red'><sup></sup></span>";
                        none = "";
                        dnd-notification = "<span foreground='red'><sup></sup></span>";
                        dnd-none = "";
                        inhibited-notification = "<span foreground='red'><sup></sup></span>";
                        inhibited-none = "";
                        dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
                        dnd-inhibited-none = "";
                    };
                    return-type = "json";
                    exec-if = "which swaync-client";
                    exec = "swaync-client -swb";
                    on-click = "task-waybar";
                    escape = true;
                };
                "battery" = {
                    states = {
                        warning = 20;
                        critical = 10;
                    };
                    format = "{icon} {capacity}%";
                    format-charging = "󰂄 {capacity}%";
                    format-plugged = "󱘖 {capacity}%";
                    format-icons = [
                        "󰁺"
                        "󰁻"
                        "󰁼"
                        "󰁽"
                        "󰁾"
                        "󰁿"
                        "󰂀"
                        "󰂁"
                        "󰂂"
                        "󰁹"
                    ];
                    on-click = "";
                    tooltip = false;
                };
            }
        ];
        style = concatStrings [
            ''
            * {
              font-family: JetBrainsMono Nerd Font Mono;
              font-size: 16px;
              border-radius: 0px;
              border: none;
              min-height: 0px;
            }
            window#waybar {
              background: rgba(0,0,0,0);
            }
            #workspaces {
              color: #${config.lib.stylix.colors.base00};
              background: #${config.lib.stylix.colors.base01};
              margin: 4px 4px;
              padding: 5px 5px;
              border-radius: 16px;
            }
            #workspaces button {
              font-weight: bold;
              padding: 0px 5px;
              margin: 0px 3px;
              border-radius: 16px;
              color: #${config.lib.stylix.colors.base00};
              background: linear-gradient(45deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base0D});
              opacity: 0.5;
              transition: ${betterTransition};
            }
            #workspaces button.active {
              font-weight: bold;
              padding: 0px 5px;
              margin: 0px 3px;
              border-radius: 16px;
              color: #${config.lib.stylix.colors.base00};
              background: linear-gradient(45deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base0D});
              transition: ${betterTransition};
              opacity: 1.0;
              min-width: 40px;
            }
            #workspaces button:hover {
              font-weight: bold;
              border-radius: 16px;
              color: #${config.lib.stylix.colors.base00};
              background: linear-gradient(45deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base0D});
              opacity: 0.8;
              transition: ${betterTransition};
            }
            tooltip {
              background: #${config.lib.stylix.colors.base00};
              border: 1px solid #${config.lib.stylix.colors.base08};
              border-radius: 12px;
            }
            tooltip label {
              color: #${config.lib.stylix.colors.base08};
            }
            #window, #pulseaudio, #cpu, #memory, #idle_inhibitor {
              font-weight: bold;
              margin: 4px 0px;
              margin-left: 7px;
              padding: 0px 18px;
              background: #${config.lib.stylix.colors.base04};
              color: #${config.lib.stylix.colors.base00};
              border-radius: 24px 10px 24px 10px;
            }
            #custom-startmenu {
              color: #${config.lib.stylix.colors.base0B};
              background: #${config.lib.stylix.colors.base02};
              font-size: 28px;
              margin: 0px;
              padding: 0px 30px 0px 15px;
              border-radius: 0px 0px 40px 0px;
            }
            #custom-hyprbindings, #network, #battery,
            #custom-notification, #tray, #custom-exit {
              font-weight: bold;
              background: #${config.lib.stylix.colors.base0F};
              color: #${config.lib.stylix.colors.base00};
              margin: 4px 0px;
              margin-right: 7px;
              border-radius: 10px 24px 10px 24px;
              padding: 0px 18px;
            }
            #clock {
              font-weight: bold;
              color: #0D0E15;
              background: linear-gradient(90deg, #${config.lib.stylix.colors.base0E}, #${config.lib.stylix.colors.base0C});
              margin: 0px;
              padding: 0px 15px 0px 30px;
              border-radius: 0px 0px 0px 40px;
            }
            ''
        ];
    };
}
