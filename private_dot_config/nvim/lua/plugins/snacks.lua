return {
	"folke/snacks.nvim",
	config = function()
		require("snacks").setup({
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			image = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true },
			picker = { enabled = true },
			quickfile = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		})
	end,
}
