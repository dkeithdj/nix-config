-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

function log_proc(proc, indent)
	indent = indent or ""
	wezterm.log_info(indent .. "pid=" .. proc.pid .. ", name=" .. proc.name .. ", status=" .. proc.status)
	wezterm.log_info(indent .. "argv=" .. table.concat(proc.argv, " "))
	wezterm.log_info(indent .. "executable=" .. proc.executable .. ", cwd=" .. proc.cwd)
	for pid, child in pairs(proc.children) do
		log_proc(child, indent .. "  ")
	end
end

wezterm.on("mux-is-process-stateful", function(proc)
	log_proc(proc)

	-- Just use the default behavior
	return nil
end)

-- This is where you actually apply your config choices

-- For example, changing the color scheme:

config.font = wezterm.font("FantasqueSansM Nerd Font Propo")
config.font_size = 14.0
config.default_prog = { "zsh" }
config.enable_tab_bar = true
config.enable_scroll_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_close_tab_button_in_tabs = true
config.color_scheme = "tokyonight_night"
config.pane_focus_follows_mouse = true
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.7,
}

config.set_environment_variables = {
	TERMINFO_DIRS = "$HOME/.nix-profile/share/terminfo",
	-- TERM = "xterm-256color",
}
config.term = "xterm-256color"
config.window_padding = { left = 10, right = 10, top = 5, bottom = 5 }

config.window_frame = {
	font = wezterm.font("FantasqueSansM Nerd Font Propo"),
	font_size = 12.0,
}

config.unix_domains = {
	{
		name = "unix",
	},
}

-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
config.default_gui_startup_args = { "connect", "unix" }

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
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
