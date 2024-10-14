local termmy = require("builtin.termmy")
local bookmarks = require("builtin.bookmarks")
local spear = require("builtin.spear")
local uiselect = require("builtin.uiselect")

termmy.setup(function()
    local total_width = vim.o.columns
    local total_height = vim.o.lines

    local win_width = math.floor(total_width / 1.3)
    local win_height = math.floor(total_height / 1.5)

    local row = math.floor((total_height - win_height) / 2)
    local col = math.floor((total_width - win_width) / 2)

    return {
        relative = 'editor',
        row = row,
        col = col,
        width = win_width,
        height = win_height,
        style = 'minimal',
        border = 'rounded',
    }
end)

bookmarks.setup()
spear.setup()
uiselect.setup()

require("builtin.keymaps")
