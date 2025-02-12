return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate", -- Automatically update parsers
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "go", "json", "c_sharp", "javascript", "typescript", "markdown", "dart" },
			highlight = { enable = true },
		})
		require("treesitter-context").setup({})
	end,
}
