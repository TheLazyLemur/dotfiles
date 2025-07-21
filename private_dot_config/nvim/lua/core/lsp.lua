local servers = { "gopls", "templ", "lua_ls", "clangd", "ts_ls", "prismals", "omnisharp", "svelte-language-server" }
for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = "rounded"
    opts.width = math.floor(math.min(math.max(vim.o.columns * 0.4, 20), 80))
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})
