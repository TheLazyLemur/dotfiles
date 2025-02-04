return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.deps").setup()
		local now, later = MiniDeps.now, MiniDeps.later

		now(require("mini.diff").setup)
		now(require("mini.git").setup)

		now(require("mini.statusline").setup)

		now(require("mini.misc").setup)
		now(require("mini.misc").setup_restore_cursor)
		now(require("mini.misc").setup_auto_root)

		now(require("mini.basics").setup)

		now(require("mini.icons").setup)
		now(require("mini.icons").mock_nvim_web_devicons)

		later(function()
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
		end)
	end,
}
