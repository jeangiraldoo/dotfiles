return {
	src = "https://github.com/ThePrimeagen/refactoring.nvim",
	data = {
		enabled = true,
		keymaps = {
			{
				desc = "Extract occurrences of a selected expression to its own variable",
				mode = "x",
				keys = "<leader>rv",
				cmd = ":Refactor extract_var ",
			},
			{
				desc = "Replace all occurrences of a variable with its value",
				mode = "n",
				keys = "<leader>rV",
				cmd = ":Refactor inline_var<CR>",
			},
			{
				desc = "Extract code to a separate function",
				mode = "x",
				keys = "<leader>rf",
				cmd = ":Refactor extract ",
			},
			{
				desc = "Replace calls to the function declaration under the cursor with its body",
				mode = "n",
				keys = "<leader>rF",
				cmd = ":Refactor inline_func<CR>",
			},
		},
	},
}
