return {
	cmd = { "omnisharp", "-lsp" },
	filetypes = { "cs", "vb" },
	settings = {
		FormattingOptions = {
			EnableEditorConfigSupport = true,
			OrganizeImports = true,
		},
		MsBuild = {
			LoadProjectsOnDemand = true,
		},
		RoslynExtensionsOptions = {
			EnableAnalyzersSupport = true,
			EnableImportCompletion = true,
			AnalyzeOpenDocumentsOnly = true,
		},
		Sdk = {
			IncludePrereleases = true,
		},
	},
}
