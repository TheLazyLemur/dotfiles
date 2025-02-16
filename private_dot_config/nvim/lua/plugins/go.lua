return {
	"ray-x/go.nvim",
	dependencies = {
		"ray-x/guihua.lua",
		"nvim-treesitter/nvim-treesitter",
		"catgoose/templ-goto-definition",
	},
	config = function()
		local has_run = false
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "go",
			callback = function()
				if has_run then
					return
				end
				require("go").setup({})
				has_run = true
			end,
		})
		require("templ-goto-definition").setup()
	end,
}
