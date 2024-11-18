local later = MiniDeps.later

later(function()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    MiniDeps.add("williamboman/mason.nvim")

    require("mason").setup()

    MiniDeps.add("neovim/nvim-lspconfig")
    local lspconfig = require("lspconfig")


    local servers = { "gopls", "templ", "lua_ls", "denols", "zls", "clangd" }

    for _, server in ipairs(servers) do
        lspconfig[server].setup {
            flags = {
                debounce_text_changes = 150,
            },
        }
    end

    MiniDeps.add({
        source = "saghen/blink.cmp",
        depends = {
            "rafamadriz/friendly-snippets"
        },
        hooks = { post_checkout = function() vim.cmd('!cargo build --release') end },
    })
    require("blink.cmp").setup({
        keymap = 'default',
        trigger = {
            signature_help = {
                enabled = true,
                blocked_trigger_characters = {},
                blocked_retrigger_characters = {},
                show_on_insert_on_trigger_character = true,
            },
        },
        windows = {
            autocomplete = {
                border = 'rounded',
            },
            documentation = {
                border = 'rounded',
                auto_show = true,
                auto_show_delay_ms = 500,
                update_delay_ms = 50,
            },
            signature_help = {
                border = 'rounded',
            },
        },
        nerd_font_variant = 'mono',
        highlight = {
            ns = vim.api.nvim_create_namespace('blink_cmp'),
            use_nvim_cmp_as_default = true,
        },
    })
end)

local function do_for_attached(cb)
    local ok, clients = pcall(vim.lsp.get_clients)
    if not ok then return end

    for _, client in pairs(clients) do
        if vim.lsp.buf_is_attached(0, client.id) then
            ok = pcall(cb)
            if not ok then error("could not format") end
            return
        end
    end
end

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("MyVim-LSP-Format", { clear = true }),
    callback = function() do_for_attached(vim.lsp.buf.format) end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    pattern = "*.go",
    group = vim.api.nvim_create_augroup("user-lsp-hold", { clear = true }),
    callback = function() do_for_attached(vim.lsp.buf.document_highlight) end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    pattern = "*.go",
    group = vim.api.nvim_create_augroup("user-lsp-moved", { clear = true }),
    callback = function() do_for_attached(vim.lsp.buf.clear_references) end,
})
