local wezterm = require("wezterm")
local utils = require("utils")

local keymaps = utils.get_combined_module_tables("config.keymaps", {
	wezterm,
	utils,
})

return keymaps
