local deps = {
    nui_popup = require("nui.popup"),
    nui_layout = require("nui.layout")
}

local M = {
    layout = nil,
    builtin = {},
    last_results = {},
    active_picker = nil,
    cursor_position = 1,
}

M.builtin.find_files = require("dude.pickers.file_picker")
M.builtin.live_grep = require("dude.pickers.live_grep")

function M.setup(opts)
    opts = opts or {}
    M.opts = opts

    return M
end

function M.shift_cursor_and_update(bufnr, direction)
    M.cursor_position = M.cursor_position + direction
    local display = {}
    for i, result in ipairs(M.last_results) do
        if i == M.cursor_position then
            table.insert(display, "=> " .. result)
        else
            table.insert(display, result)
        end
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, display)
end

function M.open_ui(worker)
    M.active_picker = worker

    local popup_one, popup_two = deps.nui_popup({
        enter = true,
        border = "single",

    }), deps.nui_popup({
        border = "double",
    })


    local timer = vim.loop.new_timer()

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        buffer = popup_one.bufnr,
        group = vim.api.nvim_create_augroup("dude.changed", { clear = true }),
        callback = function()
            timer:stop()
            timer:start(500, 0, vim.schedule_wrap(function()
                local filter_value = vim.api.nvim_buf_get_lines(popup_one.bufnr, 0, -1, false)[1]
                M.last_results = worker.on_input(filter_value, function(results)
                    vim.schedule(function()
                        M.cursor_position = 1
                        M.last_results = results

                        local display = {}
                        for i, result in ipairs(M.last_results) do
                            if i == M.cursor_position then
                                table.insert(display, "=> " .. result)
                            else
                                table.insert(display, result)
                            end
                        end

                        vim.api.nvim_buf_set_lines(popup_two.bufnr, 0, -1, false, display)
                    end)
                end)
            end))
        end,
    })

    M.layout = deps.nui_layout(
        {
            position = "50%",
            size = {
                width = 80,
                height = 30,
            },
        },
        deps.nui_layout.Box({
            deps.nui_layout.Box(popup_one, { size = "10%" }),
            deps.nui_layout.Box(popup_two, { size = "90%" }),
        }, { dir = "col" })
    )

    vim.keymap.set("i", "<CR>", function()
        local cb = M.active_picker.on_select(M.last_results[M.cursor_position])
        M.layout:unmount()
        vim.cmd("stopinsert")
        cb()
    end, { buffer = popup_one.bufnr })

    vim.keymap.set("i", "<C-n>", function()
        M.shift_cursor_and_update(popup_two.bufnr, 1)
    end, { buffer = popup_one.bufnr })

    vim.keymap.set("i", "<C-p>", function()
        M.shift_cursor_and_update(popup_two.bufnr, -1)
    end, { buffer = popup_one.bufnr })

    M.layout:mount()
end

return M
