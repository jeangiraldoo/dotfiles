return {
	{
		desc = "Print variable",
		mode = "n",
		keys = "<leader>dv",
		cmd = function()
			require("refactoring").debug.print_var()
		end,
	},
	{
		desc = "Go to next diagnostic",
		mode = "n",
		keys = "<leader>dn",
		cmd = vim.diagnostic.goto_next,
	},
	{
		desc = "Go to previous diagnostic",
		mode = "n",
		keys = "<leader>dN",
		cmd = vim.diagnostic.goto_prev,
	},
	{
		desc = "Display detailed info about the Treesitter node under the cursor",
		mode = "n",
		keys = "<leader>dt",
		cmd = function()
			local NUM_SPACES = 4
			local spaces = string.rep(" ", NUM_SPACES)

			local node = vim.treesitter.get_node()
			local node_text = vim.treesitter.get_node_text(node, 0)
			local node_type = node:type()
			local range = vim.treesitter.get_range(node, 0)
			local parent = node:parent():type()
			local child_count = node:child_count()

			-- One-based except end_column
			local start_row, start_column, end_row, end_column = range[1] + 1, range[2] + 1, range[4] + 1, range[5]

			local BODY_PATTERNS = {
				main = "Type: %s\nText: %s",
				family = "Family:\n" .. spaces .. "Parent type: %s\n" .. spaces .. "Child count: %s",
				range = "Range (row-column):\n" .. spaces .. "Starts %s-%s\n" .. spaces .. "Ends %s-%s",
			}
			local TITLE = "**Node information**"
			local sections = {
				BODY_PATTERNS.main:format(node_type, node_text),
				BODY_PATTERNS.family:format(parent, child_count),
				BODY_PATTERNS.range:format(start_row, start_column, end_row, end_column),
			}

			local body_text = table.concat(sections, "\n")
			vim.notify(TITLE, vim.log.levels.ERROR)
			vim.notify(body_text, vim.log.levels.WARN)
		end,
	},
}
