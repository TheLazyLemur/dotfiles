return {
	"folke/trouble.nvim",
	dependencies = {
		"rachartier/tiny-inline-diagnostic.nvim",
	},
	config = function()
		require("trouble").setup()
		vim.diagnostic.config({ virtual_text = false })
		require("tiny-inline-diagnostic").setup({
			options = {
				multilines = true,
			},
		})
	end,
}
