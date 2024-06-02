local live_grep = {
    last_output = {},
    handle = nil,
    stdout = nil,
    stderr = nil,
    stdout_buffer = "",
}

function live_grep.on_select(value)
    return function()
        local file = vim.fn.split(value, ":")[1]
        local line = vim.fn.split(value, ":")[2]
        vim.cmd("e " .. file)
        vim.cmd("normal! " .. line .. "G")
    end
end

function live_grep.on_input(value, cb)
    pcall(function()
        live_grep.handle:close()
        live_grep.handle = nil
        live_grep.stdout:read_stop()
        live_grep.stderr:read_stop()
    end)

    local results = {}

    live_grep.stdout = vim.loop.new_pipe(false)
    live_grep.stderr = vim.loop.new_pipe(false)

    local function on_exit(code, status)
        if code == 0 then
            live_grep.last_output = results
            if cb then
                cb(live_grep.last_output)
                if live_grep.handle then
                    live_grep.handle:close()
                    live_grep.handle = nil
                end
            end
        else
            print(code)
        end
    end

    local handle, _ = vim.loop.spawn("sh", {
        args = { "-c", "rg -n " .. "'" .. value .. "'" .. " | awk -F: '{print $1\":\"$2}'" },
        stdio = { nil, live_grep.stdout, live_grep.stderr },
    }, on_exit)

    live_grep.handle = handle

    if live_grep.handle then
        live_grep.stdout:read_start(function(err, data)
            assert(not err, err)
            if data then
                live_grep.stdout_buffer = live_grep.stdout_buffer .. data
                for line in live_grep.stdout_buffer:gmatch("([^\n]*)\n") do
                    table.insert(results, line)
                end
                live_grep.stdout_buffer = live_grep.stdout_buffer:match("[^\n]*$")
            end
        end)

        live_grep.stderr:read_start(function(err, data)
            assert(not err, err)
            if data then
                print("stderr:", data)
            end
        end)
    end
end

return live_grep
