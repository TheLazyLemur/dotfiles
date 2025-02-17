---@class toolbox.Command
---@field name string
---@field execute fun()
---
---@class toolbox.finder.Item : snacks.picker.finder.Item
---@field idx number
---@field name string
---@field divider boolean
---@field execute fun()

---@return toolbox.finder.Item[]
local function get_items()
	---@type toolbox.finder.Item[]
	local items = {}
	local commands = require("toolbox.commands").all_commands()
	for i, v in ipairs(commands) do
		---@type toolbox.finder.Item
		local item = {
			idx = i,
			text = v.name,
			name = v.name,
			execute = v.execute,
			divider = v.name == "-",
		}
		table.insert(items, item)
	end
	return items
end

local function show_toolbox()
	local last_idx = 0
	local items = get_items()

	Snacks.picker({
		title = "@ms Toolbox",
		source = "ms_toolbox",
		items = items,
		format = function(item, picker)
			local width = picker.layout.opts.layout.width * vim.o.columns
			width = math.floor(width)
			width = (width / 10) * 10 - 4

			local text = items[item.idx].divider and string.rep(item.text, width) or item.text

			---@type snacks.picker.Highlight[]
			return {
				{ text, item.text_hl },
			}
		end,
		on_change = function(picker, item)
			if items[item.idx].divider then
				if last_idx < item.idx then
					picker:action("list_down")
				else
					picker:action("list_up")
				end
			end
			last_idx = item.idx
		end,
		layout = "vscode",
		confirm = function(picker, item)
			picker:close()
			items[item.idx].execute()
		end,
	})
end

return {
	"folke/snacks.nvim",
	show_toolbox = show_toolbox,
	keys = {
		{
			"<leader>j",
			function()
				show_toolbox()
			end,
			desc = "@ms Toolbox",
		},
	},
}
