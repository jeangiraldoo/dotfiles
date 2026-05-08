vim.cmd "colorscheme catppuccin"

require("vim._core.ui2").enable {
	enable = true,
}

vim.diagnostic.config {
	float = {
		scope = "line",
		header = "診断メッセージ",
	},
	-- signs = false,
	severity_sort = true,
}

vim.api.nvim_set_hl(0, "PMenuMatch", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "PMenuMatchSel", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "YankLine", { bg = "#d79921", fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, fg = "#ff5555" })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { bg = "orange" })

vim.api.nvim_create_autocmd("BufWinEnter", { desc = "Load view", pattern = "*", command = "silent! loadview" })
vim.api.nvim_create_autocmd("BufWinLeave", { desc = "Make view", pattern = "*", command = "silent! mkview" })
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked line",
	pattern = "*",
	callback = function()
		vim.hl.on_yank {
			timeout = 200,
			higroup = "YankLine",
		}
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	desc = "Start Treesitter syntax highlight",
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
	desc = "Open help buffers in a vertical split",
	callback = function()
		if vim.bo.buftype == "help" then
			vim.cmd "wincmd L"
		end
	end,
})

local ns = vim.api.nvim_create_namespace "CursorAnimation"
vim.api.nvim_set_hl(0, "CursorAnimationStart", {
	bg = "#ff1f9d",
})

vim.api.nvim_set_hl(0, "CursorAnimationFade", {
	bg = "#2a9c45",
})

vim.api.nvim_set_hl(0, "CursorAnimationEnd", {
	bg = "#000000",
})

-- 2. Create function to create/update extmar
--
-- local function update_mark(id, row, col, hl)
-- 	pcall(vim.api.nvim_buf_set_extmark, 0, ns, row, col, {
-- 		id = id,
-- 		end_row = row,
-- 		end_col = col + 1,
-- 		hl_group = hl,
-- 	})
-- end
--
-- local function create_mark(row, col, hl)
-- 	local id = vim.api.nvim_buf_set_extmark(0, ns, row, col, {
-- 		end_row = row,
-- 		end_col = col + 1,
-- 		hl_group = hl,
-- 	})
--
-- 	return id
-- end
--
-- local function delete_mark(id)
-- 	vim.defer_fn(function()
-- 		pcall(vim.api.nvim_buf_del_extmark, 0, ns, id)
-- 	end, 200)
-- end
--
-- -- 3. Create function to validate positions
--
-- local function is_valid_pos(row, col)
-- 	local line_count = vim.api.nvim_buf_line_count(0)
--
-- 	if row < 0 or row >= line_count then
-- 		return false
-- 	end
--
-- 	local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]
--
-- 	if line == nil then
-- 		return false
-- 	end
--
-- 	if col < 0 or col >= #line then
-- 		return false
-- 	end
--
-- 	return true
-- end
--
-- -- 5. Create function to animate the cursor
--
-- local function animate(id, row, col)
-- 	vim.defer_fn(function()
-- 		update_mark(id, row, col, "CursorAnimationFade")
-- 	end, 200)
--
-- 	vim.defer_fn(function()
-- 		update_mark(id, row, col, "CursorAnimationEnd")
-- 	end, 400)
-- end
-- -- 4. Bind extmark function to CursorMoved autocommand
--
-- -- vim.api.nvim_create_autocmd("CursorMoved", {
-- -- 	callback = function()
-- -- 		local pos = vim.api.nvim_win_get_cursor(0)
-- -- 		local row = pos[1] - 1
-- -- 		local col = pos[2]
-- --
-- -- 		if not is_valid_pos(row, col) then
-- -- 			return
-- -- 		end
-- --
-- -- 		local id = vim.api.nvim_buf_set_extmark(0, ns, row, col, {
-- -- 			end_row = row,
-- -- 			end_col = col + 1,
-- -- 			hl_group = "CursorAnimationStart",
-- -- 		})
-- -- 		-- animate(id, row, col)
-- -- 		delete_mark(id)
-- -- 	end,
-- -- })
