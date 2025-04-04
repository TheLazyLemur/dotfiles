return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
        "williamboman/mason.nvim",
        "zbirenbaum/copilot.lua",
        "giuxtaposition/blink-cmp-copilot",
    },
    build = "cargo build --release",
    config = function()
        require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
        })
        require("mason").setup()
        require("blink.cmp").setup({
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "copilot" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                    },
                },
            },
            completion = {
                menu = {
                    border = "rounded",
                },
                documentation = {
                    auto_show = true,
                    window = {
                        border = "rounded",
                    },
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                },
            },
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "BlinkCmpMenuOpen",
            callback = function()
                vim.b.copilot_suggestion_hidden = true
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "BlinkCmpMenuClose",
            callback = function()
                vim.b.copilot_suggestion_hidden = false
            end,
        })
    end,
}
