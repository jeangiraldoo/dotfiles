local OPTS = {
	dependencies_bin = {
		tinymist = "tinymist",
	},
}

---@type PluginSpec
return {
	src = "https://github.com/chomosuke/typst-preview.nvim",
	data = {
		enabled = true,
		setup = function()
			require("typst-preview").setup(OPTS)
		end,
	},
}
