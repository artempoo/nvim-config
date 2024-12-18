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
		-- vim.api.nvim_set_keymap("n", "<S-TAB>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
		require("bufferline").setup({})
	end,
}
