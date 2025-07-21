return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = {
        gopls = {
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
            analyses = {
                nilness = true,
                shadow = true,
                unreachable = true,
                unusedparams = true,
                unusedwrite = true,
            },
            staticcheck = true,
            usePlaceholders = true,
            semanticTokens = true,
        },
    },
}