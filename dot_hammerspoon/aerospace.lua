local AEROSPACE = "/opt/homebrew/bin/aerospace"

local menuBarItem = hs.menubar.new()

local M = {
    last_dir = "horizontal",
    layer = "one",
}

local function setTitle(val)
    menuBarItem:setTitle(val)
end

local function splitByNewline(text)
    local lines = {}
    for line in string.gmatch(text, "[^\r\n]+") do
        table.insert(lines, line)
    end
    return lines
end

local function aerospaceExec(cmd)
    os.execute("nohup " .. AEROSPACE .. " " .. cmd .. " &")
end

M.toggle_layer = function()
    if M.layer == "one" then
        M.layer = "two"
    else
        M.layer = "one"
    end
    M.setTitle(M.layer)
end

M.setTitle = function(val)
    setTitle(val)
end

M.focus_left = function()
    aerospaceExec("focus left")
end

M.focus_right = function()
    aerospaceExec("focus right")
end

M.focus_up = function()
    aerospaceExec("focus up")
end

M.focus_down = function()
    aerospaceExec("focus down")
end

M.swap_monitor = function()
    aerospaceExec("move-workspace-to-monitor prev")
end

M.open_terminal = function()
    local output, _, _, _ = hs.execute(AEROSPACE .. " list-windows --workspace visible")
    local lines = splitByNewline(output)
    if #lines == 1 then
        aerospaceExec("split horizontal")
        M.last_dir = "horizontal"
    end

    if #lines > 1 then
        if M.last_dir == "horizontal" then
            aerospaceExec("split vertical")
            M.last_dir = "vertical"
        else
            aerospaceExec("split horizontal")
            M.last_dir = "horizontal"
        end
    end


    os.execute("nohup " .. "/opt/homebrew/bin/wezterm start --always-new-process" .. " &")
end

M.move_to_workspace = function(i)
    if M.layer == "two" then
        aerospaceExec("workspace " .. tostring(i + 10))
    else
        aerospaceExec("workspace " .. tostring(i))
    end
end

M.move_node_to_workspace = function(i)
    if M.layer == "two" then
        aerospaceExec("move-node-to-workspace " .. tostring(i + 10))
    else
        aerospaceExec("move-node-to-workspace " .. tostring(i))
    end
end

M.move_left = function()
    aerospaceExec("move left")
end

M.move_right = function()
    aerospaceExec("move right")
end

M.move_up = function()
    aerospaceExec("move up")
end

M.move_down = function()
    aerospaceExec("move down")
end

M.quit = function()
    aerospaceExec("close")
end

M.fullscreen = function()
    aerospaceExec("fullscreen")
end

M.setup = function()
    aerospaceExec("split horizontal")
    setTitle(M.layer)
end


return M
