local termmy = require("builtin.termmy")
vim.keymap.set({"n", "t"}, "<leader>ts", function() termmy.toggle(true) end)
vim.keymap.set({"n", "t"}, "<leader>tf", function() termmy.toggle(false) end)

vim.keymap.set({"n", "t"}, "<leader>tS", function() termmy.toggle(true, vim.fn.expand('%:p:h') .. '/') end)
vim.keymap.set({"n", "t"}, "<leader>tF", function() termmy.toggle(false, vim.fn.expand('%:p:h') .. '/') end)

vim.keymap.set("n", "<leader>ba", require("builtin.bookmarks").bookmark_file)
vim.keymap.set("n", "<leader>bs", require("builtin.bookmarks").show_selection_ui)


vim.keymap.set('n', '<leader>cc', function()
    require('builtin.compile').compile()
end, { desc = '[E]rror [C]ompile' })
