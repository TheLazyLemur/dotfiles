local config_settings = {
    formatting_enabled = true,
    format_on_save = false,
    linting_enabled = false,
    lint_on_save = false,
    should_load_debugger = false,
}

-- Method to refresh the settings window with updated values
function config_settings:refresh_settings_window(buf, win)
    -- Store current cursor position
    local cursor = vim.api.nvim_win_get_cursor(win)
    local line_num = cursor[1]

    -- Regenerate settings lines
    local lines = {}
    table.insert(lines, "Configuration Settings:")
    table.insert(lines, "")

    for key, value in pairs(self) do
        if type(value) ~= "function" then
            table.insert(lines, string.format("  %s: %s", key, tostring(value)))
        end
    end

    -- Make buffer modifiable temporarily
    vim.bo[buf].modifiable = true

    -- Update buffer content
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Make buffer non-modifiable again
    vim.bo[buf].modifiable = false

    -- Restore cursor position (ensure it's within bounds)
    local max_lines = #lines
    if line_num > max_lines then
        line_num = max_lines
    end
    if line_num < 1 then
        line_num = 1
    end

    vim.api.nvim_win_set_cursor(win, { line_num, 0 })
end

-- Toggle function for settings
function config_settings.toggle_setting(buf, win)
    -- Silent error handling - wrap everything in pcall to prevent disrupting user experience
    local _, _ = pcall(function()
        -- Get current cursor position
        local cursor = vim.api.nvim_win_get_cursor(win)
        local line_num = cursor[1]

        -- Get the line content
        local lines = vim.api.nvim_buf_get_lines(buf, line_num - 1, line_num, false)
        if #lines == 0 then
            return -- Empty buffer or invalid line number
        end

        local line = lines[1]

        -- Handle empty lines - do nothing
        if line:match("^%s*$") then
            return
        end

        -- Handle header lines ("Configuration Settings:") - do nothing
        if line:match("^%s*Configuration Settings:%s*$") then
            return
        end

        -- Parse the line to extract setting name and value
        local setting_name, current_value = line:match("^%s*(.-):%s*(.*)$")

        -- Handle malformed setting lines gracefully - do nothing if parsing fails
        if not setting_name or not current_value or setting_name == "" or current_value == "" then
            return
        end

        -- Validate if line is a setting line (should have proper indentation and format)
        if not line:match("^%s%s+.+:%s*.+$") then
            return -- Not properly formatted as a setting line
        end

        -- Check if it's a boolean value
        local new_value
        if current_value == "true" then
            new_value = false
        elseif current_value == "false" then
            new_value = true
        else
            return -- Handle non-boolean setting lines - do nothing
        end

        -- Verify the setting exists in our config table
        if config_settings[setting_name] == nil then
            return -- Setting doesn't exist in our config
        end

        -- Update the config_settings table
        config_settings[setting_name] = new_value

        -- Refresh the window with updated values
        config_settings:refresh_settings_window(buf, win)
    end)
end

-- Function to show floating pane with the current settings
function config_settings:show_settings()
    local lines = {}
    table.insert(lines, "Configuration Settings:")
    table.insert(lines, "")

    for key, value in pairs(self) do
        if type(value) ~= "function" then
            table.insert(lines, string.format("  %s: %s", key, tostring(value)))
        end
    end

    -- Create floating window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Calculate window size
    local width = 40
    local height = #lines + 2

    -- Get editor dimensions
    local ui = vim.api.nvim_list_uis()[1]
    local win_width = ui.width
    local win_height = ui.height

    -- Calculate position (center the window)
    local row = math.floor((win_height - height) / 2)
    local col = math.floor((win_width - width) / 2)

    -- Window options
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = " Settings ",
        title_pos = "center",
    }

    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Set buffer options
    vim.bo[buf].modifiable = false
    vim.bo[buf].buftype = "nofile"

    -- Close window on escape or q
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })

    -- Add space key mapping for toggle functionality
    vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        "<Space>",
        string.format(":lua require('settings').toggle_setting(%d, %d)<CR>", buf, win),
        { noremap = true, silent = true }
    )
end

return config_settings
