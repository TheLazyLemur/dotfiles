local M = {
	lines = {},
	session_id = nil,
}

local build_initial_command = function(msg)
	return "claude --append-system-prompt 'Always respond in markdown format' --output-format json -p '" .. msg .. "'"
end

local build_command = function(msg, session)
	return "claude --append-system-prompt 'Always respond in markdown format' -r '" .. session .. "' -p '" .. msg .. "'"
end

M.send_message = function(msg)
	table.insert(M.lines, "")
	table.insert(M.lines, "")
	table.insert(M.lines, "### User")
	table.insert(M.lines, "")
	table.insert(M.lines, msg)
	table.insert(M.lines, "")
	table.insert(M.lines, "")

	table.insert(M.lines, "### Agent")
	table.insert(M.lines, "")
	if not M.session_id then
		local cmd = build_initial_command(msg)

		local handle = io.popen(cmd)
		if handle == nil then
			print("Error: Failed to execute command")
			return
		end

		local output = handle:read("*a")
		local success, pl = pcall(vim.json.decode, output)
		if not success then
			print("Error: Failed to parse JSON")
			return
		end

		M.session_id = pl.session_id

		-- Split result into lines and store in M.lines
		if pl.result then
			local new_lines = vim.split(pl.result, "\n")
			for _, line in ipairs(new_lines) do
				table.insert(M.lines, line)
			end
		end

		handle:close()
		return
	end

	if M.session_id ~= nil then
		local cmd = build_command(msg, M.session_id)

		local handle = io.popen(cmd)
		if handle == nil then
			print("Error: Failed to execute command")
			return
		end

		local output = handle:read("*a")

		local new_lines = vim.split(output, "\n")
		for _, line in ipairs(new_lines) do
			table.insert(M.lines, line)
		end

		handle:close()
		return
	end
end

M.display = function()
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)

	-- Set M.lines content to buffer if it exists
	if M.lines then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, M.lines)
	end

	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	-- Set buffer options
	vim.bo[buf].modifiable = false
	vim.bo[buf].readonly = true
	vim.bo[buf].filetype = "markdown"

	return win, buf
end

return M
