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
	end,
}
