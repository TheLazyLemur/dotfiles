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

MiniDeps.add({
    source = "saghen/blink.cmp",
    checkout = 'v0.*'
})
require("blink.cmp").setup({
  keymap = {
    accept = '<C-y>',
    select_prev = { '<C-p>' },
    select_next = { '<C-n>' },
  },
  trigger = {
    signature_help = {
      enabled = true,
      blocked_trigger_characters = {},
      blocked_retrigger_characters = {},
      show_on_insert_on_trigger_character = true,
    },
  },
})
