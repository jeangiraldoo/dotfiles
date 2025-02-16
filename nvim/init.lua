-- Vanilla settings
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set scroll=10")
vim.cmd("set cursorline")
vim.cmd("highlight branch guifg=#ffffff guibg=#412ba3")
vim.cmd("highlight path guifg=#ffffff guibg=#005f00")
vim.cmd("set statusline=%#branch#\\[" .. "%{FugitiveHead()}" .. "\\]" .. "%#path#%F")
vim.cmd("set foldenable")
vim.cmd("set foldmethod=manual")
vim.opt["tabstop"] = 4
vim.opt["shiftwidth"] = 4
vim.opt.mouse = ""
vim.g.mapleader = ";"
vim.lsp.set_log_level("debug")

-- Vanilla keybinds
local map = vim.keymap.set
map("n", "<leader>l", ":luafile %<CR>")
map("n", "<leader>q", ":q<CR>", { desc = "Close file" })
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>ww", ":wq<CR>", { desc = "Saves the file" })

map("n", "O", "o<Esc>", { desc = "Adds a new empty line" })

map("n", "<leader>v", ": vsplit <CR>", { desc = "vsplit", silent = true })
map("n", "<leader>V", ":vsplit<CR>:normal ;ff<CR>", { desc = "vsplit with fuzzy finder" })
map("n", "<C-Up>", ":vertical resize +3 <CR>", { desc = "Increase vsplit", silent = true })
map("n", "<C-Down>", ":vertical resize -3 <CR>", { desc = "Decrease vsplit" })

map("n", "<leader>d", ":t.<CR>", { desc = "Duplicate current line", silent = true })
map("v", "<leader>d", ":y<CR>'>p", { desc = "Duplicate selected lines", silent = true })

map({ "n", "v" }, "<leader>y", ":y+ <CR>", { desc = "Copy to clipboard" })
map({ "n", "v", "i" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
map("n", "<leader>.", function()
	local config_path =
		vim.fn.expand(jit.os == "Windows" and "~/AppData/Local/nvim/init.lua" or "~/.config/nvim/init.lua")

	if jit.os == "Windows" then
		vim.fn.jobstart({ "wezterm", "cli", "spawn", "nvim", config_path }, { detach = true })
	else
		vim.fn.jobstart({ "wezterm", "cli", "spawn", "--new-tab", "nvim", config_path }, { detach = true })
	end
end, {
	noremap = true,
	silent = true,
	desc = "Open Neovim config",
})

-- Lazy package manager installation
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

-- Plugin setup
local specs = {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"java",
					"go",
					"cpp",
					"javascript",
					"rust",
					"ruby",
					"php",
					"kotlin",
					"typescript",
					"html",
					"css",
					"yaml",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd("colorscheme tokyonight")
		end,
	},
	{
		"OXY2DEV/markview.nvim",
		ft = { "markdown" },
	},
	{ "https://tpope.io/vim/fugitive.git" },
	{ "https://github.com/nvim-telescope/telescope.nvim" },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"saghen/blink.cmp",
		version = "0.11.0",
		opts = {
			keymap = {
				preset = "default",
				["<C-a>"] = { "accept" },
				["<C-j>"] = { "select_next" },
				["<C-k>"] = { "select_prev" },
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "monocraft",
			},
			sources = {
				default = { "lsp", "path", "buffer" },
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"nvzone/typr",
		dependencies = "nvzone/volt",
		opts = {},
		cmd = { "Typr", "TyprStats" },
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					yaml = { "prettier" },
					markdown = { "prettier" },
				},
				format_on_save = {
					timeout_ms = 1000,
					lsp_format = "fallback",
				},
				notify_on_error = true,
				notify_no_formatters = true,
				log_level = vim.log.levels.DEBUG,
			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
			require("lint").linters_by_ft = {
				lua = { "luacheck" },
			}
		end,
	},
}

require("lazy").setup({
	spec = specs,
	install = { colorscheme = { "tokyonight" } },
	checker = { enabled = true, notify = true },
})

-- Plugin keybinds
-- map("n", "<leader>k", require("codedocs").insert_docs, { desc = "Inserts a docstring into the buffer" })
map("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Telescope find files" })
