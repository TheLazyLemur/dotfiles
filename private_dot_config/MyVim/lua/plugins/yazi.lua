return {
	"mikavilpas/yazi.nvim",
	config = function()
		require("yazi").setup({
			open_for_directories = false,
			floating_window_scaling_factor = 0.7,
			yazi_floating_window_winblend = 10,
		})
	end,
}
