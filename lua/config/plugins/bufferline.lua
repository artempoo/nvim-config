return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		vim.opt.termguicolors = true

		-- Маппинги для управления буферами
		vim.keymap.set("n", "<TAB>l", "<cmd>BufferLineCloseLeft<CR>", { silent = true, desc = "Close buffers to the left" })
		vim.keymap.set("n", "<TAB>r", "<cmd>BufferLineCloseRight<CR>", { silent = true, desc = "Close buffers to the right" })
		vim.keymap.set("n", "<TAB>q", "<cmd>bd<CR>", { silent = true, desc = "Close current buffer" })
		vim.keymap.set("n", "<TAB>e", "<cmd>BufferLineCycleNext<CR>", { silent = true, desc = "Next buffer" })
		vim.keymap.set("n", "<TAB>w", "<cmd>BufferLineCyclePrev<CR>", { silent = true, desc = "Previous buffer" })

		require("bufferline").setup({
			options = {
				close_icon = "", -- Отступы вокруг иконки
				show_close_icon = true,
				indicator = {
					icon = "▎",
					style = "icon",
				},
				-- Доп. отступы для буферов:
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						padding = 8, -- Косвенно влияет на отступы
					},
				},
			},
			highlights = {
				close_button = {
					fg = "#e0def4",
					bg = "NONE",
					bold = true,
				},
				close_button_visible = {
					fg = "#eb6f92",
					bg = "NONE",
					bold = true,
				},
				close_button_selected = {
					fg = "#E49B5D",
					bg = "#403A36",
					bold = true,
				},
				buffer_selected = {
					fg = "#ECE1D7",
					bg = "#403A36",
					bold = true,
				},
				indicator_selected = {
					fg = "#E49B5D",
					bg = "#403A36",
				},
				separator_selected = {
					fg = "#403A36",
					bg = "#403A36",
				},
			},
		})

		-- Принудительно устанавливаем highlight для активного буфера
		-- Используем автокоманду для переопределения после загрузки цветовой схемы
		local function update_selected_highlight()
			vim.api.nvim_set_hl(0, "BufferLineCloseButtonSelected", {
				fg = "#E49B5D",
				bg = "#403A36",
				bold = true,
			})
			vim.api.nvim_set_hl(0, "BufferLineBufferSelected", {
				fg = "#ECE1D7",
				bg = "#403A36",
				bold = true,
			})
			vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", {
				fg = "#E49B5D",
				bg = "#403A36",
			})
			vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", {
				fg = "#403A36",
				bg = "#403A36",
			})
		end

		-- Применяем сразу и после загрузки цветовой схемы
		vim.defer_fn(update_selected_highlight, 100)
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				vim.defer_fn(update_selected_highlight, 100)
			end,
		})
	end,
}
