local hs = hs

local Hyper = { "cmd", "alt", "ctrl", "shift" }

hs.hotkey.bind(Hyper, "r", function()
    hs.reload()
end)

hs.hotkey.bind(Hyper, "q", function()
    local win = hs.window.focusedWindow()
    if win then
        win:close()
    else
        hs.alert.show("No focused window")
    end
end)

hs.hotkey.bind(Hyper, "return", function()
    os.execute("nohup open -na /Applications/Ghostty.app &")
end)

-- Move window to left half of screen
hs.hotkey.bind(Hyper, "left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

-- Move window to right half of screen
hs.hotkey.bind(Hyper, "right", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

-- Maximize window
hs.hotkey.bind(Hyper, "up", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end)

-- Almost maximize window (90% of screen)
hs.hotkey.bind(Hyper, "down", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    local marginX = max.w * 0.05
    local marginY = max.h * 0.05

    f.x = max.x + marginX
    f.y = max.y + marginY
    f.w = max.w - (2 * marginX)
    f.h = max.h - (2 * marginY)
    win:setFrame(f)
end)

local windowIndex = 1
local windowList = {}
local isWindowCycling = false
local cycleTimer = nil

local function updateWindowList()
    windowList = {}
    local wins = hs.window.orderedWindows() -- Gets windows in focus order

    for _, win in ipairs(wins) do
        if win:isVisible() and win:application() and win:screen() then
            table.insert(windowList, win)
        end
    end
end

local function cycleWindows()
    updateWindowList()
    if #windowList <= 1 then
        return
    end

    windowIndex = windowIndex % #windowList + 1
    windowList[windowIndex]:focus()
end

-- Start the cycling mode
hs.hotkey.bind(Hyper, "p", function()
    if not isWindowCycling then
        updateWindowList()
        isWindowCycling = true

        -- If no windows or only one window, do nothing
        if #windowList <= 1 then
            isWindowCycling = false
            return
        end

        windowIndex = 1
        if cycleTimer then
            cycleTimer:stop()
        end
    end

    cycleWindows()

    -- Reset after a delay when key is released
    cycleTimer = hs.timer.doAfter(1, function()
        isWindowCycling = false
    end)
end)
