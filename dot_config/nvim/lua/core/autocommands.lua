local now = MiniDeps.now

now(function()
    vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight when yanking (copying) text",
        group = vim.api.nvim_create_augroup("user-highlight-yank", { clear = true }),
        callback = function()
            vim.highlight.on_yank()
        end,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
        callback = function(event)
            require("core.keymaps").lsp_maps(event)

            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    group = vim.api.nvim_create_augroup("user-lsp-hold", { clear = true }),
                    buffer = event.buf,
                    callback = vim.lsp.buf.document_highlight,
                })

                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    group = vim.api.nvim_create_augroup("user-lsp-moved", { clear = true }),
                    buffer = event.buf,
                    callback = vim.lsp.buf.clear_references,
                })
            end
        end,
    })

    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        group = vim.api.nvim_create_augroup("user-lsp-templ-ft", { clear = true }),
        pattern = "*.templ",
        callback = function(_)
            vim.cmd("setfiletype templ")
        end
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("user-lsp-autofmt", { clear = true }),
        pattern = "*",
        callback = function(_)
            local ok, clients = pcall(vim.lsp.get_clients)
            if not ok then
                return
            end

            for _, c in pairs(clients) do
                if vim.lsp.buf_is_attached(0, c.id) then
                    pcall(vim.lsp.buf.format)
                end
            end
        end
    })
end)
