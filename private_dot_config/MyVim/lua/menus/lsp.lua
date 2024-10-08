return {
    {
        name = "Definition",
        cmd = vim.lsp.buf.definition,
    },
    {
        name = "Implementation",
        cmd = vim.lsp.buf.implementation,
    },
    {
        name = "References",
        cmd = vim.lsp.buf.references,
    },
    { name = "separator" },
    {
        name = "Hover",
        cmd = vim.lsp.buf.hover,
    },
    {
        name = "Code Actions",
        cmd = vim.lsp.buf.code_action,
    },
    { name = "separator" },
    {
        name = "Rename",
        cmd = vim.lsp.buf.rename,
    },
    {
        name = "Format",
        cmd = vim.lsp.buf.format,
    },
}
