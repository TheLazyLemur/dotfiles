---@type table<string, vim.lsp.Config>
local M = {}

M.gopls = {
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

M.lua_ls = {
    cmd = { "lua-language-server" },
    root_markers = {
        "init.lua",
    },
    filetypes = { "lua" },
    on_init = require("util").lua_ls_on_init,
}

M.clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_markers = { "meson.build", "CMakeLists.txt", ".git" },
}

M.prismals = {
    cmd = { "prisma", "language-server", "--stdio" },
    filetypes = { "prisma" },
    settings = {
        prisma = {},
    },
}

M.templ = {
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

M.ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    init_options = {
        hostInfo = "neovim",
    },
}

return M


