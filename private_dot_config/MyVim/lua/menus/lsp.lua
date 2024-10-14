return {
    {
        name = "Definition",
        cmd = function()
            vim.lsp.buf.definition()
        end,
        rtxt = "<leader>gd",
    },
    {
        name = "Implementation",
        cmd = function()
            vim.lsp.buf.implementation()
        end,
        rtxt = "<leader>gi",
    },
    {
        name = "References",
        cmd = function()
            vim.lsp.buf.references()
        end,
    },
    { name = "separator" },
    {
        name = "Hover",
        cmd = function()
            vim.lsp.buf.hover()
        end,
        rtxt = "K",
    },
    {
        name = "Code Actions",
        cmd = function()
            vim.lsp.buf.code_action()
        end,
        rtxt = "<leader>ca",
    },
    { name = "separator" },
    {
        name = "Rename",
        cmd = function()
            vim.lsp.buf.rename()
        end,
        rtxt = "<leader>rn",
    },
    {
        name = "Format",
        cmd = function()
            vim.lsp.buf.format()
        end,
        rtxt = "<leader>f",
    },
}
