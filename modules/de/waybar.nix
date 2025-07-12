{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  wlogout = pkgs.callPackage ./wlogout/launcher.nix { };
  rofi = pkgs.callPackage ./rofi/launcher.nix { };
  swaync = pkgs.callPackage ./swaync/launcher.nix { };
  backlight = pkgs.callPackage ./scripts/brightness.nix { };
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [
          "custom/startmenu"
          "hyprland/workspaces"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "idle_inhibitor"
          "backlight"
          "pulseaudio"
          "battery"
          "cpu"
          "memory"
          "tray"
          "custom/notification"
          "custom/exit"
        ];
        "custom/startmenu" = {
          tooltip = false;
          format = "";
          on-click = "${rofi}/bin/rofi-launcher";
        };
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            default = "󰊠";
            active = "󰮯";
            empty = "";
          };
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };
        "clock" = {
          interval = 1;
          format = " {:%d -  %I:%M:%S %p}";
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
          format = " {}%";
          tooltip = true;
        };
        "cpu" = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
        };
        "tray" = {
          spacing = 10;
        };
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon}  {format_source}";
          format-bluetooth-muted = "󰗿 {icon}  {format_source}";
          format-muted = "󰝟 {format_source}";
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
          on-click = "${wlogout}/bin/wlogout-launcher";
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
            notification = " <span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = " <span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = " <span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = " <span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "${swaync}/bin/swaync-launcher";
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
          tooltip = true;
        };
        "backlight" = {
          format = "☀ {}%";
          on-scroll-up = "${backlight}/bin/brightness-control --inc";
          on-scroll-down = "${backlight}/bin/brightness-control --dec";
        };
      }
    ];
    style = concatStrings [
      ''
        * {
          font-family: ${config.stylix.fonts.monospace.name};
          font-size: 14px;
          min-height: 0;
        }

        #waybar {
          background-color: transparent;
        }

        #workspaces button {
          color: #babbf1;
          padding: 0.3rem;
        }
        #workspaces button.active {
          color: #99d1db;
        }
        #workspaces button:hover {
          color: #85c1dc;
        }

        #custom-startmenu,
        #tray,
        #clock,
        #battery,
        #pulseaudio,
        #backlight,
        #cpu,
        #memory,
        #idle_inhibitor,
        #custom-notification,
        #custom-exit {
          background-color: transparent;
          padding: 0rem 0.75rem;
        }

        #custom-startmenu {
          color: #2AC3DE;
        }

        #clock {
          color: #8caaee;
        }

        #battery {
          color: #a6d189;
        }

        #battery.charging {
          color: #a6d189;
        }

        #battery.warning:not(.charging) {
          color: #e78284;
        }

        #battery {
          border-radius: 0;
        }

        #pulseaudio {
          color: #ea999c;
        }

        #backlight {
          color: #f9e2af;
        }

        #custom-exit {
          color: #e78284;
          margin-right: 0.5rem;
        }

        tooltip {
          background: #1A1B26;
          border: 1px solid #C0CAF5;
          border-radius: 12px;
        }
        tooltip label {
          color: #C0CAF5;
        }
      ''
    ];
  };
}
