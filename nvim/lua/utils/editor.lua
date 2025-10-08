local Editor = {}

function Editor.set_keymaps(keymaps)
	local DEFAULT_OPTS = {
		noremap = true,
		silent = true,
	}

	for _, keymap in ipairs(keymaps) do
		local opts = vim.tbl_extend("force", DEFAULT_OPTS, keymap.opts or {})

		if keymap.desc then
			opts.desc = keymap.desc
		end

		vim.keymap.set(keymap.mode, keymap.keys, keymap.cmd, opts)
	end
end

return Editor
