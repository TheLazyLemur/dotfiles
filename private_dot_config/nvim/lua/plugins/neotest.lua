return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        -- "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "fredrikaverpil/neotest-golang",
    },
    config = function()
        local config = {
            testify_enabled = true,
            dap_go_enabled = true,
        }
        require("neotest").setup({
            adapters = {
                require("neotest-golang")(config),
            },
        })
    end,
}
