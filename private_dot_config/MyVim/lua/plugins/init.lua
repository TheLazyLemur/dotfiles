require("plugins.colorschemes")
local now, later = MiniDeps.now, MiniDeps.later

local plugins = {
	{
		source = "gpanders/editorconfig.nvim",
	},
	{
		source = "lewis6991/gitsigns.nvim",
		lazy = true,
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		source = "jake-stewart/multicursor.nvim",
		lazy = true,
		config = function()
			require("multicursor-nvim").setup()
			vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
			vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
			vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
			vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		end,
	},
	{
		source = "mfussenegger/nvim-dap",
		depends = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
			"leoluz/nvim-dap-go",
		},
		lazy = true,
		config = function()
			vim.fn.sign_define("DapBreakpoint", {
				text = " ",
				texthl = "NvimString",
				linehl = "NvimString",
				numhl = "NvimString",
			})

			vim.fn.sign_define("DapBreakpointCondition", {
				text = " ",
				texthl = "SpecialKey",
				linehl = "SpecialKey",
				numhl = "SpecialKey",
			})

			local dap = require("dap")
			local dapui = require("dapui")

			require("mason-nvim-dap").setup({
				automatic_installation = false,
				automatic_setup = true,
				handlers = {},
				ensure_installed = {
					"delve",
				},
			})
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
				controls = {
					icons = {
						pause = " ",
						play = " ",
						step_over = " ",
						step_into = "󰆹 ",
						step_out = "󰆸 ",
						step_back = " ",
						run_last = "󰑖 ",
						terminate = " ",
						disconnect = " ",
					},
				},
			})

			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			require("dap-go").setup()
		end,
	},
	{
		source = "nvim-treesitter/nvim-treesitter",
		depends = {
			"nvim-treesitter/nvim-treesitter-context",
		},
		lazy = true,
		checkout = "master",
		monitor = "main",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "go" },
				highlight = { enable = true },
			})
			require("treesitter-context").setup({})
		end,
	},
	{
		source = "mistweaverco/kulala.nvim",
		lazy = true,
		config = function()
			require("kulala").setup()
		end,
	},
	{
		source = "stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofumpt", "goimports", "goimports-reviser", "gofmt", "golines" },
					html = { "rustywind", "htmlbeautifier" },
					templ = { "rustywind", "templ", "htmlbeautifier" },
				},
			})

			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = false, lsp_format = "fallback", range = range })
			end, { range = true })

			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("MyVim-LSP-Format", { clear = true }),
				callback = function(params)
					local buf_name = vim.api.nvim_buf_get_name(params.buf)
					if not buf_name:match("bash") then
						vim.cmd("Format")
					end
				end,
			})
		end,
	},
	{
		source = "folke/trouble.nvim",
		lazy = true,
		cmd = "Trouble",
		config = function()
			require("trouble").setup()
		end,
	},
	{
		source = "ray-x/go.nvim",
		depends = {
			"ray-x/guihua.lua",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = true,
		config = function()
			require("go").setup()
		end,
	},
	{
		source = "mrjones2014/smart-splits.nvim",
		config = function()
			vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
			vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
			vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
			vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
			vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
		end,
	},
	{
		source = "catgoose/templ-goto-definition",
		config = function()
			require("templ-goto-definition").setup()
		end,
	},
	{
		source = "supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({})
		end,
	},
	{
		source = "nvim-telescope/telescope.nvim",
		depends = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").setup({})
		end,
	},
	{
		source = "rachartier/tiny-inline-diagnostic.nvim",
		lazy = true,
		config = function()
			vim.diagnostic.config({ virtual_text = false })
			require("tiny-inline-diagnostic").setup({
				options = {
					multilines = true,
				},
			})
		end,
	},
	{
		source = "nvim-neotest/neotest",
		depends = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"fredrikaverpil/neotest-golang",
		},
		lazy = true,
		config = function()
			local config = { -- Specify configuration
				testify_enabled = true,
			}
			require("neotest").setup({
				adapters = {
					require("neotest-golang")(config),
				},
			})
		end,
	},
	{
		source = "akinsho/bufferline.nvim",
		config = function()
			vim.opt.termguicolors = true
			require("bufferline").setup({
				options = {
					offsets = {
						{
							filetype = "NvimTree",
							separator = true,
						},
						{
							filetype = "neotest-summary",
							separator = true,
						},
					},
				},
			})
		end,
	},
	{
		source = "folke/flash.nvim",
		config = function()
			require("flash").setup({
				modes = {
					search = {
						enabled = true,
					},
				},
			})
		end,
	},
	{
		source = "utilyre/barbecue.nvim",
		version = "*",
		depends = {
			"SmiteshP/nvim-navic",
		},
		config = function()
			require("barbecue").setup({})
		end,
	},
	{
		source = "stevearc/oil.nvim",
		config = function()
			require("oil").setup()
		end,
	},
	{
		source = "nvim-tree/nvim-tree.lua",
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			vim.opt.termguicolors = true
			require("nvim-tree").setup({
				update_focused_file = {
					enable = true,
				},
			})
		end,
	},
	{
		source = "mikavilpas/yazi.nvim",
		config = function()
			require("yazi").setup({
				open_for_directories = false,
				keymaps = {
					show_help = "<f1>",
				},
			})
		end,
	},
}

for _, p in pairs(plugins) do
	if p.lazy then
		later(function()
			MiniDeps.add(p)
			if p.config ~= nil then
				local ok = pcall(p.config)
				if not ok then
					print("Failed to load plugin" .. p.source)
				end
			end
		end)
	else
		now(function()
			MiniDeps.add(p)
			if p.config ~= nil then
				local ok = pcall(p.config)
				if not ok then
					print("Failed to load plugin: " .. p.source)
				end
			end
		end)
	end
end

later(function()
	require("plugins.keymaps")
end)
