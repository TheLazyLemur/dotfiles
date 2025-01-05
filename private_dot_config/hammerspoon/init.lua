local hs = hs

local aerospace = require("aerospace")

local modA = "alt"
local shiftKey = "shift"
local left = "h"
local down = "j"
local up = "k"
local right = "l"

aerospace.setup()

hs.hotkey.bind({ modA, shiftKey }, "tab", aerospace.swap_monitor)

hs.hotkey.bind({ modA }, left, aerospace.focus_left)
hs.hotkey.bind({ modA }, down, aerospace.focus_down)
hs.hotkey.bind({ modA }, up, aerospace.focus_up)
hs.hotkey.bind({ modA }, right, aerospace.focus_right)
hs.hotkey.bind({ modA }, "v", aerospace.toggle_layer)

for i = 1, 9 do
	hs.hotkey.bind({ modA }, tostring(i), function()
		aerospace.move_to_workspace(i)
	end)

	hs.hotkey.bind({ modA, shiftKey }, tostring(i), function()
		aerospace.move_node_to_workspace(i)
	end)
end

hs.hotkey.bind({ modA, shiftKey }, left, aerospace.move_left)
hs.hotkey.bind({ modA, shiftKey }, down, aerospace.move_down)
hs.hotkey.bind({ modA, shiftKey }, up, aerospace.move_up)
hs.hotkey.bind({ modA, shiftKey }, right, aerospace.move_right)
hs.hotkey.bind({ modA, shiftKey }, "q", aerospace.quit)
hs.hotkey.bind({ modA, shiftKey }, "f", aerospace.fullscreen)

hs.hotkey.bind({ modA, shiftKey }, "o", function()
	aerospace.layout("floating")
end)
hs.hotkey.bind({ modA, shiftKey }, "p", function()
	aerospace.layout("tiling")
end)

hs.hotkey.bind({ modA }, "return", function()
	os.execute("nohup " .. "open -na /Applications/Ghostty.app" .. " &")
end)
