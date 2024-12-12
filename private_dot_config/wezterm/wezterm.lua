local wezterm = require 'wezterm';
local act = wezterm.action

local config = wezterm.config_builder()
config.color_scheme = 'Rosé Pine Moon (Gogh)'

config.keys = {
    {
        key = "s",
        mods = "LEADER",
        action = wezterm.action_callback(function(window, pane)
            pane:split { direction = "Bottom" }
        end),
    },
    {
        key = "v",
        mods = "LEADER",
        action = wezterm.action_callback(function(window, pane)
            pane:split { direction = "Right" }
        end),
    },
    { key = 'q',        mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
    { key = 'Enter',    mods = "LEADER", action = act.TogglePaneZoomState },
    { key = 'u',        mods = 'LEADER', action = act.ScrollByLine(-4) },
    { key = 'd',        mods = 'LEADER', action = act.ScrollByLine(5) },
    { key = 'PageUp',   mods = 'NONE',   action = act.ScrollByPage(-0.75) },
    { key = 'PageDown', mods = 'NONE',   action = act.ScrollByPage(0.75) },
}

config.font = wezterm.font 'ComicShannsMono Nerd Font'
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.font_size = 14
config.line_height = 1.3
config.window_background_opacity = 0.9
config.audible_bell = "Disabled"

require("tabs").setup(config)
require("split").setup(config)

return config
