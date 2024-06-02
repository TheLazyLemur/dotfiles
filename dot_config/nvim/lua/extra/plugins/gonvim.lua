return {
  source = "ray-x/go.nvim",
  depends = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("go").setup({
    })
    _GO_NVIM_CFG.lsp_inlay_hints.enable = false
  end,
}
