return {
	{
		desc = "List references to symbol",
		mode = "n",
		keys = "<leader>sr",
		cmd = vim.lsp.buf.references,
	},
	{
		desc = "Go to symbol declaration",
		mode = "n",
		keys = "<leader>sd",
		cmd = vim.lsp.buf.definition,
	},
	{
		desc = "Go to call",
		mode = "n",
		keys = "<leader>sf",
		cmd = vim.lsp.buf.outgoing_calls,
	},
	{
		desc = "Toggle inlay hints",
		mode = "n",
		keys = "<leader>sh",
		cmd = function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end,
	},
	{
		desc = "Toggle word under the cursor",
		mode = "n",
		keys = "<leader>st",
		cmd = function()
			local word = vim.fn.expand("<cword>")

			local replacements = {
				["True"] = "False",
				["False"] = "True",
				["true"] = "false",
				["false"] = "true",

				["on"] = "off",
				["off"] = "on",
				["ON"] = "OFF",
				["OFF"] = "ON",

				["enabled"] = "disabled",
				["disabled"] = "enabled",

				["public"] = "private",
				["private"] = "public",

				["up"] = "down",
				["down"] = "up",

				["break"] = "continue",
				["continue"] = "break",

				["fg"] = "bg",
				["bg"] = "fg",
				["foreground"] = "background",
				["background"] = "foreground",

				["local"] = "remote",
				["remote"] = "local",

				["==="] = "!==",
				["!=="] = "===",

				["and"] = "or",
				["or"] = "and",
				["&&"] = "||",
				["||"] = "&&",

				["=="] = "!=",
				["!="] = "==",
				[">"] = "<",
				["<"] = ">",
				[">="] = "<=",
				["<="] = ">=",

				["++"] = "--",
				["--"] = "++",
			}
			local replacement = replacements[word]

			if replacement then
				vim.cmd.normal("ciw" .. replacement)
				return
			end
		end,
	},
	{
		desc = "Surround a visual selection with an opening/closing character pair",
		mode = { "x" },
		keys = "<leader>ls",
		cmd = [[:<C-u>lua require("custom.text_wrapping").surround.simple.RUN()<CR>]],
	},
	{
		desc = "Surround a visual selection with one or more opening/closing character pairs",
		mode = { "x" },
		keys = "<leader>lS",
		cmd = [[:<C-u>lua require("custom.text_wrapping").surround.extended()<CR>]],
	},
}
