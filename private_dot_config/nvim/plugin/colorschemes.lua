vim.opt.background = "dark"

MiniDeps.add({
	name = "catppuccin",
	source = "catppuccin/nvim",
})
require("catppuccin").setup({})

MiniDeps.add({
	name = "rose-pine",
	source = "rose-pine/neovim",
})
require("rose-pine").setup({})

MiniDeps.add({
	name = "oxocarbon",
	source = "nyoom-engineering/oxocarbon.nvim",
})

MiniDeps.add({
	name = "vscode",
	source = "Mofiqul/vscode.nvim",
})

vim.cmd.colorscheme("oxocarbon")
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ffffff", bg = "None" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ffffff", bg = "None" })
vim.cmd("highlight LspInlayHint guifg=#6C7C3C")
