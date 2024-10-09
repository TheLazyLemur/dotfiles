return {
    {
        name = " Pick Files",
        rtxt = "<leader>sf",
        cmd = function()
            vim.cmd [[ Pick files ]]
        end,
    },
    {
        name = " Pick buffers",
        rtxt = "<leader><leader>",
        cmd = function()
            vim.cmd [[ Pick buffers ]]
        end,
    },
    { name = "separator" },
    {
        name = " Grep",
        rtxt = "<leader>gs",
        cmd = function()
            vim.cmd("Pick grep")
        end,
    },
    {
        name = "󱘢 Grep live",
        rtxt = "<leader>sg",
        cmd = function()
            vim.cmd [[ Pick grep_live ]]
        end,
    },
    {
        name = " Grep cword",
        cmd = function()
            local word_under_cursor = vim.fn.expand("<cword>")
            local cmd = "Pick grep pattern='" .. word_under_cursor .. "'"
            vim.cmd(cmd)
        end,
    },
    { name = "separator" },
    {
        name = "󰘥 Pick Help",
        cmd = function()
            vim.cmd("Pick help")
        end,
    },
}
