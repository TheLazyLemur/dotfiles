return {
  source = "folke/flash.nvim",
  config = function()
    require("flash").setup({
      modes = {
        search = {
          enabled = true,
        },
      },
    })
  end
}
