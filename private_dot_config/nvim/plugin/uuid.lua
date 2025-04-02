local function gen_uuid_v7()
    local now = os.time() * 1000 -- Get current time in milliseconds
    local time_hex = string.format("%012x", now) -- Convert to hex (12 chars)

    local rand_a = string.format("%04x", math.random(0, 0xFFFF))
    local rand_b = string.format("%04x", math.random(0, 0xFFFF))
    local rand_d = string.format("%012x", math.random(0, 0xFFFFFFFFFFFF))

    return string.format("%s-%s-7%s-%s-%s", time_hex:sub(1, 8), time_hex:sub(9, 12), rand_a:sub(2, 4), rand_b, rand_d)
end

local function gen_uuid()
    local result = gen_uuid_v7()

    local line = vim.api.nvim_get_current_line()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local col = cursor_pos[2] + 1

    local new_line = line:sub(1, col) .. result .. line:sub(col + 1)
    vim.api.nvim_set_current_line(new_line)
end

vim.api.nvim_create_user_command("UUID", gen_uuid, {})
