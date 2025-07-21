local REQUIRED_NVIM_VERSION = "nvim-0.11"
local REQUIRED_VERSION_MESSAGE = "Neovim version 0.11 or higher is required"

local function load_core_modules()
    require("core")
end

local function version_check()
    if not vim.fn.has(REQUIRED_NVIM_VERSION) then
        vim.notify(REQUIRED_VERSION_MESSAGE)
        return false
    end
    return true
end

local function setup()
    if version_check() then
        load_core_modules()
    end
end

setup()
