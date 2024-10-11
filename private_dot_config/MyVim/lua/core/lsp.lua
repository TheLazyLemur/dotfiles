vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

MiniDeps.add("williamboman/mason.nvim")

require("mason").setup()

MiniDeps.add("neovim/nvim-lspconfig")
local lspconfig = require("lspconfig")

local servers = { "gopls", "templ", "lua_ls" }

for _, server in ipairs(servers) do
    lspconfig[server].setup {
        flags = {
            debounce_text_changes = 150,
        },
    }
end

MiniDeps.add({
    source = "saghen/blink.cmp",
    checkout = 'v0.*',
    depends = {
        "rafamadriz/friendly-snippets"
    }
})
require("blink.cmp").setup({
    keymap = {
        accept = '<C-y>',
        select_prev = { '<C-p>' },
        select_next = { '<C-n>' },
    },
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
            draw = 'reversed',
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
