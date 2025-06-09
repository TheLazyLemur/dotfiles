local config_settings = require("settings")

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("MyVim-LSP-Format", { clear = true }),
    callback = function(params)
        if config_settings.formatting_enabled then
            if config_settings.format_on_save then
                vim.cmd("Format")
            else
                local choice = vim.fn.confirm("Would you like to format?", "&Yes\n&No", 1)
                if choice == 1 then
                    vim.cmd("Format")
                end
            end
        end

        if config_settings.linting_enabled then
            if config_settings.lint_on_save then
                vim.cmd("lua require('lint').try_lint()")
            else
                local choice = vim.fn.confirm("Would you like to lint?", "&Yes\n&No", 1)
                if choice == 1 then
                    vim.cmd("lua require('lint').try_lint()")
                end
            end
        end
    end,
})

vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = false, lsp_format = "fallback", range = range })
end, { range = true })
