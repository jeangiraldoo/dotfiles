local OPTS = {
	dependencies_bin = {
		tinymist = "tinymist",
	},
}

return {
	src = "https://github.com/chomosuke/typst-preview.nvim",
	data = {
		enabled = true,
		setup = function()
			require("typst-preview").setup(OPTS)
		end,
	},
}
