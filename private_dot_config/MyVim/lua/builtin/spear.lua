local SPEAR = {
    entries = {},
}

local function write_to_file(data)
    local file_path = "/tmp/spear.json"
    local file = io.open(file_path, "w")

    if file then
        file:write(data)
        file:close()
    else
        print("Error: Unable to open file!")
    end
end

local function read_from_file(path)
    local file = io.open(path, "r")

    local content = ""
    if file then
        content = file:read("*all")
        file:close()
        return content
    else
        print("Error: Unable to open file!")
    end

    return nil
end

local function jump_to_file(entry)
    local file_path = entry.path
    local line_num = entry.line
    local col_num = entry.col

    if vim.fn.filereadable(file_path) == 1 then
        vim.cmd("edit " .. file_path)
        vim.api.nvim_win_set_cursor(0, { line_num, col_num - 1 })
    else
        print("File does not exist: " .. file_path)
    end
end

local function cat_file_to_buffer(buf, file_path)
    if vim.fn.filereadable(file_path) == 0 then
        print("File does not exist: " .. file_path)
        return
    end

    local lines = {}
    for line in io.lines(file_path) do
        table.insert(lines, line)
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

local function navigate_to_buffer_line(buf_number, line_number)
    if vim.api.nvim_buf_is_valid(buf_number) then
        vim.api.nvim_set_current_buf(buf_number)
        vim.api.nvim_win_set_cursor(0, { line_number, 0 })
    else
        print("Buffer " .. buf_number .. " does not exist.")
    end
end

SPEAR.pick = function(type)
    local select_cb = function(choice)
        vim.schedule(function()
            jump_to_file(choice)
        end)
    end

    local delete_cb = function(choice)
        local index = -1
        local t = SPEAR.entries[vim.fn.getcwd()]

        for i, value in ipairs(t) do
            if value.text == choice.text then
                index = i
            end
        end

        print("HERE DELETE")
        SPEAR.entries[vim.fn.getcwd()] = t
        table.remove(SPEAR.entries[vim.fn.getcwd()], index)
    end

    local cb = nil
    if type == nil or type == "select" then
        cb = select_cb
    end

    if type == "delete" then
        cb = delete_cb
    end

    MiniPick.start({
        source = {
            items = SPEAR.entries[vim.fn.getcwd()],
            choose = cb,
            preview = function(buf_nr, item)
                cat_file_to_buffer(buf_nr, item.path)
                vim.api.nvim_buf_add_highlight(buf_nr, -1, "TODO", item.line - 1, 0, -1)
                vim.bo[buf_nr].filetype = "lua"
                vim.cmd("set number")
                navigate_to_buffer_line(buf_nr, item.line)
            end,
        },
        window = {
            config = function()
                local width = math.floor(vim.o.columns * 0.75)
                local height = math.floor(vim.o.lines * 0.75)

                local col = math.floor((vim.o.columns - width) / 2)
                local row = math.floor((vim.o.lines - height) / 2)

                local opts = {
                    relative = 'editor',
                    width = width,
                    height = #SPEAR.entries[vim.fn.getcwd()] + 10,
                    row = row,
                    col = col,
                    style = 'minimal',
                    border = 'single',
                }

                return opts
            end,
            prompt_cursor = '▏',
            prompt_prefix = '  ',
        },
    })
end

SPEAR.throw = function()
    local current_path = vim.fn.expand('%:p')
    local relative_path = vim.fn.fnamemodify(current_path, ':~:.')

    local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))

    table.insert(SPEAR.entries[vim.fn.getcwd()], {
        text = relative_path .. "| " .. tostring(line) .. " | " .. tostring(col) .. " |",
        path = relative_path,
        line = line,
        col = col,
    })

    local data = vim.fn.json_encode(SPEAR.entries)
    write_to_file(data)
end

SPEAR.setup = function()
    local data = read_from_file("/tmp/spear.json")
    if data then
        local entries = vim.fn.json_decode(data)
        SPEAR.entries = entries
    end

    if SPEAR.entries[vim.fn.getcwd()] == nil then
        SPEAR.entries[vim.fn.getcwd()] = {}
    end
end

return SPEAR
