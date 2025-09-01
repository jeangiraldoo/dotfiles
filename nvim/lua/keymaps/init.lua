local utils = require("utils")
local keymaps = utils.get_combined_module_tbls("keymaps")

local opts = {
	noremap = true,
	silent = true,
}

for _, keymap in ipairs(keymaps) do
	opts.desc = keymap.desc or nil
	vim.keymap.set(keymap.mode, keymap.keys, keymap.cmd, opts)
end
