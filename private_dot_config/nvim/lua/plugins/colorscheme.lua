return {
    {
        name = "rose-pine",
        "rose-pine/neovim",
        dependencies = {},
        priority = 1000,
        config = function()
            -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            -- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
            -- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
            --
            -- vim.api.nvim_create_autocmd("ColorScheme", {
            --     pattern = "*",
            --     callback = function()
            --         vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            --         vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            --         vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
            --         vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
            --     end,
            -- })
            require("rose-pine").setup({})
            vim.cmd.colorscheme("rose-pine")
            vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ffffff", bg = "None" })
            vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ffffff", bg = "None" })
            -- vim.cmd("highlight LspInlayHint guifg=#6C7C3C")
            vim.cmd("highlight Pmenu guibg=NONE guifg=NONE")
        end,
    },
}
