return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			-- Использовать предпросмотр для файлов
			preview = {
				max_width = 0.9,
				min_width = { 40, 0.4 },
				width = nil,
				border = "rounded",
				show_title = true,
			},
			-- Автоматически сохранять изменения при выходе
			prompt_save_on_select_new_entry = true,
			-- Показывать скрытые файлы
			view_options = {
				show_hidden = true,
			},
			-- Настройки для лучшего отображения
			columns = { "icon", "permissions", "size", "mtime" },
			-- Использовать float окно
			float = {
				padding = 0,
				max_width = 80,
				max_height = 40,
				border = "rounded",
				win_options = {
					winblend = 0,
				},
			},
		})

		-- Маппинги для oil.nvim
		vim.keymap.set("n", "<leader>o", "<cmd>Oil<cr>", { desc = "Open Oil (file explorer)" })
	end,
}
