return {
    "olimorris/codecompanion.nvim",
    -- commit = "9c8c55a16597ac3880740632d14bc15b3d2e786d",
    -- branch = "fix/tools-auto-submit-request-order",
    config = function()
        require("codecompanion").setup({
            strategies = {
                chat = {
                    adapter = "copilot",
                },
            },
            adapters = {
                copilot = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        name = "copilot",
                        schema = {
                            model = {
                                -- default = "claude-3.7-sonnet",
                                -- default = "claude-3.5-sonnet",
                                -- default = "gpt-4o",
                                -- default = "o1",
                            },
                        },
                    })
                end,
            },
        })
    end,
}
