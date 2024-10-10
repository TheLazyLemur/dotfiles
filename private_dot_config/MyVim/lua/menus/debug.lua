return {
    {
        name = "Toggle Debugger",
        cmd = require("dapui").toggle,
        rtxt = "<F7>",
    },
    { name = "separator" },
    {
        name = " Step Continue",
        cmd = require("dap").continue,
        rtxt = "<F5>",
    },
    {
        name = "󰌑 Step Into",
        cmd = require("dap").step_into,
        rtxt = "<F1>",
    },
    {
        name = "⏭ Step Over",
        cmd = require("dap").step_over,
        rtxt = "<F2>",
    },
    {
        name = "⏮ Step Out",
        cmd = require("dap").step_out,
        rtxt = "<F3>",
    },
    { name = "separator" },
    {
        name = " Toggle Breakpoint",
        cmd = require("dap").toggle_breakpoint,
        rtxt = "<leader>b",
    },
    {
        name = " Toggle Breakpoint Cond",
        cmd = function()
            require("dap").set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        rtxt = "<leader>B",
    },
}
