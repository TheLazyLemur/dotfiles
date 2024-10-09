return {
    {
        name = "Toggle Terminal",
        hl = "Exred",
        cmd = function()
            local termmy = require("builtin.termmy")
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
    { name = "separator" },
    {
        name = "Bookmark file",
        rtxt = "<leader>ba",
        cmd = function()
            require("builtin.bookmarks").bookmark_file()
        end,
    },
    {
        name = "Open Bookmarks",
        rtxt = "<leader>bs",
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
