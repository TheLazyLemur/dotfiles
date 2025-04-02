local ns_id = vim.api.nvim_create_namespace("my_namespace") -- Create a unique namespace

function Add_virtual_text()
    local bufnr = vim.api.nvim_get_current_buf() -- Get the current buffer
    local result = vim.diagnostic.get(0)

    for _, v in ipairs(result) do
        vim.api.nvim_buf_set_extmark(bufnr, ns_id, v.lnum, 0, {
            virt_text = { { " " .. v.message .. " " .. "[ " .. v.code .. " ]", "error" } }, -- Text and highlight group
            virt_text_pos = "eol", -- Position: "eol" (end of line), "overlay", "right_align"
        })
    end
end

function Clear_virtual_text()
    local bufnr = vim.api.nvim_get_current_buf() -- Get the current buffer
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1) -- Clear all extmarks in the namespace
end

local open = false
vim.keymap.set("n", "<leader>xf", function()
    if open then
        Clear_virtual_text()
        open = false
    else
        Add_virtual_text()
        open = true
    end
end)
