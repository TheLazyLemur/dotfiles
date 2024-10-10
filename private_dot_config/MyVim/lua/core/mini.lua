local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.deps'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.deps`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.deps', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.deps | helptags ALL')
  vim.cmd('echo "Installed `mini.deps`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

MiniDeps.add("echasnovski/mini.statusline")
require("mini.statusline").setup()

MiniDeps.add("echasnovski/mini.basics")
require("mini.basics").setup()

MiniDeps.add("echasnovski/mini.icons")
require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()

MiniDeps.add("echasnovski/mini.extra")
require("mini.extra").setup()

MiniDeps.add("echasnovski/mini.pick")
require("mini.pick").setup()
vim.ui.select = require("mini.pick").ui_select

MiniDeps.add("echasnovski/mini.hipatterns")
local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
    todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
    note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

MiniDeps.add("echasnovski/mini.jump2d")
require('mini.jump2d').setup()
