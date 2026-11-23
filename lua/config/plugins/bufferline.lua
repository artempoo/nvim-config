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

		local function setup_bufferline()
			local theme_highlights = require("config.theme").get("bufferline")
			if not theme_highlights then
				-- Bufferline groups are not cleared by every colorscheme, so remove
				-- cached colors before asking it to derive the active theme again.
				for _, group in ipairs(vim.fn.getcompletion("BufferLine", "highlight")) do
					vim.api.nvim_set_hl(0, group, {})
				end
			end

			require("bufferline").setup({
				options = {
					themable = false,
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
				highlights = theme_highlights,
			})
		end

		setup_bufferline()
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.schedule(setup_bufferline)
			end,
		})
	end,
}
