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

vim.cmd.colorscheme("oxocarbon")
