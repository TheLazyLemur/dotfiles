local TERMMY = {}

TERMMY.toggle = function(split, dir)
    if not dir or dir == "" then
        dir = vim.fn.getcwd()
    end

    if vim.api.nvim_get_current_buf() == TERMMY.buf then
        vim.api.nvim_win_close(TERMMY.win, true)
        if TERMMY.split ~= split then
            TERMMY.toggle(split)
        end
        return
    end

    local is_new = TERMMY.buf == nil or not vim.api.nvim_buf_is_valid(TERMMY.buf)

    TERMMY.split = split

    if not split then
        local win_config = TERMMY.config_func()

        if is_new then
            TERMMY.buf = vim.api.nvim_create_buf(false, true)
        end

        TERMMY.win = vim.api.nvim_open_win(TERMMY.buf, true, win_config)
    end

    if split then
        vim.cmd("split")

        local temp_buf = vim.api.nvim_create_buf(false, true)
        TERMMY.win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(TERMMY.win, temp_buf)
    end

    if is_new then
        vim.fn.termopen("zsh", { cwd = dir })
    else
        vim.api.nvim_win_set_buf(TERMMY.win, TERMMY.buf)
    end

    vim.cmd("startinsert")
    TERMMY.buf = vim.api.nvim_get_current_buf()
end

TERMMY.setup = function(config_func)
    TERMMY.config_func = config_func or function()
        local cursor_pos = vim.fn.screenpos(0, vim.fn.line('.'), vim.fn.col('.'))
        local cfg = {
            relative = 'editor',
            row = cursor_pos.row + 0,
            col = cursor_pos.col - 1,
            width = 60,
            height = 10,
            style = 'minimal',
            border = 'single',
        }
        return cfg
    end
end

return TERMMY
