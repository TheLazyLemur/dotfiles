local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    direction = "float",
    float_opts = {
        border = "double",
    },
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
    on_close = function()
        vim.cmd("startinsert!")
    end,
})

local lazydocker = Terminal:new({
    cmd = "lazydocker",
    dir = "git_dir",
    direction = "float",
    float_opts = {
        border = "double",
    },
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
    on_close = function()
        vim.cmd("startinsert!")
    end,
})

local claudecode = Terminal:new({
    cmd = "claude",
    dir = "git_dir",
    direction = "float",
    float_opts = {
        border = "double",
    },
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
    on_close = function()
        vim.cmd("startinsert!")
    end,
})

M.claude_toggle = function()
    local cc = require("claudecode")
    cc.start()
    claudecode:toggle()
end

M.lazygit_toggle = function()
    lazygit:toggle()
end

M.lazydocker_toggle = function()
    lazydocker:toggle()
end

return M
