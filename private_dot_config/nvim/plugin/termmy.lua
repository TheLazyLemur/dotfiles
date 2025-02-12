local TERMMY = {
	bufs = {},
}

TERMMY.toggle = function(dir, n)
	if n == nil then
		n = "default"
	end

	if not dir or dir == "" then
		dir = vim.fn.getcwd()
	end

	for _, value in pairs(TERMMY.bufs) do
		if vim.api.nvim_get_current_buf() == value then
			vim.api.nvim_win_close(TERMMY.win, true)
			return
		end
	end

	local is_new = TERMMY.bufs[n] == nil or not vim.api.nvim_buf_is_valid(TERMMY.bufs[n])

	local win_config = TERMMY.config_func()

	if is_new then
		TERMMY.bufs[n] = vim.api.nvim_create_buf(false, true)
	end

	TERMMY.win = vim.api.nvim_open_win(TERMMY.bufs[n], true, win_config)

	if is_new then
		vim.fn.termopen("zsh", { cwd = dir })
	else
		vim.api.nvim_win_set_buf(TERMMY.win, TERMMY.bufs[n])
	end

	vim.cmd("startinsert")
	TERMMY.buf = vim.api.nvim_get_current_buf()
end

TERMMY.setup = function(config_func)
	TERMMY.config_func = config_func
		or function()
			local cursor_pos = vim.fn.screenpos(0, vim.fn.line("."), vim.fn.col("."))
			local cfg = {
				relative = "editor",
				row = cursor_pos.row + 0,
				col = cursor_pos.col - 1,
				width = 60,
				height = 10,
				style = "minimal",
				border = "single",
			}
			return cfg
		end
end

TERMMY.setup(function()
	local total_width = vim.o.columns
	local total_height = vim.o.lines

	local win_width = math.floor(total_width / 1.3)
	local win_height = math.floor(total_height / 1.5)

	local row = math.floor((total_height - win_height) / 2)
	local col = math.floor((total_width - win_width) / 2)

	return {
		relative = "editor",
		row = row,
		col = col,
		width = win_width,
		height = win_height,
		style = "minimal",
		border = "rounded",
	}
end)

vim.keymap.set({ "n", "t" }, "<leader>tf", function()
	TERMMY.toggle(nil)
end)
for i = 1, 10 do
	vim.keymap.set({ "n", "t" }, "<leader>t" .. tostring(i), function()
		TERMMY.toggle(nil, "term-" .. tostring(i))
	end)
end

vim.keymap.set({ "n", "t" }, "<leader>tS", function()
	TERMMY.toggle(vim.fn.expand("%:p:h") .. "/", true)
end)
vim.keymap.set({ "n", "t" }, "<leader>tF", function()
	TERMMY.toggle(vim.fn.expand("%:p:h") .. "/", false)
end)

return TERMMY
