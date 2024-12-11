vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<left>", "<C-w>h")
vim.keymap.set("n", "<down>", "<C-w>j")
vim.keymap.set("n", "<up>", "<C-w>k")
vim.keymap.set("n", "<right>", "<C-w>l")

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

PICKER = "telescope"
vim.keymap.set("n", "<leader>sf", function()
    if PICKER == "mini" then
        vim.cmd("Pick files")
    else
        vim.cmd("Telescope find_files")
    end
end)
vim.keymap.set("n", "<leader>sg", function()
    if PICKER == "mini" then
        vim.cmd("Pick grep_live")
    else
        vim.cmd("Telescope live_grep")
    end
end)
vim.keymap.set("n", "<leader>gs", function()
    if PICKER == "mini" then
        vim.cmd("Pick grep")
    else
        vim.cmd("Telescope grep_string")
    end
end)
vim.keymap.set("n", "<leader><leader>", function()
    if PICKER == "mini" then
        vim.cmd("Pick buffers")
    else
        vim.cmd("Telescope buffers")
    end
end)

vim.keymap.set("t", "<leader><esc>", [[<C-\><C-n>]])

vim.keymap.set({ "n", "i" }, "<leader>c/", ":ReferencePoint<cr>")

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("MyVim-LSP-Attach-Keymaps", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        local opts = { noremap = true, silent = true, buffer = args.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    end,
})
