return {
	"lukas-reineke/indent-blankline.nvim",
	dependencies = {
		"echasnovski/mini.indentscope",
	},
	config = function()
		local function set_indent_colors()
			-- Ненавязчивые серые направляющие для светлой темы.
			vim.api.nvim_set_hl(0, "IblIndent", { fg = "#E1E4E8", bold = false })
			vim.api.nvim_set_hl(0, "IblScope", { fg = "#C8CDD2", bold = false })
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#C8CDD2", bold = false })
			vim.api.nvim_set_hl(0, "@ibl.indent.char.1", { fg = "#E1E4E8", nocombine = true })
			vim.api.nvim_set_hl(0, "@ibl.whitespace.char.1", { fg = "#E1E4E8", nocombine = true })
		end

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = set_indent_colors,
		})

		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.HIGHLIGHT_SETUP, set_indent_colors)

		require("ibl").setup({
			indent = {
				char = "│",
				tab_char = "│",
				highlight = "IblIndent",
			},
			scope = {
				enabled = true,
				show_start = true,
				show_end = true,
				highlight = "IblScope",
				priority = 500,
			},
			whitespace = {
				highlight = "IblIndent",
			},
		})

		-- Настройка mini.indentscope для анимации
		require("mini.indentscope").setup({
			draw = {
				animation = require("mini.indentscope").gen_animation.linear({ duration = 20 }),
				delay = 0,
			},
			options = {
				border = "top",
				indent_at_cursor = true,
				try_as_border = true,
			},
			symbol = "│",
		})

		-- Оба плагина создают свои highlight-группы при запуске,
		-- поэтому наши цвета должны применяться после их setup().
		set_indent_colors()
	end,
	---@module "ibl"
	---@type ibl.config
	opts = {},
}
-- подсказки по отсупам
