return {
  source = "folke/trouble.nvim",
  lazy = true,
  depends = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup({
      auto_preview         = false,
      padding              = false,
      multiline            = false,
      icons                = false,
      use_diagnostic_signs = false,
      severity             = vim.diagnostic.severity.ERROR,
    })
  end,
}
