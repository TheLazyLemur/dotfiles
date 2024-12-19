local M = {}

PICKER = "telescope"

M.files = function()
    if PICKER == "mini" then
        vim.cmd("Pick files")
    else
        vim.cmd("Telescope find_files")
    end
end

M.buffers = function()
    if PICKER == "mini" then
        vim.cmd("Pick buffers")
    else
        vim.cmd("Telescope buffers")
    end
end

M.live_grep = function()
    if PICKER == "mini" then
        vim.cmd("Pick grep_live")
    else
        vim.cmd("Telescope live_grep")
    end
end

M.grep_string = function()
    if PICKER == "mini" then
        vim.cmd("Pick grep")
    else
        vim.cmd("Telescope grep_string")
    end
end

return M
