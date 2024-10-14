local MyVimSelect = {}

MyVimSelect.UI_Select = function(items, opts, choice)
    local display_lines = {}
    local choice_map = {}

    for i, value in ipairs(items) do
        if value.text ~= nil then
            display_lines[i] = string.format("%d: %s", i, value.text)
        end

        if opts.format_item ~= nil then
            display_lines[i] = string.format("%d: %s", i, opts.format_item(value))
        end

        if opts.format_item == nil and value.text == nil then
            display_lines[i] = string.format("%d: %s", i, tostring(value))
        end

        choice_map[i] = value
    end

    local current_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, display_lines)
    vim.api.nvim_set_option_value("modifiable", false, { buf = current_buf })

    local width = 100
    local height = math.min(#display_lines, 10)

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
        border = "rounded",
        title = "Select",
        title_pos = "left",
    })

    for index, _ in ipairs(choice_map) do
        vim.keymap.set("n", tostring(index), function()
            local confirm = vim.fn.input("Confirm: " .. display_lines[index] .. ": ")
            vim.fn.inputrestore()
            if confirm == "Y" or confirm == "y" then
                choice(choice_map[index])
                vim.api.nvim_win_close(0, false)
            end
        end, { buffer = current_buf })
    end
end

MyVimSelect.setup = function()
    vim.ui.select = MyVimSelect.UI_Select
end

return MyVimSelect
