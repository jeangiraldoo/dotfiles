local utils = {}

function utils.get_combined_module_tables(dir)
	local full_path = vim.fn.stdpath("config") .. "/lua/" .. dir:gsub("%.", "/")
	local dir_files = vim.fn.readdir(full_path)

	local combined_entries = vim.iter(dir_files)
		:filter(function(file_name)
			return file_name:match("%.lua$") and not file_name:match("^init%.lua$")
		end)
		:fold({}, function(acc, file_name)
			-- local file_relative_path = dir .. "." .. file_name:gsub("%.lua$", "")
			local file_relative_path = dir .. "." .. file_name:gsub("%.lua$", "")

			local ok, file_tbl = pcall(require, file_relative_path)
			if ok and type(file_tbl) == "table" then
				return vim.list_extend(acc, file_tbl)
			else
				vim.notify("Failed to load " .. file_relative_path, vim.log.levels.WARN)
				return acc
			end
		end)

	return combined_entries
end

function utils.run_in_project_root(cli_cmd)
	local root = vim.fs.root(0, ".git")

	if root then
		local full_cmd = "cd " .. vim.fn.shellescape(root) .. " && " .. cli_cmd .. " " .. root
		local output_lines = vim.fn.systemlist(full_cmd)
		local final_output = table.concat(output_lines, "\n")

		return root, final_output
	else
		vim.notify("Project root not found", vim.log.levels.WARN)
	end
end

return utils
