return {
	{
		desc = "List references to symbol",
		mode = "n",
		keys = "<leader>cr",
		cmd = vim.lsp.buf.references,
	},
	{
		desc = "Go to symbol declaration",
		mode = "n",
		keys = "<leader>cd",
		cmd = vim.lsp.buf.definition,
	},
	{
		desc = "Go to call",
		mode = "n",
		keys = "<leader>cf",
		cmd = vim.lsp.buf.outgoing_calls,
	},
	{
		desc = "Go to next word occurrence",
		mode = "n",
		keys = "<leader>cn",
		cmd = function()
			require("illuminate").goto_next_reference(true)
		end,
	},
	{
		desc = "Go to previous word occurrence",
		mode = "n",
		keys = "<leader>cN",
		cmd = function()
			require("illuminate").goto_prev_reference(true)
		end,
	},
	{
		desc = "Toggle inlay hints",
		mode = "n",
		keys = "<leader>ch",
		cmd = function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end,
	},
	{
		desc = "Insert code annotation",
		mode = "n",
		keys = "<leader>ca",
		cmd = "<plug>Codedocs",
	},
	{
		desc = "Toggle word under the cursor",
		mode = "n",
		keys = "<leader>ct",
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

			vim.cmd.normal("viw~")
		end,
	},
}
