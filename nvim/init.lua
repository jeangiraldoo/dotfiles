vim.g.mapleader = " "
vim.lsp.set_log_level("debug")

local opts = {
	ruler = true,
	number = true,
	relativenumber = true,
	cursorline = true,
	scroll = 10,
	mouse = "",
	tabstop = 4,
	shiftwidth = 4,
	foldenable = true,
	foldmethod = "manual",
	foldcolumn = "1",
}

local autocmds = require("autocommands")
local keymaps = require("keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = { import = "plugins" },
	install = { colorscheme = { "tokyonight" } },
	checker = { enabled = true, notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"nvim-autopairs",
			},
		},
	},
});
(function()
	local opts_types = {
		keymaps,
		opts,
		autocmds,
	}
	local handlers = {
		[1] = function(desc, data)
			vim.keymap.set(data[1], data[2], data[3], { desc = desc })
		end,
		[2] = function(name, val)
			vim.opt[name] = val
		end,
		[3] = function(_, cmd_data)
			vim.api.nvim_create_autocmd(cmd_data.event, {
				pattern = cmd_data.pattern,
				command = cmd_data.command,
			})
		end,
	}
	vim.iter(opts_types):enumerate():each(function(idx, opt_type)
		vim.iter(opt_type):each(function(key, val)
			handlers[idx](key, val)
		end)
	end)
end)()
