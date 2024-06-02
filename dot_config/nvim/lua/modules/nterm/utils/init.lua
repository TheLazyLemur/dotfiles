local M = {}

M.is_buffer_valid = function(bufnr)
    return vim.api.nvim_buf_is_valid(bufnr)
end

M.close_current_win = function()
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_close(win, true)
end

M.set_window_float_size = function(win)
    local win_cfg = vim.api.nvim_win_get_config(win)

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)


    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    win_cfg.width = width
    win_cfg.height = height
    win_cfg.row = row
    win_cfg.col = col

    vim.api.nvim_win_set_config(win, win_cfg)
end

return M
