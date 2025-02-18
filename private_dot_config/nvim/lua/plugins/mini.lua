return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.diff").setup()

		require("mini.git").setup()

		require("mini.statusline").setup()
		require("mini.tabline").setup()

		require("mini.misc").setup()
		require("mini.misc").setup_restore_cursor()
		require("mini.misc").setup_auto_root()

		require("mini.basics").setup()

		require("mini.icons").setup()
		require("mini.icons").mock_nvim_web_devicons()

		local hipatterns = require("mini.hipatterns")
		hipatterns.setup({
			highlighters = {
				fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
				hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})
	end,
}
