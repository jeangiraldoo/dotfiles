local utils = require("utils")
local autocmds = utils.get_combined_module_tbls("autocommands")

for _, autocmd in ipairs(autocmds) do
	vim.api.nvim_create_autocmd(autocmd.event, {
		pattern = autocmd.pattern or "*",
		command = type(autocmd.cmd) == "string" and autocmd.cmd or nil,
		callback = type(autocmd.cmd) == "function" and autocmd.cmd or nil,
		desc = autocmd.desc,
	})
end
