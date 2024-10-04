local servers = {
    gopls = {
        name = "gopls",
        cmd = { "gopls" },
        root_dir_fn = function() return vim.fs.root(0, { "go.work", "go.mod", ".git" }) end,
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
    },
}

local group = vim.api.nvim_create_augroup("UserLspStart", { clear = true })
for _, config in pairs(servers) do
    if vim.fn.executable(config.cmd[1]) ~= 0 then
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = config.filetypes,
            callback = function (ev)
                config.root_dir = config.root_dir_fn()
                vim.lsp.start(config, { bufnr = ev.buf })
            end,
        })
    end
end
