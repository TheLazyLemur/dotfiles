---@class Bookmarks
---@field bookmarks BookmarkList
local M = {
	bookmarks = {},
}

function M.add(name, line, file)
	table.insert(M.bookmarks, {
		name = name,
		line = line,
		file = file,
	})
end

return M
