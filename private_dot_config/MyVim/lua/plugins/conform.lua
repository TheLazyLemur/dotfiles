return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gofumpt", "goimports", "goimports-reviser", "gofmt", "golines" },
				html = { "rustywind", "htmlbeautifier" },
				templ = { "rustywind", "templ", "htmlbeautifier" },
			},
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

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("MyVim-LSP-Format", { clear = true }),
			callback = function(params)
				local buf_name = vim.api.nvim_buf_get_name(params.buf)
				if not buf_name:match("bash") then
					vim.cmd("Format")
				end
			end,
		})
	end,
}
