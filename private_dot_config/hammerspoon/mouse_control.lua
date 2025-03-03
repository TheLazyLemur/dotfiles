local hs = hs

local modA = "alt"

local step = 10
local timers = {}

local function moveMouse(dx, dy)
    local mouse_location = hs.mouse.getRelativePosition()
    mouse_location.x = mouse_location.x + dx
    mouse_location.y = mouse_location.y + dy
    hs.mouse.setRelativePosition(mouse_location)
end

local function startTimer(key, dx, dy)
    if timers[key] then return end
    timers[key] = hs.timer.doEvery(0.05, function()
        moveMouse(dx, dy)
    end)
end

local function stopTimer(key)
    if timers[key] then
        timers[key]:stop()
        timers[key] = nil
    end
end

local function simulateClick()
    local clickEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown,
        hs.mouse.getAbsolutePosition())
    clickEvent:post()
    hs.timer.usleep(1000) -- Small delay to simulate the press duration
    clickEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, hs.mouse.getAbsolutePosition())
    clickEvent:post()
end

hs.hotkey.bind(modA, "left", function()
    startTimer("left", -step, 0)
end, function()
    stopTimer("left")
end)

hs.hotkey.bind(modA, "right", function()
    startTimer("right", step, 0)
end, function()
    stopTimer("right")
end)

hs.hotkey.bind(modA, "up", function()
    startTimer("up", 0, -step)
end, function()
    stopTimer("up")
end)

hs.hotkey.bind(modA, "down", function()
    startTimer("down", 0, step)
end, function()
    stopTimer("down")
end)

hs.hotkey.bind(modA, "c", function()
    simulateClick()
end)
