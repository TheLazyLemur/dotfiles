return {
  source = "nomnivore/ollama.nvim",
  depends = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("ollama").setup({})
    vim.keymap.set("n", "<leader>oo", ":<c-u>lua require('ollama').prompt()")
    vim.keymap.set("v", "<leader>oo", ":<c-u>lua require('ollama').prompt()")
    vim.keymap.set("n", "<leader>oG", ":<c-u>lua require('ollama').prompt()")
    vim.keymap.set("v", "<leader>oG", ":<c-u>lua require('ollama').prompt()")
  end,
}
