return {
    cmd = { "templ", "lsp" },
    filetypes = { "templ" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = {
        templ = {
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
}
