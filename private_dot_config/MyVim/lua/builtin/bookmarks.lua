local M = {
    file_to_bookmark = {},
    center_cursor = function()
        vim.cmd("normal zz")
    end,
}

local H = {}

function H.split_string(inputstr, delimiter)
    local result = {}
    for match in (inputstr .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function M.save_bookmarks()
    local stdPath = vim.fn.stdpath("data")
    local file = io.open(stdPath .. "/marky.json", "w")
    if file then
        file:write(vim.fn.json_encode(M.file_to_bookmark))
        file:close()
        return true
    else
        return false
    end
end

function M.bookmark_file()
    local current_buf = vim.api.nvim_get_current_buf()

    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local current_line = cursor_pos[1]
    local current_col = cursor_pos[2]

    local current_file = vim.api.nvim_buf_get_name(current_buf)

    M.file_to_bookmark[M.currentDir][current_file] = {
        line = current_line,
        col = current_col,
    }

    M.save_bookmarks()
end

function M.show_selection_ui(stuff)
    local items = {}

    for k, v in pairs(M.file_to_bookmark[M.currentDir]) do
        local truncatedK = H.split_string(k, M.currentDir)[2]
        table.insert(items, truncatedK .. ":" .. v.line .. "," .. v.col)
    end

    local current_buf = vim.api.nvim_create_buf(false, true)

    if stuff ~= nil then
        items = stuff
    end

    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, items)
    vim.api.nvim_set_option_value("modifiable", false, { buf = current_buf })

    local width = 100
    local height = math.min(#items, 10)

    if height == 0 then
        height = 1
    end

    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local _ = vim.api.nvim_open_win(current_buf, true, {
        relative = "editor",
        row = row,
        col = col,
        width = width,
        height = height,
        style = "minimal",
        border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
        title = "Bookmarks",
        title_pos = "center",
    })

    vim.keymap.set("n", "<CR>", M.select_item, { buffer = current_buf, silent = true })
    vim.keymap.set("n", "<C-v>", function() M.select_item(true) end, { buffer = current_buf, silent = true })
    vim.keymap.set("n", "dd", function() pcall(M.delete_bookmark) end, { buffer = current_buf, silent = true })
    vim.keymap.set("n", "<Esc>", function()
        vim.api.nvim_win_close(0, true)
    end, { buffer = current_buf, silent = true })
    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(0, true)
    end, { buffer = current_buf, silent = true })
end

function M.delete_bookmark()
    local current_win = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(current_win)

    local selected_line = H.split_string(M.currentDir .. vim.fn.getline(cursor[1]), ":")[1]

    M.file_to_bookmark[M.currentDir][selected_line] = nil

    local current_buf = vim.api.nvim_get_current_buf()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    vim.api.nvim_set_option_value("modifiable", true, { buf = current_buf })
    local line_number = cursor_pos[1]

    vim.api.nvim_buf_set_lines(current_buf, line_number - 1, line_number, false, {})
    vim.api.nvim_win_set_cursor(0, { line_number, 0 })

    M.save_bookmarks()
end

function M.select_item(in_split)
    if in_split == nil then
        in_split = false
    end

    local current_win = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(current_win)
    local selected_line = M.currentDir .. vim.fn.getline(cursor[1])

    local file = H.split_string(selected_line, ":")[1]
    local lineAndCol = H.split_string(selected_line, ":")[2]
    local line = H.split_string(lineAndCol, ",")[1]
    local col = H.split_string(lineAndCol, ",")[2]

    vim.api.nvim_win_close(0, true)
    if in_split then
        vim.api.nvim_command("vsplit")
    end
    vim.api.nvim_command("edit " .. file)

    vim.api.nvim_win_set_cursor(0, { tonumber(line), tonumber(col) })

    M.center_cursor()
end

function M.setup()
    local stdPath = vim.fn.stdpath("data")

    M.currentDir = vim.fn.getcwd()

    local file = io.open(stdPath .. "/marky.json", "r")
    if file then
        M.file_to_bookmark = vim.fn.json_decode(file:read("*a"))
        file:close()
    end

    if M.file_to_bookmark[M.currentDir] == nil then
        M.file_to_bookmark[M.currentDir] = {}
    end

    return M
end

return M
