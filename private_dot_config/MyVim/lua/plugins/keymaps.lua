vim.keymap.set("n", "-", ":Oil<cr>")

local mc = require("multicursor-nvim")
vim.keymap.set({ "n", "v" }, "<c-n>", function() mc.addCursor("*") end)
vim.keymap.set({ "n", "v" }, "<c-s>", function() mc.skipCursor("*") end)
vim.keymap.set({ "n", "v" }, "<leader>x", mc.deleteCursor)
vim.keymap.set({ "n", "v" }, "<c-q>", function()
    if mc.cursorsEnabled() then
        mc.disableCursors()
    else
        mc.addCursor()
    end
end)

vim.keymap.set("n", "<leader><esc>", function()
    if not mc.cursorsEnabled() then
        mc.enableCursors()
    elseif mc.hasCursors() then
        mc.clearCursors()
    end
end)

vim.keymap.set("v", "I", mc.insertVisual)
vim.keymap.set("v", "A", mc.appendVisual)
vim.keymap.set("v", "M", mc.matchCursors)

local dap = require 'dap'
local dapui = require 'dapui'

vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<F1>', dap.step_into)
vim.keymap.set('n', '<F2>', dap.step_over)
vim.keymap.set('n', '<F3>', dap.step_out)
vim.keymap.set('n', '<F7>', dapui.toggle)

vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>B', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set Breakpoint' })

vim.keymap.set("n", "<C-t>", function()
    require("menu").open("myvim")
end, {})

vim.keymap.set("n", "<RightMouse>", function()
    vim.cmd.exec '"normal! \\<RightMouse>"'

    local options = vim.bo.ft == "NvimTree" and "nvimtree" or "myvim"
    require("menu").open(options, { mouse = true })
end, {})

local augroup = vim.api.nvim_create_augroup("MyVim-FT-Keymaps", { clear = true })
local ft_keymaps = {
    ["*.http"] = function()
        vim.keymap.set("n", "<CR>", "<cmd>lua require('kulala').run()<cr>", { noremap = true, silent = true, buffer = 0 })
    end,
}

for key, value in pairs(ft_keymaps) do
    vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup,
        pattern = key,
        callback = value,
    })
end
