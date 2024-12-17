-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

-- This is where you actually apply your config choices

-- For example, changing the color scheme:

config.font = wezterm.font("FantasqueSansM Nerd Font")
config.font_size = 12.0
config.default_prog = { "zsh" }
config.enable_tab_bar = true
config.enable_scroll_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_close_tab_button_in_tabs = true
config.color_scheme = "tokyonight_night"

config.set_environment_variables = {
	TERMINFO_DIRS = "/home/denrei/.nix-profile/share/terminfo",
}
config.term = "wezterm"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

config.window_frame = {
	font = wezterm.font("FantasqueSansM Nerd Font"),
	font_size = 12.0,
}

config.keys = {
	{
		key = "a",
		mods = "SUPER",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{ key = "n", mods = "ALT", action = act.SwitchWorkspaceRelative(1) },
	{ key = "p", mods = "ALT", action = act.SwitchWorkspaceRelative(-1) },
	{ key = "l", mods = "ALT", action = act.ActivateTabRelative(1) },
	{ key = "h", mods = "ALT", action = act.ActivateTabRelative(-1) },

	{ key = "o", mods = "ALT", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{ key = "t", mods = "ALT", action = act.ShowLauncherArgs({ flags = "FUZZY|TABS" }) },
}

-- and finally, return the configuration to wezterm
return config
