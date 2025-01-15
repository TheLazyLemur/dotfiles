MiniDeps.add("williamboman/mason.nvim")
MiniDeps.add("neovim/nvim-lspconfig")

MiniDeps.add({
	source = "saghen/blink.cmp",
	depends = {
		"rafamadriz/friendly-snippets",
	},
	hooks = {
		post_checkout = function()
			vim.cmd("!cargo build --release")
		end,
	},
})

require("mason").setup()

require("blink.cmp").setup({
	completion = {
		menu = {
			border = "rounded",
		},
		documentation = {
			auto_show = true,
			window = {
				border = "rounded",
			},
		},
	},
	signature = {
		enabled = true,
		window = {
			border = "rounded",
		},
	},
	appearance = {
		use_nvim_cmp_as_default = true,
	},
})

local lspconfig = require("lspconfig")
local capabilities = require("blink.cmp").get_lsp_capabilities()
local servers = { "gopls", "templ", "lua_ls", "zls", "clangd", "ts_ls", "volar", "svelte", "zls" }
for _, server in ipairs(servers) do
	if server == "gopls" then
		require("lspconfig").gopls.setup({
			capabilities = capabilities,
			flags = {
				debounce_text_changes = 150,
			},
			settings = {
				gopls = {
					hints = {
						rangeVariableTypes = true,
						parameterNames = true,
						constantValues = true,
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						functionTypeParameters = true,
					},
				},
			},
		})

		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			pattern = "*.go",
			group = vim.api.nvim_create_augroup("user-lsp-enter", { clear = true }),
			callback = function()
				vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
			end,
		})
	else
		lspconfig[server].setup({
			flags = {
				debounce_text_changes = 150,
			},
			capabilities = capabilities,
		})
	end
end

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = "rounded"
	opts.width = math.min(opts.width or 80, 120)
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local function do_for_attached(cb)
	local ok, clients = pcall(vim.lsp.get_clients)
	if not ok then
		return
	end

	for _, client in pairs(clients) do
		if vim.lsp.buf_is_attached(0, client.id) then
			ok = pcall(cb)
			if not ok then
				error("could not format")
			end
			return
		end
	end
end

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	pattern = "*.go",
	group = vim.api.nvim_create_augroup("user-lsp-hold", { clear = true }),
	callback = function()
		do_for_attached(vim.lsp.buf.document_highlight)
	end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	pattern = "*.go",
	group = vim.api.nvim_create_augroup("user-lsp-moved", { clear = true }),
	callback = function()
		do_for_attached(vim.lsp.buf.clear_references)
	end,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})
