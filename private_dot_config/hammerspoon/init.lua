local hs = hs

local aerospace = require("aerospace")

local Alt = "alt"
local Shift = "shift"
local Ctrl = "ctrl"
local Cmd = "cmd"

local AltShift = { Alt, Shift }
local Hyper = { Cmd, Alt, Ctrl, Shift }

local left = "h"
local down = "j"
local up = "k"
local right = "l"

aerospace.setup()

hs.hotkey.bind(AltShift, "tab", aerospace.swap_monitor)

hs.hotkey.bind({ Alt }, left, aerospace.focus_left)
hs.hotkey.bind({ Alt }, down, aerospace.focus_down)
hs.hotkey.bind({ Alt }, up, aerospace.focus_up)
hs.hotkey.bind({ Alt }, right, aerospace.focus_right)
hs.hotkey.bind({ Alt }, "v", aerospace.toggle_layer)

for i = 1, 9 do
	hs.hotkey.bind({ Alt }, tostring(i), function()
		aerospace.move_to_workspace(i)
	end)

	hs.hotkey.bind(AltShift, tostring(i), function()
		aerospace.move_node_to_workspace(i)
	end)
end

hs.hotkey.bind(AltShift, left, aerospace.move_left)
hs.hotkey.bind(AltShift, down, aerospace.move_down)
hs.hotkey.bind(AltShift, up, aerospace.move_up)
hs.hotkey.bind(AltShift, right, aerospace.move_right)
hs.hotkey.bind(AltShift, "q", aerospace.quit)
hs.hotkey.bind(AltShift, "f", aerospace.fullscreen)

hs.hotkey.bind(AltShift, "o", function()
	aerospace.layout("floating")
end)
hs.hotkey.bind(AltShift, "p", function()
	aerospace.layout("tiling")
end)

hs.hotkey.bind({ Alt }, "return", function()
	os.execute("nohup " .. "open -na /Applications/Ghostty.app" .. " &")
end)

hs.hotkey.bind(AltShift, "right", function()
	aerospace.resize("smart", "+10")
end)

hs.hotkey.bind(AltShift, "left", function()
	aerospace.resize("smart", "-10")
end)

hs.hotkey.bind(AltShift, "up", function()
	aerospace.resize("smart-opposite", "+10")
end)

hs.hotkey.bind(AltShift, "down", function()
	aerospace.resize("smart-opposite", "-10")
end)

hs.hotkey.bind(Hyper, "0", function()
	hs.reload()
end)

hs.hotkey.bind(Hyper, "t", function()
	os.execute("nohup " .. "open -na /Applications/Ghostty.app" .. " &")
end)
