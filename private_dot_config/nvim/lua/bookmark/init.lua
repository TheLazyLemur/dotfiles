local M = {}
local bookmarks = {}

local function get_bookmark_file()
    return vim.fn.stdpath("data") .. "/bookmarks_" .. vim.fn.getcwd():gsub("[/:]", "_") .. ".txt"
end

function M.load_bookmarks()
    bookmarks = {}
    local file = io.open(get_bookmark_file(), "r")
    if file then
        for line in file:lines() do
            bookmarks[#bookmarks + 1] = line
        end
        file:close()
    end
end

function M.save_bookmarks()
    local file = io.open(get_bookmark_file(), "w")
    if file then
        for _, bookmark in ipairs(bookmarks) do
            file:write(bookmark .. "\n")
        end
        file:close()
        print("Bookmarks saved.")
    else
        print("Error: Unable to save bookmarks.")
    end
end

function M.add_bookmark()
    local bookmark = string.format("%s:%d", vim.fn.expand("%:p"), vim.fn.line("."))
    bookmarks[#bookmarks + 1] = bookmark
    print("Bookmark added at " .. bookmark)
    M.save_bookmarks()
end

function M.delete_bookmark()
    local line = vim.fn.line(".")
    if bookmarks[line] then
        table.remove(bookmarks, line)
        print("Bookmark deleted.")
        M.save_bookmarks()
        local buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, #bookmarks > 0 and bookmarks or { "No bookmarks set." })
    else
        print("No bookmark found at the current line.")
    end
end

function M.open_bookmark_at_line()
    local bookmark = bookmarks[vim.fn.line(".")]
    if bookmark then
        vim.api.nvim_win_close(0, true)
        local file, lineno = bookmark:match("([^:]+):(%d+)")
        vim.cmd("e " .. file)
        vim.cmd(lineno)
    end
end

function M.display()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"
    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        style = "minimal",
        width = 60,
        height = math.min(math.max(5, #bookmarks), 10),

        row = math.floor((vim.o.lines - 10) / 2),
        col = math.floor((vim.o.columns - 60) / 2),

        border = "single",
    })
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, #bookmarks > 0 and bookmarks or { "No bookmarks set." })
    vim.keymap.set("n", "<CR>", M.open_bookmark_at_line, { noremap = true, silent = true, buffer = buf })
    vim.keymap.set("n", "dd", M.delete_bookmark, { noremap = true, silent = true, buffer = buf })
end

M.load_bookmarks()

return M
