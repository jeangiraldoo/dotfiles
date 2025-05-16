return vim.tbl_deep_extend(
	"force",
	unpack(vim.iter({
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
			["Open Neovim config"] = {
				{ "n", "v" },
				"<leader>.",
				function()
					local config_path = vim.fn.expand("~/.config/nvim/init.lua")
					local term_cmd = { "wezterm", "cli", "spawn" }
					local nvim_cmd = { "nvim", config_path }
					if vim.api.nvim_buf_get_name(0) == "" then
						vim.cmd("edit " .. config_path)
					else
						local final = vim.list_extend(term_cmd, nvim_cmd)
						vim.fn.jobstart(final, { detach = true })
					end
				end,
			},
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
			["Print variable"] = {
				"n",
				"<leader>rp",
				function()
					require("refactoring").debug.print_var()
				end,
			},
		},
		code = {
			["Comment code"] = {
				{ "n", "v" },
				"<leader>cc",
				function()
					if vim.fn.mode():match("v") then
						local keys = vim.api.nvim_replace_termcodes("gc", true, false, true)
						vim.api.nvim_feedkeys(keys, "x", false)
					else
						vim.cmd("normal gcc")
					end
				end,
			},
			["Insert docstring"] = { "n", "<leader>cd", "<plug>Codedocs" },
		},
	})
		:map(function(_, section_keymaps)
			return section_keymaps
		end)
		:totable())
)
