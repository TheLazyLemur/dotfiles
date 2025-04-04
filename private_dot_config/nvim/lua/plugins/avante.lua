return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
        provider = "copilot",
        -- provider = "ollama",
        copilot = {
            endpoint = "https://api.githubcopilot.com",
            allow_insecure = false, -- Allow insecure server connections
            timeout = 10 * 60 * 1000, -- Timeout in milliseconds
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
