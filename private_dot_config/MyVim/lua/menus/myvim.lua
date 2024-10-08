return {
    {
        name = "Toggle Terminal",
        hl = "ExRed",
        cmd = function()
            local termmy = require("builtin.termmy")
            termmy.toggle(false, vim.fn.expand('%:p:h') .. '/')
        end,
    },
    { name = "separator" },
    {
        name = "File explorer",
        hl = "Exwhite",
        cmd = function()
            vim.cmd("Oil")
        end,
    },
    {
        name = "Pick",
        hl = "Exyellow",
        items = "pick",
    },
    { name = "separator" },
    {
        name = "LSP",
        hl = "Exblue",
        items = "lsp",
    },
    { name = "separator" },
    {
        name = "Bookmark file",
        hl = "Exwhite",
        cmd = function()
            require("builtin.bookmarks").bookmark_file()
        end,
    },
    {
        name = "Open Bookmarks",
        hl = "Exwhite",
        cmd = function()
            require("builtin.bookmarks").show_selection_ui()
        end,
    },
    { name = "separator" },
    {
        name = "Git",
        hl = "Exblue",
        items = "gitsigns",
    },
}
