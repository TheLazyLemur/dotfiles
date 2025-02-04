return {
	"nvim-focus/focus.nvim",
	config = function()
		require("focus").setup()
		vim.cmd("FocusDisable")
	end,
}
