vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
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
vim.opt.ruler = false
vim.opt.breakindent = true
vim.opt.cursorline = true
vim.opt.linebreak = true
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.winblend = 10
vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.virtualedit = 'block'
vim.cmd [[ colorscheme habamax ]]

local function do_for_attached(cb)
    local ok, clients = pcall(vim.lsp.get_clients)
    if not ok then return end

    for _, client in pairs(clients) do
        if vim.lsp.buf_is_attached(0, client.id) then
            ok = pcall(cb)
            if not ok then error("could not format") end
            return
        end
    end
end

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
    end,
    group = vim.api.nvim_create_augroup("User-YankHighlight", { clear = true })
})

vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end,
    group = vim.api.nvim_create_augroup("User-Diag", { clear = true })
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    callback = function()
        vim.cmd("checktime")
    end,
    group = vim.api.nvim_create_augroup("User-Auto-Reload", { clear = true })
})

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        pcall(vim.lsp.buf.format)
    end,
    group = vim.api.nvim_create_augroup("User-Auto-Format", { clear = true })
})

vim.api.nvim_create_autocmd('BufReadPost', {
    group    = vim.api.nvim_create_augroup("User-BufCheck", { clear = true }),
    pattern  = '*',
    callback = function()
        if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.fn.setpos('.', vim.fn.getpos("'\""))
            vim.cmd('silent! foldopen')
        end
    end
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("user-lsp-hold", { clear = true }),
    callback = function() do_for_attached(vim.lsp.buf.document_highlight) end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = vim.api.nvim_create_augroup("user-lsp-moved", { clear = true }),
    callback = function() do_for_attached(vim.lsp.buf.clear_references) end,
})

local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.deps"
if not vim.loop.fs_stat(mini_path) then
    vim.cmd("echo 'Installing `mini.deps`' | redraw")
    local clone_cmd = {
        "git", "clone", "--filter=blob:none",
        "https://github.com/echasnovski/mini.deps", mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd("packadd mini.deps | helptags ALL")
    vim.cmd("echo 'Installed `mini.deps`' | redraw")
end

require("mini.deps").setup({ path = { package = path_package } })

local map = function(modes, lhs, rhs, opts)
    local options = { silent = true }
    if opts then
        for k, v in pairs(opts) do
            options[k] = v
        end
    end
    vim.keymap.set(modes, lhs, rhs, options)
end

MiniDeps.later(function()
    MiniDeps.add({
        source = "echasnovski/mini.pick",
        depends = {
            "echasnovski/mini.extra",
        },
    })
    require("mini.pick").setup()
    require("mini.extra").setup()

    MiniDeps.add({
        source = "neovim/nvim-lspconfig",
        depends = {
            "williamboman/mason.nvim",
            "echasnovski/mini.completion",
        },
    })
    require("mason").setup()
    local lspconfig = require("lspconfig")

    local servers = { "gopls", "lua_ls" }
    for _, server in ipairs(servers) do
        lspconfig[server].setup {}
    end

    require("mini.completion").setup()
    MiniDeps.add({
        source = "nvim-treesitter/nvim-treesitter",
        checkout = "master",
        monitor = "main",
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })

    require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "go" },
        highlight = { enable = true },
    })
end)

map("n", "<esc>", function() vim.cmd("nohlsearch") end)
map("t", "<leader><esc>", [[<C-\><C-n>]])

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "ss", "<C-w>s")
map("n", "sv", "<C-w>v")

map("n", "<leader>sf", ":Pick files<CR>")
map("n", "<leader>sg", ":Pick grep_live<CR>")
map("n", "<leader><leader>", ":Pick buffers<CR>")
map("n", "<leader>xx", ":Pick diagnostic<CR>")
map("n", "-", function()
    vim.cmd("Pick explorer cwd='" .. vim.fn.expand('%:p:h') .. "'")
end)

map("n", "gd", vim.lsp.buf.definition)
map("n", "gi", vim.lsp.buf.implementation)
map("n", "gr", vim.lsp.buf.references)
map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "K", vim.lsp.buf.hover)
