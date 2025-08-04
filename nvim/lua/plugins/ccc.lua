local function build_colour_map(template)
	local colours = {}
	for word, hex in pairs(template) do
		colours[word] = hex
		colours[string.upper(word)] = hex
	end
	return colours
end

return {
	"https://github.com/uga-rosa/ccc.nvim",
	config = function()
		local colour_map = build_colour_map({
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
		})

		local ccc = require("ccc")
		ccc.setup({
			bar_len = 40,
			point_char = "⋇",
			empty_point_bg = false,

			highlighter = {
				auto_enable = true,
				lsp = true,
			},
			pickers = {
				ccc.picker.custom_entries(colour_map),
			},
		})
	end,
}
