local H = require("modules.nterm.utils")

local M = {
    terminals = {},
}

local function set_buf_maps(bufnr)
    local mappings = {
        { "t", "==q", H.close_current_win, { buffer = bufnr } },
        { "n", "==q", H.close_current_win, { buffer = bufnr } }
    }

    for _, mapping in ipairs(mappings) do
        vim.keymap.set(unpack(mapping))
    end
end

local function toggle_terminal(term_name)
    term_name = term_name or "default"

    local new = M.terminals[term_name] == nil or not H.is_buffer_valid(M.terminals[term_name])

    if new then
        M.terminals[term_name] = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_set_option_value("modifiable", true, { buf = M.terminals[term_name] })
    end

    -- Close if the current terminal is already open
    local current_win = vim.api.nvim_get_current_win()
    local buf_in_win = vim.api.nvim_win_get_buf(current_win)
    if buf_in_win == M.terminals[term_name] then
        H.close_current_win()
        return
    end

    -- Check if the current open win has a terminal open and if its not the requested terminal swap them
    for _, value in pairs(M.terminals) do
        if buf_in_win == value and M.terminals[term_name] ~= buf_in_win and not new then
            vim.api.nvim_win_set_buf(current_win, M.terminals[term_name])
            local cfg = vim.api.nvim_win_get_config(current_win)
            cfg.title = "Terminal:" .. term_name
            vim.api.nvim_win_set_config(current_win, cfg)
            return
        end
        if buf_in_win == value and M.terminals[term_name] ~= buf_in_win and new then
            H.close_current_win()
        end
    end

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)

    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(M.terminals[term_name], true, {
        relative = "editor",
        row = row,
        col = col,
        width = width,
        height = height,
        style = "minimal",
        border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
        title = "Terminal:" .. term_name,
        title_pos = "center",
    })
    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:MyFloat,FloatBorder:MyFloatBorder')

    if new then
        vim.cmd("terminal")
        set_buf_maps(M.terminals[term_name])
    end

    vim.cmd("startinsert")
end

M.toggle_terminal = function(term_name)
    toggle_terminal(term_name)
end

M.setup = function()
    vim.api.nvim_create_autocmd({ "FocusGained", "VimResized" }, {
        group = vim.api.nvim_create_augroup("nterm-resize", { clear = true }),
        callback = function()
            local current_win = vim.api.nvim_get_current_win()
            local buf_in_win = vim.api.nvim_win_get_buf(current_win)

            for _, value in pairs(M.terminals) do
                if buf_in_win == value then
                    H.set_window_float_size(current_win)
                end
            end
        end,
    })
end

return M
