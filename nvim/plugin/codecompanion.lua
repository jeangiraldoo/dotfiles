local utils = require "utils"

vim.pack.add {
	-- Also nvim-treesitter, defined in its own file
	{
		src = "https://github.com/nvim-lua/plenary.nvim",
	},
	{
		src = "https://github.com/olimorris/codecompanion.nvim",
	},
}

require("codecompanion").setup {
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

					local final_prompt = string.format([[%s<prompt>%s</prompt>]], filetype_context, message)
					return final_prompt
				end,
			},
		},
	},
}

utils.editor.set_keymaps {
	{
		desc = "Toggle AI chat",
		mode = { "n", "v" },
		keys = "<leader>ta",
		cmd = function()
			utils.terminal.launch {
				cmd = "ollama serve",
				close_after_cmd = true,
			}
			vim.cmd "CodeCompanionChat Toggle"
		end,
	},
}
