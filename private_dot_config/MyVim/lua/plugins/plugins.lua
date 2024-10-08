local plugins = {
    {
        source = "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup()
        end
    },
    {
        source = "stevearc/oil.nvim",
        config = function()
            require("oil").setup()
        end
    },
    {
        source = "jake-stewart/multicursor.nvim",
        config = function()
            require("multicursor-nvim").setup()
            vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
            vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
            vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
            vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        end
    },
    {
        name = "catppuccin",
        source = "catppuccin/nvim",
        config = function()
            vim.cmd("colorscheme catppuccin")
        end
    },
    {
        source = 'mfussenegger/nvim-dap',
        depends = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "jay-babu/mason-nvim-dap.nvim",
            "leoluz/nvim-dap-go",
        },
        config = function()
            vim.fn.sign_define('DapBreakpoint', { text = " ", texthl = 'error', linehl = 'error', numhl = 'error' })
            vim.fn.sign_define('DapBreakpointCondition',
                { text = " ", texthl = 'warn', linehl = 'warn', numhl = 'warn' })

            local dap = require("dap")
            local dapui = require("dapui")

            require('mason-nvim-dap').setup {
                automatic_installation = false,
                automatic_setup = true,
                handlers = {},
                ensure_installed = {
                    'delve',
                },
            }
            dapui.setup {
                icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
                controls = {
                    icons = {
                        pause = ' ',
                        play = '',
                        step_into = '󰌑 ',
                        step_over = '⏭',
                        step_out = '⏮',
                        step_back = 'b',
                        run_last = '▶▶',
                        terminate = ' ',
                        disconnect = '⏏',
                    },
                },
            }

            dap.listeners.after.event_initialized['dapui_config'] = dapui.open
            dap.listeners.before.event_terminated['dapui_config'] = dapui.close
            dap.listeners.before.event_exited['dapui_config'] = dapui.close

            require('dap-go').setup()
        end,
    },
    {
        source = "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup()
        end
    },
    {
        source = 'nvim-treesitter/nvim-treesitter',
        depends = {
            "nvim-treesitter/nvim-treesitter-context",
        },
        checkout = 'master',
        monitor = 'main',
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { 'go' },
                highlight = { enable = true },
            })
            require 'treesitter-context'.setup {}
        end
    },
    {
        name = "error-jump",
        source = "Dr-42/error-jump.nvim",
    },
    {
        source = "mistweaverco/kulala.nvim",
        config = function()
            require("kulala").setup()
        end
    },
    {
        source = "nvchad/menu",
        depends = {
            "nvchad/volt",
        },
        config = function()
        end
    },
    {
        source = "nvim-tree/nvim-tree.lua",
        config = function ()
            require("nvim-tree").setup()
        end
    },
}

for _, p in pairs(plugins) do
    MiniDeps.add(p)
    if p.config ~= nil then
        MiniDeps.now(function()
            local ok = pcall(p.config)
            if not ok then
                print("Failed to load plugin" .. p.source)
            end
        end)
    end
end
