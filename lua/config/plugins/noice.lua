return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	config = function()
		-- Только базовая конфигурация noice
		require("noice").setup({
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
			},
			messages = {
				enabled = false, -- Отключаем messages
			},
			popupmenu = {
				enabled = true,
				backend = "nui",
			},
		})

		print("Noice loaded (basic config)")
	end,
} 