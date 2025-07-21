return {
    cmd = { "lua-language-server" },
    root_markers = {
        "init.lua",
    },
    filetypes = { "lua" },
    on_init = require("util").lua_ls_on_init,
}
