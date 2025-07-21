local function copy_reference_point()
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
    local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
    local reference_point = path .. ":" .. tostring(row) .. ":" .. tostring(col)
    vim.fn.setreg("+", reference_point)
end

vim.api.nvim_create_user_command("ReferencePoint", copy_reference_point, {})
