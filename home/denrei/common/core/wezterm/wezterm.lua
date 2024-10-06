local wezterm = require("wezterm")
return {
	color_scheme = "Catppuccin Mocha",
	default_prog = { "zsh" },
	font = wezterm.font("FantasqueSansMono"),
	font_size = 14.0,
	enable_tab_bar = false,
	term = "wezterm",
	keys = {
		{
			key = "a",
			mods = "SUPER",
			action = wezterm.action.DisableDefaultAssignment,
		},
	},
}
