return {
	"olimorris/codecompanion.nvim",
	config = function()
		require("codecompanion").setup({
			adapters = {
				llama3 = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "deepseek-r1:14b", -- Give this adapter a different name to differentiate it from the default ollama adapter
						schema = {
							model = {
								default = "llama3:latest",
							},
							num_ctx = {
								default = 16384,
							},
							num_predict = {
								default = -1,
							},
						},
					})
				end,
			},
		})
	end,
}
