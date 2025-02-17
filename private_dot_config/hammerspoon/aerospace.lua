local hs = hs

local AEROSPACE = "/opt/homebrew/bin/aerospace"

local menuBarItem = hs.menubar.new()

local M = {
	last_dir = "horizontal",
	layer = "one",
}

local function setTitle(val)
	menuBarItem:setTitle(val)
end

local function aerospaceExec(cmd)
	os.execute("nohup " .. AEROSPACE .. " " .. cmd .. " &")
end

local function aerospaceExecSync(cmd)
	os.execute(AEROSPACE .. " " .. cmd)
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

M.split_opposite = function()
	aerospaceExec("split opposite")
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

M.resize = function(dir, value)
	aerospaceExec("resize " .. dir .. " " .. value)
end

M.layout = function(v)
	aerospaceExecSync("layout " .. v)
end

M.setup = function()
	aerospaceExec("split horizontal")
	setTitle(M.layer)
end

return M
