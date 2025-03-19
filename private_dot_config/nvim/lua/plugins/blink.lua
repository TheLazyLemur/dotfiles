return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
        "williamboman/mason.nvim",
    },
    build = "cargo build --release",
    config = function()
        require("mason").setup()
        require("blink.cmp").setup({
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
    end,
}
