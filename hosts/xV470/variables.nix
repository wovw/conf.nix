{
    system = "x86_64_Linux";

    # Git Configuration ( For Pulling Software Repos )
    gitUsername = "wovw";
    gitEmail = "anthonypasala12@gmail.com";

    # Hyprland Settings
    extraMonitorSettings = ''
    monitor=eDP-1,preferred,0x0,1.25
    monitor=HDMI-A-4,preferred,auto-right,1
    '';

    # Waybar Settings
    clock24h = false;

    # Program Options
    browser = "zen-alpha"; # Set Default Browser (google-chrome-stable for google-chrome)
    terminal = "kitty"; # Set Default System Terminal
    keyboardLayout = "us";
}
