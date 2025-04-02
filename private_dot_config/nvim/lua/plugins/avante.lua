return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {},
    build = "make",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "echasnovski/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                default = {
                    provider = "copilot",
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    use_absolute_path = true,
                },
                copilot = {
                    endpoint = "https://api.githubcopilot.com",
                    proxy = nil, -- [protocol://]host[:port] Use this proxy
                    allow_insecure = false, -- Allow insecure server connections
                    timeout = 10 * 60 * 1000, -- Timeout in milliseconds
                    temperature = 0,
                    max_completion_tokens = 1000000,
                    reasoning_effort = "high",
                },
            },
        },
    },
}
