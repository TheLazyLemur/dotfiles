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

function M.snacks_vertical()
	return {
		layout = {
			backdrop = false,
			width = 0.7,
			min_width = 80,
			height = 0.8,
			min_height = 30,
			box = "vertical",
			border = "rounded",
			title = "{title} {live} {flags}",
			title_pos = "center",
			{ win = "input", height = 1, border = "bottom" },
			{ win = "list", border = "none", height = 0.3 },
			{ win = "preview", title = "{preview}", height = 0.5, border = "top" },
		},
	}
end

return M
