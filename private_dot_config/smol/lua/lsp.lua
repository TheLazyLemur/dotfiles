local M = {}

M.lsp_keymaps = function(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
end


M.setup = function(setup_mini)
    setup_mini = setup_mini or false

    local install_path = vim.fn.stdpath("config") .. "/pack/nvim/start/nvim-lspconfig"

    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({ "git", "clone", "https://github.com/neovim/nvim-lspconfig", install_path })
    end

    local servers = {
        lua_ls = {},
        gopls = {},
    }

    for server, config in pairs(servers) do
        require "lspconfig"[server].setup(vim.tbl_deep_extend("force", {
            on_attach = M.lsp_keymaps,
        }, config or {}))
    end


    if setup_mini == true then
        local mini_install_path = vim.fn.stdpath("config") .. "/pack/nvim/start/mini-completion"

        if vim.fn.empty(vim.fn.glob(mini_install_path)) > 0 then
            vim.fn.system({ "git", "clone", "https://github.com/echasnovski/mini.completion", mini_install_path })
        end

        require("mini.completion").setup()
    end
end


return M
