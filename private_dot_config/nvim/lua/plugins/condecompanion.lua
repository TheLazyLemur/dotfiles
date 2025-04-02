return {
    "olimorris/codecompanion.nvim",
    config = function()
        require("codecompanion").setup({
            strategies = {},
            adapters = {
                llama3 = function()
                    return require("codecompanion.adapters").extend("ollama", {
                        name = "codegemma:latest",
                        schema = {
                            model = {
                                default = "codegemma:latest",
                            },
                            num_ctx = {
                                default = 16384,
                            },
                            num_predict = {
                                default = -1,
                            },
                        },
                    })
                end,
            },
        })
    end,
}
