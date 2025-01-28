return {
	"ray-x/go.nvim",
	dependencies = {
		"ray-x/guihua.lua",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("go").setup({})
	end,
}
