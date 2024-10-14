local termmy = require("builtin.termmy")
local bookmarks = require("builtin.bookmarks")
local compile = require("builtin.compile")
local spear = require("builtin.spear")

vim.keymap.set({"n", "t"}, "<leader>ts", function() termmy.toggle(true) end)
vim.keymap.set({"n", "t"}, "<leader>tf", function() termmy.toggle(false) end)

vim.keymap.set({"n", "t"}, "<leader>tS", function() termmy.toggle(true, vim.fn.expand('%:p:h') .. '/') end)
vim.keymap.set({"n", "t"}, "<leader>tF", function() termmy.toggle(false, vim.fn.expand('%:p:h') .. '/') end)

vim.keymap.set("n", "<leader>ba", bookmarks.bookmark_file)
vim.keymap.set("n", "<leader>bs", bookmarks.show_selection_ui)

vim.keymap.set('n', '<leader>cc', compile.compile, { desc = '[E]rror [C]ompile' })

vim.keymap.set("n", "<leader>mm", spear.throw)
vim.keymap.set("n", "<leader>ms", spear.pick)
vim.keymap.set("n", "<leader>md", function() spear.pick("delete") end)
