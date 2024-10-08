return {
    {
        name = "Pick Files",
        hl = "Exwhite",
        cmd = function()
            vim.cmd [[ Pick files ]]
        end,
    },
    {
        name = "Pick buffers",
        hl = "Exwhite",
        cmd = function()
            vim.cmd [[ Pick buffers ]]
        end,
    },
    { name = "separator" },
    {
        name = "Grep",
        hl = "Exwhite",
        cmd = function()
            vim.cmd("Pick grep")
        end,
    },
    {
        name = "Grep live",
        hl = "Exwhite",
        cmd = function()
            vim.cmd [[ Pick grep_live ]]
        end,
    },
    {
        name = "Grep cword",
        hl = "Exwhite",
        cmd = function()
            local word_under_cursor = vim.fn.expand("<cword>")
            local cmd = "Pick grep pattern='" .. word_under_cursor .. "'"
            vim.cmd(cmd)
        end,
    },
    { name = "separator" },
    {
        name = "Pick Help",
        hl = "Exwhite",
        cmd = function()
            vim.cmd("Pick help")
        end,
    },
}
