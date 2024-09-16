vim.keymap.set("n", "<ESC>", ":nohl<CR>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set("n", "<leader>sg", function ()
    local pattern = vim.fn.input("Pattern: ")
    local cmd = ":grep " .. "'" .. pattern .. "'"
    vim.cmd(cmd)
end)

vim.keymap.set("n", "<leader>sf", function ()
    vim.cmd("FzfQuickfix")
end)
