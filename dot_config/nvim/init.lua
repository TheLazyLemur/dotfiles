vim.g.mapleader = " "
vim.g.maplocalleader = " "

local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd("echo 'Installing `mini.nvim`' | redraw")
  local clone_cmd = {
    "git", "clone", "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim", mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd("echo 'Installed `mini.nvim`' | redraw")
end

require("mini.deps").setup({ path = { package = path_package } })

require("core")
require("extra")
require("modules")

-- vim.opt.rtp:append("/Users/danielrousseau/Workspace/dude.nvim")
-- local findit = require("dude").setup()
-- vim.keymap.set("n", "<leader>sf", function() findit.open_ui(findit.builtin.find_files) end)
-- vim.keymap.set("n", "<leader>sg", function() findit.open_ui(findit.builtin.live_grep) end)

-- vim: ts=2 sts=2 sw=2 et
