return {
	"serenevoid/kiwi.nvim",
	config = function()
		require("kiwi").setup()
		local kiwi = require("kiwi")
		vim.keymap.set("n", "<leader>ww", kiwi.open_wiki_index, {})
		vim.keymap.set("n", "T", kiwi.todo.toggle, {})
	end,
}
