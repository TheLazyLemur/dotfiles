return {
	"folke/snacks.nvim",
	config = function()
		MY_OPTS.vscode_bordered = {
			preview = false,
			layout = {
				backdrop = false,
				row = 2,
				width = 0.4,
				min_width = 80,
				height = 0.4,
				border = "none",
				box = "vertical",
				{
					win = "input",
					height = 1,
					border = "rounded",
					title = "{title} {live} {flags}",
					title_pos = "center",
				},
				{ win = "list", border = "rounded" },
				{ win = "preview", title = "{preview}", border = "rounded" },
			},
		}

		MY_OPTS.vertical = {
			layout = {
				backdrop = false,
				width = 0.7,
				min_width = 80,
				height = 0.8,
				min_height = 30,
				box = "vertical",
				border = "rounded",
				title = "{title} {live} {flags}",
				title_pos = "center",
				{ win = "input", height = 1, border = "bottom" },
				{ win = "list", border = "none", height = 0.3 },
				{ win = "preview", title = "{preview}", height = 0.5, border = "top" },
			},
		}

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
