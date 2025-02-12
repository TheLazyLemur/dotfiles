return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"jay-babu/mason-nvim-dap.nvim",
		"leoluz/nvim-dap-go",
	},
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
}
