return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",
	dependencies = { "rafamadriz/friendly-snippets" },
}
-- local ls = require("luasnip")
-- require("luasnip.loaders.from_vscode").lazy_load()
-- vim.keymap.set({ "i" }, "<C-u>", function() ls.expand() end, { silent = true })
-- vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
-- vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })
--
-- -- vim.keymap.set({ "i" }, "<C-u>", function()
-- -- 	print("Mapping triggered")
-- -- end, { silent = true })
-- vim.keymap.set({ "i", "s" }, "<C-E>", function()
-- 	if ls.choice_active() then
-- 		ls.change_choice(1)
-- 	end
-- end, { silent = true })
-- local s = ls.snippet
-- local t = ls.text_node
-- local i = ls.insert_node
-- ls.add_snippets("all", {
-- 	s("fn", {
-- 		t('require("'), i(1, ""), t('")')
-- 		-- t("function("), i(1, ""), t({ ")", "end", "hola" })
-- 	})
-- })

