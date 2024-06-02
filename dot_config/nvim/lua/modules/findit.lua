local ops = {}

function ops.get_all_files(input)
    if input or input == "" then
        return ops.execute_shell_command({ "sh", "-c", "rg --files | fzf --filter " .. input })
    end
    return ops.execute_shell_command({ "rg", "--files" })
end

function ops.get_exact_matches(value, list)
    local exact_matches = {}
    for _, v in ipairs(list) do
        local match = string.match(v, value)
        if match then
            table.insert(exact_matches, v)
        end
    end

    return exact_matches
end

function ops.get_view_list(list, cursorPos)
    local view_list = {}

    for i, v in ipairs(list) do
        if i ~= cursorPos then
            view_list[i] = v
        else
            view_list[i] = "> " .. v
        end
    end

    return view_list
end

function ops.execute_shell_command(command)
    local out = vim.fn.system(command)
    local lines = {}
    for line in out:gmatch("([^\n]*)\n?") do
        table.insert(lines, line)
    end

    for i = #lines, 1, -1 do
        if i == #lines and lines[i] == "" then
            table.remove(lines, i)
        end
    end

    return lines
end

function ops.get_quickfix_list(list)
    local quickfix_list = {}
    for _, v in ipairs(list) do
        table.insert(quickfix_list, {
            filename = v,
            text = v
        })
    end

    return quickfix_list
end

function ops.spawn_windows(width, height, row, col, focus, title)
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, focus, {
        relative = "editor",
        row = row,
        col = col,
        width = width,
        height = height,
        style = "minimal",
        border = "rounded",
        title = title,
        title_pos = "center",
    })

    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:MyFloat,FloatBorder:MyFloatBorder')

    return buf, win
end

local M = {
    list = {},
    cursorPos = 1,
    in_buf = nil,
    in_win = nil,
    prev_buf = nil,
    prev_win = nil,
    out_buf = nil,
    out_win = nil,
}

function M.spawn_buffers_and_windows(with_autocmds)
    local container_width = math.floor(vim.o.columns / 1.3)
    local container_height = math.floor(vim.o.lines / 1.3)

    local container_x = 1
    local container_y = math.floor((vim.o.lines - container_height) - 4)

    local input_width = math.floor(container_width * 0.5)
    local input_height = 1
    local row = container_y + container_height - input_height
    M.in_buf, M.in_win = ops.spawn_windows(input_width, input_height, row, container_x, true, " Input ")

    local result_width = math.floor(container_width * 0.5)
    local result_height = math.floor((container_height) - container_height * 0.05) - input_height
    M.out_buf, M.out_win = ops.spawn_windows(result_width, result_height, container_y, container_x, false, " Results ")

    local preview_width = math.floor(container_width * 0.5)
    local preview_height = container_height
    local col = container_x + preview_width + 3
    M.prev_buf, M.prev_win = ops.spawn_windows(preview_width, preview_height, container_y, col, false, " Preview ")

    if with_autocmds then
        M.set_autocmds()
    end
end

function M.find_files()
    M.spawn_buffers_and_windows()

    local initial_files = ops.get_all_files()
    local intial_displ = ops.get_view_list(initial_files, 1)
    vim.api.nvim_buf_set_lines(M.out_buf, 0, -1, false, intial_displ)

    vim.cmd("startinsert")

    M.list = initial_files

    vim.keymap.set("n", "<ESC>", M.close, { buffer = M.in_buf })
    vim.keymap.set("i", "<C-n>", M.next, { buffer = M.in_buf })
    vim.keymap.set("i", "<C-p>", M.prev, { buffer = M.in_buf })
    vim.keymap.set("i", "<CR>", M.select, { buffer = M.in_buf })
    vim.keymap.set("i", "<C-v>", function() M.select(true) end, { buffer = M.in_buf })
    vim.keymap.set("i", "<C-q>", M.send_to_quickfix, { buffer = M.in_buf })

    M.set_autocmds()
end

function M.on_input_changed()
    M.cursorPos = 1
    local filter_value = vim.api.nvim_buf_get_lines(M.in_buf, 0, -1, false)
    M.list = ops.get_all_files(filter_value[1])

    local displ = ops.get_view_list(M.list, M.cursorPos)

    if M.list[M.cursorPos] then
        local ls_output = ops.execute_shell_command('bat ' .. M.list[M.cursorPos])
        vim.api.nvim_buf_set_lines(M.prev_buf, 0, -1, false, ls_output)
    else
        vim.api.nvim_buf_set_lines(M.prev_buf, 0, -1, false, {})
    end

    vim.api.nvim_buf_set_lines(M.out_buf, 0, -1, false, displ)
end

function M.close()
    pcall(
        function()
            vim.api.nvim_buf_delete(M.in_buf, { force = true })
            vim.api.nvim_buf_delete(M.out_buf, { force = true })
            vim.api.nvim_buf_delete(M.prev_buf, { force = true })
            vim.cmd [[
                stopinsert
                augroup! FindIt-Input-TextChanged
                augroup! FindIt-Input-BufLeave
            ]]
        end
    )
end

function M.next()
    M.cursorPos = M.cursorPos + 1
    if M.cursorPos > #M.list then
        M.cursorPos = #M.list
    end

    if M.cursorPos < 1 then
        M.cursorPos = 1
    end

    local displ = ops.get_view_list(M.list, M.cursorPos)

    local ext = vim.fn.fnamemodify(M.list[M.cursorPos], ":e")
    vim.api.nvim_set_option_value("filetype", ext, { buf = M.prev_buf })
    local ls_output = ops.execute_shell_command({ 'bat', M.list[M.cursorPos] })

    vim.api.nvim_buf_set_lines(M.out_buf, 0, -1, false, displ)
    vim.api.nvim_buf_set_lines(M.prev_buf, 0, -1, false, ls_output)
    vim.api.nvim_win_set_cursor(M.out_win, { M.cursorPos, 0 })
end

function M.prev()
    M.cursorPos = M.cursorPos - 1
    if M.cursorPos > #M.list then
        M.cursorPos = #M.list
    end

    if M.cursorPos < 1 then
        M.cursorPos = 1
    end

    local displ = ops.get_view_list(M.list, M.cursorPos)

    local ls_output = ops.execute_shell_command({ 'bat', M.list[M.cursorPos] })

    vim.api.nvim_buf_set_lines(M.out_buf, 0, -1, false, displ)
    vim.api.nvim_buf_set_lines(M.prev_buf, 0, -1, false, ls_output)
    vim.api.nvim_win_set_cursor(M.out_win, { M.cursorPos, 0 })
end

function M.select(split)
    if split then
        M.close()
        vim.cmd('vsplit')
        vim.cmd("e " .. M.list[M.cursorPos])
        return
    end
    M.close()
    vim.cmd('stopinsert')
    vim.cmd("e " .. M.list[M.cursorPos])
end

function M.send_to_quickfix()
    local quickfix_list = ops.get_quickfix_list(M.list)
    vim.fn.setqflist(quickfix_list)
    M.close()
    vim.cmd([[
           stopinsert
           copen
        ]])
end

function M.set_autocmds()
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        buffer = M.in_buf,
        group = vim.api.nvim_create_augroup("FindIt-Input-TextChanged", { clear = true }),
        callback = M.on_input_changed,
    })

    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = M.in_buf,
        group = vim.api.nvim_create_augroup("FindIt-Input-BufLeave", { clear = true }),
        callback = M.close,
    })
end

function M.setup(opts)
end

return M
