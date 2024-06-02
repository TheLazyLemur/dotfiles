local find_files = {
    last_output = {},
    handle = nil,
    stdout = nil,
    stderr = nil,
    stdout_buffer = "",
}

function find_files.on_select(value)
    return function()
        vim.cmd("e " .. value)
    end
end

function find_files.on_input(value, cb)
    pcall(function()
        find_files.handle:close()
        find_files.handle = nil
        find_files.stdout:read_stop()
        find_files.stderr:read_stop()
    end)

    local results = {}


    find_files.stdout = vim.loop.new_pipe(false)
    find_files.stderr = vim.loop.new_pipe(false)

    local function on_exit(code, status)
        if code == 0 then
            find_files.last_output = results
            if cb then
                cb(find_files.last_output)
                if find_files.handle then
                    find_files.handle:close()
                    find_files.handle = nil
                end
            end
        else
            print(code)
        end
    end

    local handle, _ = vim.loop.spawn("sh", {
        args = { "-c", "fd --type=f | fzf --filter=" .. value },
        stdio = { nil, find_files.stdout, find_files.stderr },
    }, on_exit)

    find_files.handle = handle

    if find_files.handle then
        find_files.stdout:read_start(function(err, data)
            if #results < 5000 then
                assert(not err, err)
                if data then
                    find_files.stdout_buffer = find_files.stdout_buffer .. data
                    for line in find_files.stdout_buffer:gmatch("([^\n]*)\n") do
                        table.insert(results, line)
                    end
                    find_files.stdout_buffer = find_files.stdout_buffer:match("[^\n]*$")
                end
            end
        end)

        find_files.stderr:read_start(function(err, data)
            assert(not err, err)
            if data then
                print("stderr:", data)
            end
        end)
    end
end

return find_files
