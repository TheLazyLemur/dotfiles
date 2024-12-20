require("core")
require("plugins")

vim.keymap.set("n", "<leader>ss", function()
    local current_win = vim.api.nvim_get_current_win()
    vim.cmd('wincmd J')
    vim.cmd('split')
    vim.api.nvim_set_current_win(current_win)
end)
