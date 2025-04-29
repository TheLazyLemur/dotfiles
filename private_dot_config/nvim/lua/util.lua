local M = {}

function M.lua_ls_on_init(client)
    local path = vim.tbl_get(client, "workspace_folders", 1, "name")
    if not path then
        return
    end
    client.settings = vim.tbl_deep_extend("force", client.settings, {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
        },
    })
end

function M.snacks_vscode_bordered()
    return {
        preview = false,
        layout = {
            backdrop = false,
            row = 2,
            width = 0.4,
            min_width = 80,
            height = 0.4,
            border = "none",
            box = "vertical",
            {
                win = "input",
                height = 1,
                border = "rounded",
                title = "{title} {live} {flags}",
                title_pos = "center",
            },
            { win = "list", border = "rounded" },
            { win = "preview", title = "{preview}", border = "rounded" },
        },
    }
end

return M
