return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged_enable = true,
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = {
			follow_files = true,
		},
		auto_attach = true,
		attach_to_untracked = false,
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
			ignore_whitespace = false,
			virt_text_priority = 100,
		},
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil,
		max_file_length = 40000,
		preview_config = {
			border = "rounded",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
	},
	config = function(_, opts)
		require("gitsigns").setup(opts)

		-- Rose-pine theme integration
		local function setup_highlights()
			-- Get rose-pine colors if available
			local colors = {}
			if pcall(require, "rose-pine.palette") then
				colors = require("rose-pine.palette")
			else
				-- Fallback colors matching rose-pine theme
				colors = {
					pine = "#31748f",
					rose = "#ebbcba",
					foam = "#9ccfd8",
					love = "#eb6f92",
					muted = "#6e6a86",
				}
			end

			-- Define gitsigns highlight groups with rose-pine colors
			vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colors.foam, bg = "NONE" })
			vim.api.nvim_set_hl(0, "GitSignsChange", { fg = colors.rose, bg = "NONE" })
			vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = colors.love, bg = "NONE" })
			vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = colors.love, bg = "NONE" })
			vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = colors.love, bg = "NONE" })
			vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = colors.muted, bg = "NONE" })

			-- Staged signs
			vim.api.nvim_set_hl(0, "GitSignsAddLn", { fg = colors.foam, bg = "NONE" })
			vim.api.nvim_set_hl(0, "GitSignsChangeLn", { fg = colors.rose, bg = "NONE" })
			vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { fg = colors.love, bg = "NONE" })

			-- Current line blame
			vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = colors.muted, bg = "NONE", italic = true })
		end

		-- Set up highlights immediately
		setup_highlights()

		-- Re-apply highlights when colorscheme changes
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = setup_highlights,
			desc = "Update gitsigns highlights for rose-pine theme",
		})
	end,
}
