return {
    "olimorris/codecompanion.nvim",
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
                                default = "gpt-4o",
                            },
                        },
                    })
                end,
            },
        })
    end,
}
