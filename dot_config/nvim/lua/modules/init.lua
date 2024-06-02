local modules = {
    {
        m = "modules.bookmarks",
        config = function()
            require("modules.bookmarks").setup()
            vim.keymap.set("n", "<leader>ba", require("modules.bookmarks").bookmark_file)
            vim.keymap.set("n", "<leader>bs", require("modules.bookmarks").show_selection_ui)
        end
    },
    {
        m = "modules.nterm",
        config = function()
            require("modules.nterm").setup()
            vim.keymap.set("n", "<C-a>w", require("modules.nterm").toggle_terminal)
            vim.keymap.set("t", "<C-a>w", require("modules.nterm").toggle_terminal)
            for i = 1, 5, 1 do
                vim.keymap.set("n", "==" .. i, function() require("modules.nterm").toggle_terminal(i) end)
                vim.keymap.set("t", "==" .. i, function() require("modules.nterm").toggle_terminal(i) end)
            end
        end
    },
    {
        m = "modules.fs",
        config = function()
            vim.keymap.set("n", "-", require("modules.fs").spawn_buffer)
        end
    },
    {
        m = "modules.findit",
        config = function()
            local findit = require("modules.findit")
            findit.setup()
            vim.keymap.set("n", "<leader>sf", findit.find_files, { desc = "Test here" })
        end
    },
}

for _, module in pairs(modules) do
    require(module.m)
    pcall(module.config)
end
