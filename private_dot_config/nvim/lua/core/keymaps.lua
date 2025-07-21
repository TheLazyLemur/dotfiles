local map = vim.keymap.set ---@type fun(mode: string|string[], lhs: string, rhs: function|string, opts?: table) = vim.keymap.set

local snacks = require("snacks")
local bookmark = require("bookmark")
local term = require("tuiwrapper")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("n", "<left>", "<C-w>h")
map("n", "<down>", "<C-w>j")
map("n", "<up>", "<C-w>k")
map("n", "<right>", "<C-w>l")

map("n", "<Tab>", ":bnext<CR>")
map("n", "<S-Tab>", ":bprevious<CR>")

for i = 1, 9 do
    map("n", "<leader>" .. tostring(i), function()
        local buffers = vim.fn.getbufinfo({ bufloaded = 1, buflisted = 1 })
        local buf = buffers[i]
        vim.cmd("b " .. buf.bufnr)
    end)
end

map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "ss", "<C-w>s")
map("n", "sv", "<C-w>v")

map("n", "<esc>", function()
    vim.cmd("nohlsearch")
end)

map("n", "qq", ":q!<cr>")
map("n", "qw", ":wq<cr>")

map("n", "<leader>zz", snacks.zen.zoom)

map("n", "<leader>sf", function()
    snacks.picker.files({ layout = require("util").snacks_vscode_bordered() })
end)
map("n", "<leader>sg", function()
    snacks.picker.grep({ layout = require("util").snacks_vscode_bordered() })
end)
map("n", "<leader>gs", function()
    snacks.picker.grep_word({ layout = require("util").snacks_vscode_bordered() })
end)
map("n", "<leader><leader>", function()
    snacks.picker.buffers({ layout = require("util").snacks_vscode_bordered() })
end)
map("n", "<leader>/", function()
    snacks.picker.lines({ layout = require("util").snacks_vscode_bordered() })
end)

map("n", "<leader>n", function()
    snacks.words.jump(1)
end)
map("n", "<leader>p", function()
    snacks.words.jump(-1)
end)

map("n", "<leader>e", function()
    Snacks.picker.explorer({ auto_close = false })
end)

map({ "n", "x", "o" }, "s", function()
    require("flash").jump()
end)

map({ "o" }, "r", function()
    require("flash").remote()
end)

map("t", "<leader><esc>", [[<C-\><C-n>]])

map({ "n", "i" }, "<leader>c/", ":ReferencePoint<cr>")

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("MyVim-LSP-Attach-Keymaps", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        local opts = { noremap = true, silent = true, buffer = args.buf }
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "gi", vim.lsp.buf.implementation, opts)
        map("n", "gr", vim.lsp.buf.references, opts)
        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    end,
})

local dap = require("dap")
local dapui = require("dapui")
local mc = require("multicursor-nvim")
local kulala = require("kulala")

-- Gitsigns keybindings (avoiding conflicts with existing <leader>g and <leader>gs)
local gitsigns = require("gitsigns")

-- Git hunk navigation and operations using <leader>gh prefix
map("n", "<leader>ghn", function()
    if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
    else
        gitsigns.nav_hunk("next")
    end
end, { desc = "Git: Next hunk" })

map("n", "<leader>ghp", function()
    if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
    else
        gitsigns.nav_hunk("prev")
    end
end, { desc = "Git: Previous hunk" })

-- Git hunk actions
map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Git: Stage hunk" })
map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Git: Reset hunk" })
map("v", "<leader>ghs", function()
    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Git: Stage hunk" })
map("v", "<leader>ghr", function()
    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Git: Reset hunk" })
map("n", "<leader>gb", function()
    gitsigns.blame_line({ full = true })
end, { desc = "Git: Blame line" })
map("n", "<leader>gB", gitsigns.toggle_current_line_blame, { desc = "Git: Toggle line blame" })
map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git: Select hunk" })

map("n", "-", ":Oil<cr>")

map({ "n", "v" }, "<c-n>", function()
    mc.addCursor("*")
end)
map({ "n", "v" }, "<c-s>", function()
    mc.skipCursor("*")
end)
map({ "n", "v" }, "<leader>x", mc.deleteCursor)

map({ "n", "v" }, "<c-q>", function()
    if mc.cursorsEnabled() then
        mc.disableCursors()
    else
        mc.addCursor()
    end
end)

map("n", "<leader><esc>", function()
    if not mc.cursorsEnabled() then
        mc.enableCursors()
    elseif mc.hasCursors() then
        mc.clearCursors()
    end
end)

map("v", "I", mc.insertVisual)
map("v", "A", mc.appendVisual)
map("v", "M", mc.matchCursors)

map("n", "<F5>", function()
    local ft = vim.bo.filetype
    if ft == "go" and require("dap").session() == nil then
        require("dap-go").debug_test()
    else
        dap.continue()
    end
end)

map("n", "<F1>", dap.step_into)
map("n", "<F2>", dap.step_over)
map("n", "<F3>", dap.step_out)
map("n", "<F7>", dapui.toggle)

map("n", "<leader>b", dap.toggle_breakpoint)
map("n", "<leader>B", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Set Breakpoint" })

map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>")
map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>")
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>")
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>")

map("n", "<leader><Tab>", ":TSContext toggle<CR>")

map("n", "<leader><Leader>s", function()
    require("settings"):show_settings()
end)

map("n", "<leader>mb", bookmark.add_bookmark, { desc = "Add bookmark" })
map("n", "<leader>md", bookmark.display, { desc = "Display bookmarks" })

map("n", "<leader>g", function()
    term.lazygit_toggle()
end)

map("n", "<leader>d", function()
    term.lazydocker_toggle()
end)

map("n", "<leader>c", function()
    term.claude_toggle()
end)

map({ "n", "t" }, "<leader>tf", ":ToggleTerm<CR>")

local ft_keymaps = {
    ["*.http"] = function(args)
        local bufnr = args.buf
        local opts = { noremap = true, silent = true, buffer = bufnr }

        map("n", "<CR>", kulala.run, opts)
    end,
    ["*test.go"] = function(args)
        local bufnr = args.buf
        local opts = { noremap = true, silent = true, buffer = bufnr }

        map("n", "<leader>tt", function()
            require("neotest").run.run(vim.fn.expand("%"))
        end, opts)
        map("n", "<leader>tf", function()
            require("neotest").run.run()
        end, opts)
        map("n", "<leader>to", function()
            vim.cmd("Neotest output")
        end, opts)
        map("n", "<leader>tc", ":GoTestSubCase -v -F<CR>", opts)
        map("n", "<leader><F5>", require("dap-go").debug_test)
        map("n", "<F9>", function()
            if require("dap").session() == nil then
                require("dap-go").debug_last_test()
            end
        end)
    end,
}

local augroup = vim.api.nvim_create_augroup("MyVim-FT-Plugin-Keymaps", { clear = true })
for key, value in pairs(ft_keymaps) do
    vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup,
        pattern = key,
        callback = value,
    })
end
