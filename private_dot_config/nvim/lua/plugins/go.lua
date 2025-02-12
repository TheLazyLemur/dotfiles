return {
	"ray-x/go.nvim",
	dependencies = {
		"ray-x/guihua.lua",
		"nvim-treesitter/nvim-treesitter",
		"catgoose/templ-goto-definition",
	},
	config = function()
		require("go").setup({})
		require("templ-goto-definition").setup()
	end,
}
