local wezterm = require("wezterm")
local utils = require("utils")
local keymaps = require("config.keymaps")

local config = wezterm.config_builder()

config.leader = {
	key = "Space",
	mods = "CTRL",
	timeout_milliseconds = 1000,
}

config.keys = keymaps
config.default_prog = (function()
	if utils.SYSTEM.OS_NAME == "windows" then
		return {
			"powershell.exe",
			"-nologo",
		}
	end
end)()

config.color_scheme = "Atelierlakeside (dark) (terminal.sexy)"
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.window_frame = {
	font = wezterm.font({ family = "Monocraft" }),
	font_size = 11,
}

config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

config.default_cursor_style = "BlinkingBar"
config.cursor_thickness = "300%"
config.colors = {
	tab_bar = {
		inactive_tab_edge = "red",
		background = "rgb(0, 0, 5, 0.1)",
	},
	cursor_bg = "purple",
}

config.font_dirs = { "fonts" }
config.font_size = 13
config.font = wezterm.font_with_fallback({
	"Monocraft",
})

return config
