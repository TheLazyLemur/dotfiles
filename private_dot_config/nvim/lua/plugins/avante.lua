return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
        provider = "copilot",
        behaviour = {
            enable_cursor_planning_mode = true,
        },
        copilot = {
            -- model = "claude-3.7-sonnet",
            -- model = "claude-3.5-sonnet",
            -- model = "gpt-3.5",
            model = "gpt-4o",
            endpoint = "https://api.githubcopilot.com",
            allow_insecure = false,
            timeout = 10 * 60 * 1000,
            temperature = 0,
            max_completion_tokens = 1000000,
            reasoning_effort = "high",
        },
        ollama = {
            model = "qwen2.5-coder:14b",
        },
    },
    build = "make",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "echasnovski/mini.pick",
        "nvim-telescope/telescope.nvim",
        "hrsh7th/nvim-cmp",
        "ibhagwan/fzf-lua",
        "nvim-tree/nvim-web-devicons",
        "zbirenbaum/copilot.lua",
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {},
        },
    },
}
