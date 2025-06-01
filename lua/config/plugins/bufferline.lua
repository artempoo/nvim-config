return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		vim.opt.termguicolors = true
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
					-- bg = "#eb6f92",
					bold = true,
				},
				close_button_visible = {
					fg = "#eb6f92",
					bg = "NONE",
					bold = true,
				},
				close_button_selected = {
					fg = "#eb6f92",
					bg = "NONE",
					bold = true,
				},
			},
		})
	end,
}
