return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		vim.opt.termguicolors = true

		-- Маппинги для управления буферами
		vim.api.nvim_set_keymap("n", "<TAB>l", ":BufferLineCloseLeft<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<TAB>r", ":BufferLineCloseRight<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<TAB>q", ":bd<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<TAB>w", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })

		require("bufferline").setup({
			options = {
				close_icon = "", -- Отступы вокруг иконки
				show_close_icon = true,
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
					fg = "#fb4934", -- Красный крестик для активного буфера
					bg = "NONE",
					bold = true,
				},
				buffer_selected = {
					fg = "#fb4934", -- Красный текст для активного буфера
					bold = true,
				},
			},
		})

		-- Принудительно устанавливаем highlight для активного буфера
		-- Используем автокоманду для переопределения после загрузки цветовой схемы
		local function update_selected_highlight()
			-- Красный крестик для активного буфера
			vim.api.nvim_set_hl(0, "BufferLineCloseButtonSelected", {
				fg = "#fb4934",
				bg = "NONE",
				bold = true,
			})
			-- Красный текст для активного буфера
			vim.api.nvim_set_hl(0, "BufferLineBufferSelected", {
				fg = "#fb4934",
				bg = "NONE",
				bold = true,
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
