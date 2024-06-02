local H = {}

function H.set_buffer_lines(buf, items)
    vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, items)
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
end

function H.get_current_file_dir()
    return vim.fn.expand('%:p:h')
end

function H.list_files(dir)
    local files = vim.fn.readdir(dir)

    if files == nil then
        print("Error: Unable to read directory")
        return
    end

    return files
end

function H.is_directory(file_path)
    local uv = vim.loop
    local stat = uv.fs_stat(file_path)
    if stat then
        return stat.type == "directory"
    else
        return false
    end
end

function H.get_current_working_dir()
    local uv = vim.loop
    return uv.cwd()
end

function H.build_list_for_dir(dir, idx_of)
    local items = H.list_files(dir)
    if items == nil then
        vim.notify("Something went wrong while listing files", vim.log.levels.WARN)
        return
    end

    local ret = {}

    table.insert(ret, "./")
    table.insert(ret, "../")

    for i, entry in ipairs(items) do
        if H.is_directory(dir .. "/" .. entry) then
            table.insert(ret, items[i] .. "/")
        end
    end

    for i, entry in ipairs(items) do
        if not H.is_directory(dir .. "/" .. entry) then
            table.insert(ret, items[i])
        end
    end

    local idx = 1

    for i, entry in ipairs(ret) do
        if entry == idx_of then
            idx = i
        end
    end

    return ret, idx
end

function H.chop_last_char(str)
    return string.sub(str, 1, -2)
end

function H.get_filename()
    local full_path = vim.fn.expand('%:p')
    local file_name = vim.fn.fnamemodify(full_path, ':t')
    return file_name
end

local M = {
    current_dir = nil
}

function M.select_item(in_split)
    if in_split == nil then
        in_split = false
    end

    local current_win = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(current_win)
    local selected_line = vim.fn.getline(cursor[1])

    if H.is_directory(M.current_dir .. "/" .. selected_line) then
        M.handle_directory_select(selected_line)
    else
        M.handle_file_select(selected_line, in_split)
    end
end

function M.handle_directory_select(dir)
    local last_dir = vim.fn.fnamemodify(M.current_dir, ":h")
    if dir == "../" then
        M.current_dir = vim.fn.fnamemodify(H.chop_last_char(M.current_dir), ":h")
        print()
    else
        M.current_dir = M.current_dir .. "/" .. dir
    end

    local current_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_option_value("modifiable", true, { buf = current_buf })
    local items, idx = H.build_list_for_dir(M.current_dir)
    if items == nil then
        return
    end

    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, items)
    vim.api.nvim_set_option_value("modifiable", false, { buf = current_buf })
end

function M.handle_file_select(file, in_split)
    if in_split then
        vim.api.nvim_command("vsplit")
    end

    vim.api.nvim_command("edit " .. M.current_dir .. "/" .. file)
end

M.create_file = function(buf)
    local function getUserInput(prompt)
        return vim.fn.input(prompt .. ": ")
    end

    local userInput = getUserInput("Enter a file name")

    vim.cmd("!touch " .. M.current_dir .. userInput)

    local items = H.build_list_for_dir(M.current_dir)
    if items == nil then
        return
    end

    H.set_buffer_lines(buf, items)
end

M.delete = function(buf)
    local function getUserInput(prompt)
        return vim.fn.input(prompt .. ": ")
    end

    local current_win = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(current_win)
    local selected_line = vim.fn.getline(cursor[1])

    local userInput = getUserInput("Would you like to delete y/n")
    if userInput == "y" or userInput == "Y" then
        vim.cmd("!rm -rf " .. M.current_dir .. selected_line)
    end

    if userInput == "n" or userInput == "N" then
        return
    end

    local items = H.build_list_for_dir(M.current_dir)
    if items == nil then
        return
    end

    H.set_buffer_lines(buf, items)
end

M.create_dir = function(buf)
    local function getUserInput(prompt)
        return vim.fn.input(prompt .. ": ")
    end

    local userInput = getUserInput("Enter a dir name")

    vim.cmd("!mkdir -p " .. M.current_dir .. userInput)

    local items = H.build_list_for_dir(M.current_dir)
    if items == nil then
        return
    end

    H.set_buffer_lines(buf, items)
end

M.spawn_buffer = function()
    M.current_dir = H.get_current_file_dir() .. "/"

    local items, cursor_pos = H.build_list_for_dir(M.current_dir, H.get_filename())
    if items == nil then
        return
    end

    local current_buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, items)
    vim.api.nvim_set_option_value("modifiable", false, { buf = current_buf })

    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, current_buf)

    vim.cmd(string.format(":%d", cursor_pos))

    vim.keymap.set("n", "<CR>", M.select_item, { buffer = current_buf, silent = true })
    vim.keymap.set("n", "c", function() M.create_file(current_buf) end, { buffer = current_buf, silent = true })
    vim.keymap.set("n", "C", function() M.create_dir(current_buf) end, { buffer = current_buf, silent = true })
    vim.keymap.set("n", "d", function() M.delete(current_buf) end, { buffer = current_buf, silent = true })
    vim.keymap.set("n", "-", function() M.handle_directory_select("../") end, { buffer = current_buf, silent = true })
end

return M
