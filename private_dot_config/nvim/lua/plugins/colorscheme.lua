return {
	{
		"alexxGmZ/e-ink.nvim",
		dependencies = {
			{
				name = "oxocarbon",
				"nyoom-engineering/oxocarbon.nvim",
			},
			{
				"rebelot/kanagawa.nvim",
			},
			{
				name = "rose-pine",
				"rose-pine/neovim",
			},
			{
				name = "catppuccin",
				"catppuccin/nvim",
			},
			{
				name = "vscode",
				"Mofiqul/vscode.nvim",
			},
		},
		priority = 1000,
		config = function()
			-- Apply transparency to key highlight groups
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
			vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

			-- (Optional) Ensure transparency is reapplied if you change your colorscheme:
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
					vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
					vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
					vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
				end,
			})
			require("kanagawa").setup()
			require("rose-pine").setup({})
			require("e-ink").setup()
			require("vscode").setup()
			require("catppuccin").setup()

			vim.cmd.colorscheme("kanagawa-dragon")

			vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ffffff", bg = "None" })
			vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ffffff", bg = "None" })
			-- vim.cmd("highlight LspInlayHint guifg=#6C7C3C")
			vim.cmd("highlight Pmenu guibg=NONE guifg=NONE")
		end,
	},
}
