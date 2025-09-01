return {
	name = "codecompanion",
	author = "olimorris",
	dependencies = {
		{
			name = "plenary",
			author = "nvim-lua",
		},
		{
			name = "nvim-treesitter",
			author = "nvim-treesitter",
			remove_name_suffix = true,
		},
	},
	opts = {
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
	},
}
