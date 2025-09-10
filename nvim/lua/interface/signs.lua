local SIGNS = {
	DapBreakpoint = {
		text = "●",
		texthl = "DapBreakpoint",
		linehl = "",
		numhl = "",
	},
	DapStopped = {
		text = "",
		texthl = "DapStopped",
	},
}

for sign_name, sign_opts in pairs(SIGNS) do
	vim.fn.sign_define(sign_name, sign_opts)
end
