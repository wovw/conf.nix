local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.prefer_egl = true

config.font = wezterm.font("JetBrains Mono")
config.font_size = 12.0
config.window_background_opacity = 0.75
config.window_decorations = "RESIZE" -- Minimal borders

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{ key = "v", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
}

return config
