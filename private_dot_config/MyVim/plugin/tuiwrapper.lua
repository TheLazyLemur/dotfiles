local M = {}

local create_temp_buf = function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
    return buf
end

local create_centered_win = function(buf)
    local height = math.ceil(vim.o.lines * 0.8)
    local width = math.ceil(vim.o.columns * 0.8)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.ceil((vim.o.lines - height) / 2),
        col = math.ceil((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
    })

    return win
end

M.interactive_command_wrapper = function(cmd)
    local buf = create_temp_buf()
    local win = create_centered_win(buf)
    vim.api.nvim_set_current_win(win)
    vim.fn.termopen(cmd, {
        on_exit = function()
            pcall(vim.api.nvim_win_close, win, true)
        end
    })
end

vim.keymap.set("n", "<leader>g", function() M.interactive_command_wrapper("lazygit") end)
vim.keymap.set("n", "<leader>d", function() M.interactive_command_wrapper("lazydocker") end)

return M
