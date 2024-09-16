vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = true
vim.opt.laststatus = 3
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.wrap = false

vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'
vim.o.grepformat = '%f:%l:%c:%m'

local function fzf_quickfix()
    local pattern = vim.fn.input("Pattern: ")

    local handle = io.popen('fzf --ansi --filter ' .. pattern)
    if handle ~= nil then
        local results = handle:read('*a')
        handle:close()

        local lines = {}
        for line in results:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end

        if #lines > 0 then
            local qflist = {}
            for _, l in ipairs(lines) do
                table.insert(qflist, { filename = l, lnum = 1 })
            end
            vim.fn.setqflist(qflist, 'r')
            vim.cmd('copen')
        end
    end
end

vim.api.nvim_create_user_command('FzfQuickfix', fzf_quickfix, {})

vim.cmd [[ colorscheme retrobox ]]
