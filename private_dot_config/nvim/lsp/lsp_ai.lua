local server_config = {
	memory = {
		file_store = { crawl = "~/.cache/lsp-ai/files" },
	},
	models = {
		model1 = {
			type = "ollama",
			model = "deepseek-coder",
		},
	},
}

return {
	cmd = { "lsp-ai", "--use-seperate-log-file" },
	filetypes = { "go", "gomod", "lua" },
	single_file_support = true,
	autostart = true,
	init_options = server_config,
}
