return {
	"folke/trouble.nvim",
	config = function()
		require("trouble").setup()
		vim.diagnostic.config({ virtual_text = true })
	end,
}
