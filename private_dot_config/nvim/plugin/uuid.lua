local function gen_uuid()
	-- Generate UUID and convert to lowercase
	local handle = io.popen("uuidgen | tr '[:upper:]' '[:lower:]'")
	local result = handle:read("*a")
	handle:close()

	-- Remove trailing newlines from the result
	result = result:gsub("\n$", "")

	-- Get the current line where the cursor is located
	local line = vim.api.nvim_get_current_line()

	-- Get the cursor position
	local cursor_pos = vim.api.nvim_win_get_cursor(0) -- Get the cursor position
	local col = cursor_pos[2] -- Get the column index
	col = col + 1

	-- Insert the UUID to the right of the cursor
	local new_line = line:sub(1, col) .. result .. line:sub(col + 1)

	-- Set the modified line back to the buffer
	vim.api.nvim_set_current_line(new_line)
end

vim.api.nvim_create_user_command("UUID", gen_uuid, {})
