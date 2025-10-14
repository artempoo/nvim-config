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
			lsp = {
				progress = { enabled = false }, -- Глушим LSP progress
			},
			popupmenu = {
				enabled = true,
				backend = "nui",
			},
			routes = {
				-- Фильтруем любые LSP прогресс-сообщения
				{ filter = { event = "lsp", kind = "progress" }, opts = { skip = true } },
				-- Фильтруем шумные уведомления
				{ filter = { any = {
					{ find = "validate document" },
					{ find = "publish diagnostic" },
				} }, opts = { skip = true } },
			},
		})

		print("Noice loaded (basic config)")
	end,
} 