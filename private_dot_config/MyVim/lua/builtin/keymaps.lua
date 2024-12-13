local termmy = require("builtin.termmy")
local spear = require("builtin.spear")
local wrapper = require("builtin.tuiwrapper")

vim.keymap.set({ "n", "t" }, "<leader>tf", function() termmy.toggle(nil) end)
vim.keymap.set({ "n", "t" }, "<leader>tff", function() termmy.toggle(nil, "hello") end)

vim.keymap.set({ "n", "t" }, "<leader>tS", function() termmy.toggle(vim.fn.expand('%:p:h') .. '/', true) end)
vim.keymap.set({ "n", "t" }, "<leader>tF", function() termmy.toggle(vim.fn.expand('%:p:h') .. '/', false) end)

vim.keymap.set("n", "<leader>mm", spear.throw)
vim.keymap.set("n", "<leader>ms", spear.pick)
vim.keymap.set("n", "<leader>md", function() spear.pick("delete") end)

vim.keymap.set("n", "<leader>g", function() wrapper.interactive_command_wrapper("lazygit") end)
vim.keymap.set("n", "<leader>d", function() wrapper.interactive_command_wrapper("lazydocker") end)
