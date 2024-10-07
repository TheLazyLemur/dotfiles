MiniDeps.add("williamboman/mason.nvim")

require("mason").setup()

MiniDeps.add("neovim/nvim-lspconfig")
local lspconfig = require("lspconfig")

local servers = { "gopls", "templ" }

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    flags = {
      debounce_text_changes = 150,
    }
  }
end
