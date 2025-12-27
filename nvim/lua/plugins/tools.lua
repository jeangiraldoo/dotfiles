local utils = require("utils")

---@type PluginSpec[]
return {
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
		data = {
			enabled = true,
			setup = function()
				require("gitsigns").setup({
					signcolumn = true,
					current_line_blame_opts = {
						delay = 0,
					},
					current_line_blame_formatter = "  <author> -> <summary> •  <author_time:%d-%b-%Y> • 󰜛 <abbrev_sha>",
					current_line_blame_formatter_nc = " Not commited yet",
					gh = true,
				})
			end,
			keymaps = {
				{
					desc = "Toggle inline Git blame",
					mode = "n",
					keys = "<leader>pb",
					cmd = ":Gitsigns toggle_current_line_blame<CR>",
				},
				{
					desc = "Open buffer Git blame",
					mode = "n",
					keys = "<leader>pB",
					cmd = ":Gitsigns blame<CR>",
				},
			},
		},
	},
	{
		src = "https://github.com/olimorris/codecompanion.nvim",
		data = {
			enabled = true,
			dependencies = {
				{ src = "https://github.com/nvim-lua/plenary.nvim" },
				-- Also nvim-treesitter, defined in its own file
			},
			setup = function()
				require("codecompanion").setup({
					log_level = "ERROR",
					display = {
						chat = {
							intro_message = "▶︎ Welcome back, commander ✨🤓! Press ? for options",
							show_settings = true,
							show_header_separator = true,
							separator = "⋰⋱",
							buffer_pin = " ",
							buffer_watch = "👀 ",
							window = {
								layout = "vertical",
								position = "right",
								opts = {
									number = false,
									relativenumber = false,
								},
							},
							token_count = function(tokens, adapter)
								local template = "(%sトークン)"
								local label = string.format(template, tokens)
								return label
							end,
						},
					},
					strategies = {
						chat = {
							roles = {
								llm = function(adapter)
									local model_name = string.gsub(adapter.model.name, ":(.*)", "")
									local title = model_name .. " 🤖"
									return title
								end,
								user = "自分",
							},
							adapter = {
								name = "ollama",
								model = "codellama:latest",
							},
							opts = {
								prompt_decorator = function(message, adapter, context)
									local filetype_context = string.format("Current filetype: %s. ", context.filetype)
										.. "Ignore this information if it's not relevant to the query."

									local final_prompt =
										string.format([[%s<prompt>%s</prompt>]], filetype_context, message)
									return final_prompt
								end,
							},
						},
					},
				})
			end,
			keymaps = {
				{
					desc = "Toggle AI chat",
					mode = { "n", "v" },
					keys = "<leader>ta",
					cmd = function()
						utils.terminal.launch({
							cmd = "ollama serve",
							close_after_cmd = true,
						})
						vim.cmd("CodeCompanionChat Toggle")
					end,
				},
			},
		},
	},
	{
		src = "https://github.com/mfussenegger/nvim-dap",
		data = {
			enabled = true,
			setup = function()
				local dap = require("dap")

				dap.adapters.python = {
					type = "executable",
					command = "python3",
					args = { "-m", "debugpy.adapter" },
				}

				dap.configurations.python = {
					{
						type = "python",
						request = "launch",
						name = "Launch current file",
						program = "${file}",
						pythonPath = "python3",
					},
				}
				vim.defer_fn(function()
					vim.api.nvim_set_hl(0, "DapBreakpoint", {
						fg = "#FF0000",
					})
					vim.api.nvim_set_hl(0, "DapStopped", {
						fg = "#00add6",
					})
				end, 50)

				vim.fn.sign_define("DapBreakpoint", {
					text = "●",
					texthl = "DapBreakpoint",
					linehl = "",
					numhl = "",
				})

				vim.fn.sign_define("DapStopped", {
					text = "",
					texthl = "DapStopped",
				})
			end,
			keymaps = {
				{
					desc = "Toggle debugger UI",
					mode = "n",
					keys = "<leader>dt",
					cmd = function()
						vim.cmd("DapViewToggle")
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>j", true, false, true), "n", true)
					end,
				},
				{
					name = "Start/resume debug session",
					mode = "n",
					keys = "<leader>dc",
					cmd = ":DapContinue<CR>",
				},
				{
					desc = "Toggle debugger breakpoint",
					mode = "n",
					keys = "<leader>db",
					cmd = ":DapToggleBreakpoint<CR>",
				},
				{
					desc = "Step debugger over",
					mode = "n",
					keys = "<leader>dj",
					cmd = ":DapStepOver<CR>",
				},
				{
					desc = "Step debugger into",
					mode = "n",
					keys = "<leader>dl",
					cmd = ":DapStepInto<CR>",
				},
				{
					desc = "Step debugger out",
					mode = "n",
					keys = "<leader>dh",
					cmd = ":DapStepOut<CR>",
				},
			},
		},
	},
	{
		src = "https://github.com/igorlfs/nvim-dap-view",
		data = {
			enabled = true,
			setup = function()
				require("dap-view").setup({})
			end,
		},
	},
	{
		src = "https://github.com/chomosuke/typst-preview.nvim",
		data = {
			enabled = true,
			setup = function()
				require("typst-preview").setup({
					dependencies_bin = {
						tinymist = "tinymist",
					},
				})
			end,
		},
	},
	{
		src = "https://github.com/uga-rosa/ccc.nvim",
		data = {
			enabled = true,
			setup = function()
				local ccc = require("ccc")

				local function build_colour_map(template)
					local colours = {}
					for word, hex in pairs(template) do
						colours[word] = hex
						colours[string.upper(word)] = hex
					end
					return colours
				end

				ccc.setup({
					bar_len = 40,
					point_char = "⋇",
					empty_point_bg = false,

					highlighter = {
						auto_enable = true,
						lsp = true,
					},
					pickers = {
						ccc.picker.custom_entries(build_colour_map({
							yellow = "#FFFF00",
							orange = "#FFA500",
							red = "#ff0000",
							pink = "#FFC0CB",
							magenta = "#FF00FF",
							purple = "#800080",
							blue = "#0000FF",
							cyan = "#00FFFF",
							green = "#00ff00",
							white = "#FFFFFF",
							gray = "#808080",
							black = "#000000",
						})),
						ccc.picker.hex,
						ccc.picker.hex_long,
						ccc.picker.hex_short,
						ccc.picker.css_rgb,
						ccc.picker.css_hsl,
						ccc.picker.css_hwb,
						ccc.picker.css_lab,
						ccc.picker.css_lch,
						ccc.picker.css_oklab,
						ccc.picker.css_oklch,
						ccc.picker.css_name,
						ccc.picker.defaults,
					},
				})
			end,
			keymaps = {
				{
					desc = "Open color picker",
					mode = { "n", "v" },
					keys = "<leader>tc",
					cmd = ":CccPick<CR>",
				},
			},
		},
	},
}
