local M = {}

-- Define a table to hold bookmarks
--- @type string[]
local bookmarks = {}

function M.add_bookmark()
    local file = vim.fn.expand("%:p")
    local line = vim.fn.line(".")
    local bookmark = string.format("%s:%d", file, line)
    table.insert(bookmarks, bookmark)
    print("Bookmark added at " .. bookmark)
end

function M.open_bookmark_at_line()
    local line = vim.fn.line(".")
    local bookmark = bookmarks[line]
    if bookmark then
        vim.api.nvim_win_close(0, true)
        local file, lineno = bookmark:match("([^:]+):(%d+)")
        vim.cmd("e " .. file)
        vim.cmd(lineno)
    end
end

function M.display()
    local win_width = 60
    local win_height = math.max(5, #bookmarks)
    win_height = math.min(win_height, 10)
    local row = math.floor((vim.o.lines - win_height) / 2)
    local col = math.floor((vim.o.columns - win_width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"

    local opts = {
        relative = "editor",
        style = "minimal",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "single",
    }
    vim.api.nvim_open_win(buf, true, opts)

    if #bookmarks == 0 then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "No bookmarks set." })
    else
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, bookmarks)
    end

    vim.keymap.set("n", "<CR>", M.open_bookmark_at_line, { noremap = true, silent = true, buffer = buf })
end

vim.keymap.set("n", "<leader>mb", M.add_bookmark, { desc = "Add bookmark" })
vim.keymap.set("n", "<leader>md", M.display, { desc = "Display bookmarks" })

return M
