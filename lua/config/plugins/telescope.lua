return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("telescope").setup()

		vim.g.mapleader = " "
		-- set keymaps
		local keymap = vim.keymap
		local builtin = require("telescope.builtin")

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find string in cwd" })
		-- keymap.set("n", "<leader>fs", "<cmd>Telescope git<cr>", { desc = "Find string under cursor in cwd" })
		-- keymap.set("n", "<leader>fc", "<cmd>Telescope git commits<cr>", { desc = "Find todos" })
		-- keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		keymap.set("n", "<leader>gr", builtin.lsp_references, { noremap = true, silent = true })
		keymap.set("n", "<leader>gd", builtin.lsp_definitions, { noremap = true, silent = true })
	end,
}
