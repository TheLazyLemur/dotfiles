local M = {}

M.compile = function()
    require('error-jump').compile()
    vim.cmd("stopinsert")
    vim.keymap.set('n', '<cr>', function() M.open("vsplit") end, { desc = '[E]rror [S]ource', buffer = 0 })
    vim.keymap.set('n', '<C-n>', require('error-jump').next_error, { desc = '[E]rror [N]ext', buffer = 0 })
    vim.keymap.set('n', '<C-p>', require('error-jump').next_error, { desc = '[E]rror [N]previous', buffer = 0 })
end

M.open = function(split)
    if split then
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd(split)
        vim.api.nvim_win_set_cursor(0, cursor_pos)
    end

    require('error-jump').jump_to_error()
end

return M
