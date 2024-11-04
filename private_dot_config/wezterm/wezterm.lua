local wezterm = require 'wezterm';
local act = wezterm.action

local config = wezterm.config_builder()

local M = { next_dir = "Right" }

config.key_tables = {
    resize_font = {
        { key = 'k',      action = act.IncreaseFontSize },
        { key = 'j',      action = act.DecreaseFontSize },
        { key = 'r',      action = act.ResetFontSize },
        { key = 'Escape', action = 'PopKeyTable' },
        { key = 'q',      action = 'PopKeyTable' },
    },
    resize_pane = {
        { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
        { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
        { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
        { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
        { key = 'Escape', action = 'PopKeyTable' },
        { key = 'q',      action = 'PopKeyTable' },
    },
}

config.keys = {
    {
        key = "s",
        mods = "LEADER",
        action = wezterm.action_callback(function(window, pane)
            pane:split { direction = M.next_dir }
            if M.next_dir == "Right" then
                M.next_dir = "Bottom"
            else
                M.next_dir = "Right"
            end
        end),
    },
    { key = 'q',        mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
    { key = 'Enter',    mods = "LEADER", action = act.TogglePaneZoomState },
    { key = 'k',        mods = "LEADER", action = act.ActivatePaneDirection('Up') },
    { key = 'j',        mods = "LEADER", action = act.ActivatePaneDirection('Down') },
    { key = 'h',        mods = "LEADER", action = act.ActivatePaneDirection('Left') },
    { key = 'l',        mods = "LEADER", action = act.ActivatePaneDirection('Right') },
    { key = 'u',        mods = 'LEADER', action = act.ScrollByLine(-4) },
    { key = 'd',        mods = 'LEADER', action = act.ScrollByLine(5) },
    { key = 'PageUp',   mods = 'NONE',   action = act.ScrollByPage(-0.75) },
    { key = 'PageDown', mods = 'NONE',   action = act.ScrollByPage(0.75) },
    {
        key = 'f',
        mods = 'LEADER',
        action = act.ActivateKeyTable({
            name = 'resize_font',
            one_shot = false,
            timemout_miliseconds = 1000,
        }),
    },
    {
        key = 'w',
        mods = 'LEADER',
        action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
    },
}

config.font = wezterm.font 'JetBrains Mono'
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
config.font_size = 12

return config
