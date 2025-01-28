return {
	"ray-x/go.nvim",
	dependencies = {
		"ray-x/guihua.lua",
		"nvim-treesitter/nvim-treesitter",
	},
	lazy = true,
	config = function()
		require("go").setup()
	end,
}
