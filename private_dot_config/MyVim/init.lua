require("core")

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("user-lsp-hold", { clear = true }),
	callback = function()
		vim.lsp.buf.document_highlight()
	end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	group = vim.api.nvim_create_augroup("user-lsp-moved", { clear = true }),
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})
