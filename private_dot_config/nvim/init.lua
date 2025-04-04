if vim.fn.has("nvim-0.11") == 0 then
    vim.notify("Neovim version 0.11 or higher is required")
    return
end

require("core")

if vim.g.neovide then
    vim.opt.linespace = 10
    vim.g.neovide_cursor_animation_length = 0.13
    vim.g.neovide_cursor_trail_length = 0.8
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_refresh_rate = 60

    vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
    vim.keymap.set("v", "<D-c>", '"+y') -- Copy
    vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
    vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
    vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
    vim.keymap.set("i", "<D-v>", "<C-R>+") -- Paste insert mode

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
