return {
  {
        name = "Pick Files",
        cmd = function()
            vim.cmd[[ Pick files ]]
        end,
  },
  {
        name = "Pick buffers",
        cmd = function()
            vim.cmd[[ Pick buffers ]]
        end,
  },
  {
        name = "Grep",
        cmd = function()
            vim.cmd("Pick grep")
        end,
  },
  {
        name = "Grep live",
        cmd = function()
            vim.cmd[[ Pick grep_live ]]
        end,
  },
  {
        name = "Grep cword",
        cmd = function()
            local word_under_cursor = vim.fn.expand("<cword>")
            local cmd = "Pick grep pattern='" .. word_under_cursor .. "'"
            vim.cmd(cmd)
        end,
  },
  {
        name = "Pick Help",
        cmd = function()
            local word_under_cursor = vim.fn.expand("<cword>")
            local cmd = "Pick grep pattern='" .. word_under_cursor .. "'"
            vim.cmd(cmd)
        end,
  },
}
