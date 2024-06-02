local later = MiniDeps.later
local dap = require 'dap'
local dapui = require 'dapui'

later(function()
  vim.keymap.set("n", "<leader>jj", function() require("flash").jump() end)
  vim.keymap.set("n", "<leader>jt", function() require("flash").treesitter() end)

  vim.keymap.set("n", "<leader>tt", require("neotest").run.run)
  vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end)
  vim.keymap.set("n", "<leader>ts", require("neotest").summary.open)

  vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
  vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
  vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
  vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
  vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
  vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)

  vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
  vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
  vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
  vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
  vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
  vim.keymap.set('n', '<leader>B', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
  end, { desc = 'Debug: Set Breakpoint' })
  vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
end)
