return {
  source = "nvim-neotest/neotest",
  lazy = true,
  depends = {
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-go",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter"
  },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("neotest").setup({
      adapters = {
        require("neotest-go")({}),
      },
    })
  end
}
