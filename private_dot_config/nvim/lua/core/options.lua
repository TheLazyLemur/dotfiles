vim.opt.number = true
vim.opt.relativenumber = true
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
vim.opt.linebreak = true
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.winblend = 10
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.virtualedit = "block"
vim.opt.cmdheight = 0

vim.cmd("filetype plugin indent on")
vim.filetype.add({
    extension = {
        ["http"] = "http",
        ["templ"] = "templ",
    },
})

if vim.g.neovide then
    vim.opt.linespace = 10
    vim.g.neovide_cursor_animation_length = 0.13
    vim.g.neovide_cursor_trail_length = 0.8
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_refresh_rate = 60

    vim.keymap.set("n", "<D-s>", ":w<CR>")
    vim.keymap.set("v", "<D-c>", '"+y')
    vim.keymap.set("n", "<D-v>", '"+P')
    vim.keymap.set("v", "<D-v>", '"+P')
    vim.keymap.set("c", "<D-v>", "<C-R>+")
    vim.keymap.set("i", "<D-v>", "<C-R>+")

    local function change_font_size(delta)
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
    end

    vim.keymap.set("n", "<C-=>", function()
        change_font_size(0.1)
    end)
    vim.keymap.set("n", "<C-->", function()
        change_font_size(-0.1)
    end)
end
