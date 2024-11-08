vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "ss", "<C-w>s")
vim.keymap.set("n", "sv", "<C-w>v")

vim.keymap.set("n", "<esc>", function() vim.cmd("nohlsearch") end)

vim.keymap.set("n", "qq", ":q!<cr>")
vim.keymap.set("n", "qw", ":wq<cr>")

vim.keymap.set("n", "<leader>zz", require("mini.misc").zoom)

vim.keymap.set("n", "<leader>sf", ":Pick files<cr>")
vim.keymap.set("n", "<leader>sg", ":Pick grep_live<cr>")
vim.keymap.set("n", "<leader>gs", ":Pick grep<cr>")
vim.keymap.set("n", "<leader><leader>", ":Pick buffers<cr>")

vim.keymap.set("t", "<leader><esc>", [[<C-\><C-n>]])

vim.keymap.set({ "n", "i" }, "<leader>/", ":ReferencePoint<cr>")

local lsp_keymaps = function(args)
    local bufnr = args.buf
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
end

local augroup = vim.api.nvim_create_augroup("MyVim-FT-Builtin-Keymaps", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = lsp_keymaps,
})
