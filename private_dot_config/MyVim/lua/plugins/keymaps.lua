local dap = require("dap")
local dapui = require("dapui")
local mc = require("multicursor-nvim")
local kulala = require("kulala")

vim.keymap.set("n", "-", ":Oil<cr>")

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

vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<F1>', dap.step_into)
vim.keymap.set('n', '<F2>', dap.step_over)
vim.keymap.set('n', '<F3>', dap.step_out)
vim.keymap.set('n', '<F7>', dapui.toggle)

vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>B', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set Breakpoint' })

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>")
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>")
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>")
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>")

local ft_keymaps = {
    ["*.http"] = function(args)
        local bufnr = args.buf
        local opts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set("n", "<CR>", kulala.run, opts)
    end,
    ["*test.go"] = function(args)
        local bufnr = args.buf
        local opts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set("n", "<leader>tt", ":GoTestFile -v -F<CR>", opts)
        vim.keymap.set("n", "<leader>tf", ":GoTestFunc -v -F<CR>", opts)
        vim.keymap.set("n", "<leader>tc", ":GoTestSubCase -v -F<CR>", opts)
    end,
}

local augroup = vim.api.nvim_create_augroup("MyVim-FT-Plugin-Keymaps", { clear = true })
for key, value in pairs(ft_keymaps) do
    vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup,
        pattern = key,
        callback = value,
    })
end
