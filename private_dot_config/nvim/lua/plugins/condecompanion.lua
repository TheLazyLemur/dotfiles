return {
    "olimorris/codecompanion.nvim",
    config = function()
        require("codecompanion").setup({
            strategies = {
                -- chat = { adapter = "ollama" },
                -- inline = { adapter = "ollama" },
            },
            adapters = {
                llama3 = function()
                    return require("codecompanion.adapters").extend("ollama", {
                        name = "codegemma:latest", -- Give this adapter a different name to differentiate it from the default ollama adapter
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
