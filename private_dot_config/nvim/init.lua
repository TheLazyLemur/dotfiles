if vim.fn.has("nvim-0.11") == 0 then
    vim.notify("Neovim version 0.11 or higher is required")
    return
end

require("core")
