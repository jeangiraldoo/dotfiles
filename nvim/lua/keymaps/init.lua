local utils = require("utils")
local keymaps = utils.get_combined_module_tbls("keymaps")

local default_opts = {
	noremap = true,
	silent = true,
}

for _, keymap in ipairs(keymaps) do
	local opts = vim.tbl_extend("force", default_opts, keymap.opts or {})

	if keymap.desc then
		opts.desc = keymap.desc
	end

	vim.keymap.set(keymap.mode, keymap.keys, keymap.cmd, opts)
end
