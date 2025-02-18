return {
	{
		name = "catppuccin",
		"catppuccin/nvim",
		config = function()
			require("catppuccin").setup({})
		end,
	},
	{
		name = "rose-pine",
		"rose-pine/neovim",
		config = function()
			require("rose-pine").setup({})
		end,
	},
	{
		name = "oxocarbon",
		"nyoom-engineering/oxocarbon.nvim",
		config = function()
			vim.cmd.colorscheme("oxocarbon")
			vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ffffff", bg = "None" })
			vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ffffff", bg = "None" })
			vim.cmd("highlight LspInlayHint guifg=#6C7C3C")
		end,
	},
	{
		name = "vscode",
		"Mofiqul/vscode.nvim",
		config = function() end,
	},
}
