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
	foldcolumn = "1"
}

local autocmds = {
	["Load view"] = {
		event = "BufWinEnter",
		pattern = "*",
		command = "silent! loadview"
	},
	["Make view"] = {
		event = "BufWinLeave",
		pattern = "*",
		command = "silent! mkview"
	},
	["Update status bar diagnostics"] = {
		event = "DiagnosticChanged",
		command = "redrawstatus"
	}
}

local keymaps = {
	file = {
		["List refs"] = { "n", "<leader>rr", vim.lsp.buf.references },
		["Run current file"] = { "n", "<leader>l", ":luafile %<CR>" },
		["Close file"] = { "n", "<leader>q", ":q<CR>" },
		["Save file"] = { "n", "<leader>w", ":w<CR>" },
		["Saves and close file"] = { "n", "<leader>ww", ":wq<CR>" },
		["Vertical split"] = { "n", "<leader>sv", ": vsplit <CR>" },
		["Vertical split with Fuzzy Finder"] = { "n", "<leader>sV", ":vsplit<CR>:normal ;ff<CR>" },
		["Increase VSplit"] = { "n", "<C-Up>", ":vertical resize +3 <CR>" },
		["Decrease VSplit"] = { "n", "<C-Down>", ":vertical resize -3 <CR>" },
		["Copy to clipboard"] = { { "n", "v" }, "<leader>y", ":y+ <CR>" },
		["Paste from clipboard"] = { { "n", "v" }, "<leader>p", '"+p' },
		["Create fold"] = { { "n", "v" }, "<leader>fc", "zf" },
		["Delete fold"] = { { "n", "v" }, "<leader>fd", "zd" },
		["Toogle fold"] = { "n", "<leader>ft", "za" },
		-- ["Telescope find files"] = {"n", "<leader>ff", require("telescope.builtin").find_files}
	},
	core = {
		["Open plugin manager menu"] = { "n", "<leader>n", ":Lazy<CR>" },
		["Display messages"] = { "n", "<leader>m", ":messages<CR>" },
		["Open Neovim config"] = { { "n", "v" }, "<leader>.", function()
			local config_path = vim.fn.expand("~/.config/nvim/init.lua")
			local term_cmd = { "wezterm", "cli", "spawn" }
			local nvim_cmd = { "nvim", config_path }
			if vim.api.nvim_buf_get_name(0) == "" then
				vim.cmd("edit " .. config_path)
			else
				local final = vim.list_extend(term_cmd, nvim_cmd)
				vim.fn.jobstart(final, { detach = true })
			end
		end },
	},
	line = {
		["Swap lines above"] = { "n", "<leader>la", ":m .-2<cr>==" },
		["Swap lines below"] = { "n", "<leader>lb", ":m .+1<cr>==" },
		["Duplicate lines"] = { "v", "<leader>ld", ":y<CR>'>p" },
		["Duplicate line"] = { "n", "<leader>ld", ":t.<CR>" },
		["Add new empty line"] = { "n", "O", "o<Esc>" },
	},
	refactor = {
		["Rename symbol"] = { "n", "<leader>rn", vim.lsp.buf.rename },
		["Print variable"] = { "n", "<leader>rp", function() require('refactoring').debug.print_var() end },
	},
	code = {
		["Comment code"] = { { "n", "v" }, "<leader>cc", function()
			if vim.fn.mode():match("v") then
				local keys = vim.api.nvim_replace_termcodes("gc", true, false, true)
				vim.api.nvim_feedkeys(keys, "x", false)
			else
				vim.cmd("normal gcc")
			end
		end },
		["Insert docstring"] = { "n", "<leader>cd", "<plug>Codedocs" },
	}
}

keymaps = vim.tbl_deep_extend("force", unpack(vim.iter(keymaps):map(
	function(_, section_keymaps) return section_keymaps end):totable()
))

vim.o.statusline = (function()
	local highlights = {
		"git_hl guibg=#CA7D40 guifg=#ffffff",
		"git_corners guifg=#CA7D40",
		"corners guifg=#412ba3",
		"path_corners guifg=#005f00",
		"lines_info_left_hl guifg=#412ba3 guibg=#a32b3c",
		"lines_info_right_hl guifg=#412ba3",
		"line_info guibg=#412ba3",
		"path guifg=#ffffff guibg=#005f00",
		"file_hl guifg=#ffffff guibg=#a32b3c",
		"file_corner guifg=#a32b3c",
		"diagnostics_hl guifg=#ffffff guibg=#461D5A",
		"diagnostics_corner guifg=#461D5A"
	}
	vim.iter(highlights):each(function(a) vim.cmd("highlight " .. a) end)

	local function get_ln_end()
		local available_ln_ends = {
			dos = "CRLF",
			unix = "LF",
			mac = "CR"
		}
		return available_ln_ends[vim.bo.fileformat]
	end
	_G.get_diagnostics = function()
		local icons = {
			[1] = "❌",
			[2] = "☢️ ",
			[4] = "🤡"
		}
		local diagnostics = vim.diagnostic.count(0, {
			severity = {
				vim.diagnostic.severity.ERROR,
				vim.diagnostic.severity.WARN,
				vim.diagnostic.severity.HINT,
			}
		})
		local sects = vim.iter(icons):map(function(idx, icon)
			local data = diagnostics[idx] or "0"
			return icon .. data
		end):totable()
		local diagnostics_str = table.concat(sects, " ")
		return diagnostics_str
	end

	local ln_sects = {
		path = "%#path_corners#%#path#%F%{&modified?' ●':'  '}%#path_corners#",
		git = "%#git_corners#%#git_hl#%{FugitiveHead()}%#git_corners#",
		file_info = "%#file_corner#%#file_hl#" .. get_ln_end() .. "%{&readonly?'':''}",
		lines_info = "%#lines_info_left_hl#%#line_info#Col %c %p%%%#lines_info_right_hl#",
		diagnostics = "%#diagnostics_corner#%#diagnostics_hl#%{v:lua.get_diagnostics()}%#diagnostics_corner#"
	}

	local sect_order = {
		"path",
		"git",
		"file_info",
		"lines_info",
		"diagnostics"
	}
	local ln_str = table.concat(
		vim.iter(sect_order):map(function(name) return ln_sects[name] end):totable(),
		" "
	)
	return ln_str
end)()

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
			{ out,                            "WarningMsg" },
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
				"nvim-autopairs"
			}
		}
	}
})

; (function()
	local opts_types = {
		keymaps,
		opts,
		autocmds,
	}
	local handlers = {
		[1] = function(desc, data) vim.keymap.set(data[1], data[2], data[3], { desc = desc }) end,
		[2] = function(name, val) vim.opt[name] = val end,
		[3] = function(_, cmd_data)
			vim.api.nvim_create_autocmd(cmd_data.event, {
				pattern = cmd_data.pattern,
				command = cmd_data.command
			})
		end
	}
	vim.iter(opts_types):enumerate():each(function(idx, opt_type)
		vim.iter(opt_type):each(function(key, val) handlers[idx](key, val) end)
	end)
end)()
