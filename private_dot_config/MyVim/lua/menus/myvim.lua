local termmy = require("builtin.termmy")
local bookmarks = require("builtin.bookmarks")

return {
    {
        name = "Toggle Terminal",
        hl = "Exred",
        cmd = function()
            termmy.toggle(false, vim.fn.expand('%:p:h') .. '/')
        end,
    },
    { name = "separator" },
    {
        name = "File explorer",
        hl = "Exred",
        cmd = function()
            vim.cmd("Oil")
        end,
    },
    {
        name = "Pick",
        hl = "Exblue",
        items = "pick",
    },
    { name = "separator" },
    {
        name = "LSP",
        hl = "Exblue",
        items = "lsp",
    },
    {
        name = "Debug",
        hl = "Exblue",
        items = "debug",
    },
    { name = "separator" },
    {
        name = "Bookmark file",
        rtxt = "<leader>ba",
        cmd = function()
            bookmarks.bookmark_file()
        end,
    },
    {
        name = "Open Bookmarks",
        rtxt = "<leader>bs",
        cmd = function()
            bookmarks.show_selection_ui()
        end,
    },
    { name = "separator" },
    {
        name = "Git",
        hl = "Exblue",
        items = "gitsigns",
    },
}
