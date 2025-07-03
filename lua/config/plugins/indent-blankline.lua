return {
	"lukas-reineke/indent-blankline.nvim",
	dependencies = {
		"echasnovski/mini.indentscope",
	},
	config = function()
		-- Создаем кастомные highlight группы для анимации
		vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4252", bold = true })
		vim.api.nvim_set_hl(0, "IblScope", { fg = "#ffffff", bold = true, sp = "#ffffff" })

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
				highlight = { "Whitespace", "NonText" },
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
	end,
	---@module "ibl"
	---@type ibl.config
	opts = {},
}
-- подсказки по отсупам
