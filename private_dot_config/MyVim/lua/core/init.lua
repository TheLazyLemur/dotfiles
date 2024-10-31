require("core.options")
require("core.mini")
require("core.lsp")
require("core.keymaps")

local function copy_reference_point()
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
    local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
    local reference_point = path .. ":" .. tostring(row) .. ":" .. tostring(col)
    vim.fn.setreg("+", reference_point)
end

local function run_shell(opts)
    local cmd = opts.args
    local output = vim.fn.system(cmd)
    vim.api.nvim_command('new')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, '\n'))
end

vim.api.nvim_create_user_command('ReferencePoint', copy_reference_point, {})
vim.api.nvim_create_user_command('RunShell', run_shell, { nargs = 1 })
