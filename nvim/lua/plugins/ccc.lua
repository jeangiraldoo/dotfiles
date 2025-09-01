local function build_colour_map(template)
	local colours = {}
	for word, hex in pairs(template) do
		colours[word] = hex
		colours[string.upper(word)] = hex
	end
	return colours
end

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

return {
	name = "ccc",
	author = "uga-rosa",
	config = function()
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
}
