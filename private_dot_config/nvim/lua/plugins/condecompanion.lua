return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		{
			"ravitemer/mcphub.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			build = "npm install -g mcp-hub@latest",
			config = function()
				require("mcphub").setup()
			end,
		},
	},
	config = function()
		require("codecompanion").setup({
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						name = "copilot",
						schema = {
							model = {
								default = "claude-sonnet-4",
							},
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "copilot",
				},
				inline = {
					adapter = "copilot",
				},
				cmd = {
					adapter = "copilot",
				},
			},
			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						show_result_in_chat = true,
						make_vars = true,
						make_slash_commands = true,
					},
				},
			},
		})
	end,
}
