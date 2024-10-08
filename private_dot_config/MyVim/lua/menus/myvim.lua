return {
    {
        name = "Bookmark file",
        cmd = function()
            require("builtin.bookmarks").bookmark_file()
        end,
    },
    {
        name = "Open Bookmarks",
        cmd = function()
            require("builtin.bookmarks").show_selection_ui()
        end,
    },
    {
        name = "Toggle Terminal",
        cmd = function()
            local termmy = require("builtin.termmy")
            termmy.toggle(false, vim.fn.expand('%:p:h') .. '/')
        end,
    },
    {
        name = "Pick",
        hl = "Exblue",
        items = "pick",
    },
    {
        name = "LSP",
        hl = "Exblue",
        items = "lsp",
    },
}
