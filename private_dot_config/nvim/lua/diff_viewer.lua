local M = {}

-- Storage for active diff sessions
local active_diffs = {}

-- Create a temporary buffer for diff display
local function create_diff_buf()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
    vim.api.nvim_set_option_value("filetype", "diff", { buf = buf })
    return buf
end

-- Create centered floating window for diff
local function create_diff_window(buf, title)
    local height = math.ceil(vim.o.lines * 0.7)
    local width = math.ceil(vim.o.columns * 0.8)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.ceil((vim.o.lines - height) / 2),
        col = math.ceil((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = title or "Diff Viewer",
        title_pos = "center",
    })

    return win
end

-- Generate unified diff between old and new text
local function generate_diff(old_text, new_text)
    -- Split text into lines
    local old_lines = vim.split(old_text, "\n", { plain = true })
    local new_lines = vim.split(new_text, "\n", { plain = true })

    -- Simple line-by-line diff (could be enhanced with proper diff algorithm)
    local diff_lines = {}
    local max_lines = math.max(#old_lines, #new_lines)

    table.insert(diff_lines, "--- Original")
    table.insert(diff_lines, "+++ Modified")
    table.insert(diff_lines, "@@ -1," .. #old_lines .. " +1," .. #new_lines .. " @@")

    for i = 1, max_lines do
        local old_line = old_lines[i] or ""
        local new_line = new_lines[i] or ""

        if old_line ~= new_line then
            if old_lines[i] then
                table.insert(diff_lines, "-" .. old_line)
            end
            if new_lines[i] then
                table.insert(diff_lines, "+" .. new_line)
            end
        else
            table.insert(diff_lines, " " .. old_line)
        end
    end

    return diff_lines
end

-- Setup keymaps for diff window
local function setup_diff_keymaps(buf, win, session_id)
    local opts = { noremap = true, silent = true, buffer = buf }

    -- Accept diff (y/Y)
    vim.keymap.set("n", "y", function()
        M.accept_diff(session_id)
    end, vim.tbl_extend("force", opts, { desc = "Accept diff" }))

    vim.keymap.set("n", "Y", function()
        M.accept_diff(session_id)
    end, vim.tbl_extend("force", opts, { desc = "Accept diff" }))

    -- Reject diff (n/N)
    vim.keymap.set("n", "n", function()
        M.reject_diff(session_id)
    end, vim.tbl_extend("force", opts, { desc = "Reject diff" }))

    vim.keymap.set("n", "N", function()
        M.reject_diff(session_id)
    end, vim.tbl_extend("force", opts, { desc = "Reject diff" }))

    -- Close without decision (q/ESC)
    vim.keymap.set("n", "q", function()
        M.close_diff(session_id)
    end, vim.tbl_extend("force", opts, { desc = "Close diff" }))

    vim.keymap.set("n", "<ESC>", function()
        M.close_diff(session_id)
    end, vim.tbl_extend("force", opts, { desc = "Close diff" }))

    -- Show help
    vim.keymap.set("n", "?", function()
        vim.notify(
            "Diff Viewer Help:\ny/Y - Accept diff\nn/N - Reject diff\nq/ESC - Close without decision\n? - Show this help",
            vim.log.levels.INFO
        )
    end, vim.tbl_extend("force", opts, { desc = "Show help" }))
end

-- Main function to show diff
function M.show_diff(buffer_id, old_text, new_text, callback)
    -- Generate unique session ID
    local session_id = tostring(vim.loop.hrtime())

    -- Create diff content
    local diff_lines = generate_diff(old_text, new_text)

    -- Create buffer and window
    local buf = create_diff_buf()
    local title = "Buffer " .. buffer_id .. " - Diff Viewer [y=accept, n=reject, q=close]"
    local win = create_diff_window(buf, title)

    -- Set buffer content
    vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, diff_lines)
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

    -- Store session info
    active_diffs[session_id] = {
        buffer_id = buffer_id,
        old_text = old_text,
        new_text = new_text,
        diff_buf = buf,
        diff_win = win,
        callback = callback,
        completed = false,
    }

    -- Setup keymaps
    setup_diff_keymaps(buf, win, session_id)

    -- Setup auto-cleanup on window close
    vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(win),
        callback = function()
            if active_diffs[session_id] and not active_diffs[session_id].completed then
                M.close_diff(session_id)
            end
        end,
        once = true,
    })

    return session_id
end

-- Accept the diff
function M.accept_diff(session_id)
    local session = active_diffs[session_id]
    if not session or session.completed then
        return
    end

    session.completed = true

    -- Close window
    if vim.api.nvim_win_is_valid(session.diff_win) then
        vim.api.nvim_win_close(session.diff_win, true)
    end

    -- Call callback with acceptance
    if session.callback then
        vim.schedule(function()
            session.callback(true, session.new_text)
        end)
    end

    -- Cleanup
    active_diffs[session_id] = nil

    vim.notify("Diff accepted", vim.log.levels.INFO)
end

-- Reject the diff
function M.reject_diff(session_id)
    local session = active_diffs[session_id]
    if not session or session.completed then
        return
    end

    session.completed = true

    -- Close window
    if vim.api.nvim_win_is_valid(session.diff_win) then
        vim.api.nvim_win_close(session.diff_win, true)
    end

    -- Call callback with rejection
    if session.callback then
        vim.schedule(function()
            session.callback(false, session.old_text)
        end)
    end

    -- Cleanup
    active_diffs[session_id] = nil

    vim.notify("Diff rejected", vim.log.levels.INFO)
end

-- Close diff without decision
function M.close_diff(session_id)
    local session = active_diffs[session_id]
    if not session or session.completed then
        return
    end

    session.completed = true

    -- Close window
    if vim.api.nvim_win_is_valid(session.diff_win) then
        vim.api.nvim_win_close(session.diff_win, true)
    end

    -- Call callback with nil (no decision)
    if session.callback then
        vim.schedule(function()
            session.callback(nil, nil)
        end)
    end

    -- Cleanup
    active_diffs[session_id] = nil

    vim.notify("Diff closed without decision", vim.log.levels.WARN)
end

-- Get active diff sessions (for debugging/status)
function M.get_active_sessions()
    local sessions = {}
    for id, session in pairs(active_diffs) do
        sessions[id] = {
            buffer_id = session.buffer_id,
            completed = session.completed,
        }
    end
    return sessions
end

-- Example usage function (for testing)
function M.example_usage(id)
    local old_text = [[function hello() {
    console.log("Hello");
}]]

    local new_text = [[function hello() {
    console.log("Hello, World!");
    console.log("Updated function");
}]]

    M.show_diff(vim.api.nvim_get_current_buf(), old_text, new_text, function(accepted, final_text)
        if accepted then
            vim.notify("User accepted the diff!", vim.log.levels.INFO)
            vim.notify("Final text: " .. (final_text or "nil"), vim.log.levels.DEBUG)
            vim.rpcrequest(3, "custom_request", id, new_text)
        elseif accepted == false then
            vim.notify("User rejected the diff!", vim.log.levels.WARN)
        else
            vim.notify("User closed without deciding", vim.log.levels.INFO)
        end
    end)
end

-- Setup command for easy access
vim.api.nvim_create_user_command("DiffViewerExample", function(opts)
    M.example_usage(opts.args)
end, {
    desc = "Show example diff viewer",
    nargs = 1,
})

return M
