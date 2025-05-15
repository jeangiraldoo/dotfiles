local wezterm = require("wezterm")
local utils = require("utils")

return {
	leader = {
		key = "Space",
		mods = "CTRL",
		timeout_milliseconds = 1000,
	},
	keys = require("keymaps"),

	default_prog = utils.get_os_data("shell", {
		mode = true,
	}),

	window_decorations = "RESIZE",
	window_background_opacity = 0.8,
	window_frame = {
		font = wezterm.font({ family = "Monocraft" }),
		font_size = 11,
	},

	use_fancy_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	show_tab_index_in_tab_bar = false,
	show_new_tab_button_in_tab_bar = false,

	default_cursor_style = "BlinkingBar",
	cursor_thickness = "300%",
	colors = {
		tab_bar = {
			inactive_tab_edge = "red",
			background = "rgb(0, 0, 5, 0.1)",
		},
		cursor_bg = "purple",
	},

	font_dirs = { "fonts" },
	font_size = 13,
	font = wezterm.font_with_fallback({
		"Monocraft",
	}),
	color_scheme = "Atelierlakeside (dark) (terminal.sexy)",
}
