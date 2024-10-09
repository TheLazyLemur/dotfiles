return {
    {
        name = "Definition",
        cmd = vim.lsp.buf.definition,
        rtxt = "<leader>gd",
    },
    {
        name = "Implementation",
        cmd = vim.lsp.buf.implementation,
        rtxt = "<leader>gi",
    },
    {
        name = "References",
        cmd = vim.lsp.buf.references,
    },
    { name = "separator" },
    {
        name = "Hover",
        cmd = vim.lsp.buf.hover,
        rtxt = "K",
    },
    {
        name = "Code Actions",
        cmd = vim.lsp.buf.code_action,
        rtxt = "<leader>ca",
    },
    { name = "separator" },
    {
        name = "Rename",
        cmd = vim.lsp.buf.rename,
        rtxt = "<leader>rn",
    },
    {
        name = "Format",
        cmd = vim.lsp.buf.format,
        rtxt = "<leader>f",
    },
}
