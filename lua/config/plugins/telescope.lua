return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-file-browser.nvim",
			dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		},
	},
	config = function()
		require("telescope").setup({
			extensions = {
				file_browser = {
					theme = "dropdown",
					-- Заменяем netrw на telescope file browser
					hijack_netrw = true,
					-- Показывать скрытые файлы
					hidden = true,
					-- Группировать файлы и папки
					grouped = true,
					-- Сортировка: сначала папки, потом файлы
					files = true,
					-- Добавляем иконки
					respect_gitignore = false,
					-- Не показывать родительскую директорию в списке
					no_ignore = false,
					mappings = {
						["i"] = {
							-- Навигация в режиме вставки
							["<C-l>"] = require("telescope.actions").select_default,
							["<C-h>"] = require("telescope.actions").close,
						},
						["n"] = {
							-- Навигация в нормальном режиме
							["l"] = require("telescope.actions").select_default,
							["h"] = require("telescope.actions").close,
						},
					},
				},
			},
		})

		-- Загружаем расширение file_browser
		require("telescope").load_extension("file_browser")

		vim.g.mapleader = " "
		-- set keymaps
		local keymap = vim.keymap
		local builtin = require("telescope.builtin")

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find string in cwd" })
		-- Файловый браузер (explorer) - красивый сайдбар с навигацией
		keymap.set("n", "<leader>fe", "<cmd>Telescope file_browser<cr>", { desc = "File browser (explorer)" })
		keymap.set("n", "<leader>fE", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", { desc = "File browser (current dir)" })
		-- keymap.set("n", "<leader>fb", function()
		-- 	require("telescope.builtin").buffers()
		-- end, { desc = "Find buffers" })
		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
		-- keymap.set("n", "<leader>fs", "<cmd>Telescope git<cr>", { desc = "Find string under cursor in cwd" })
		-- keymap.set("n", "<leader>fc", "<cmd>Telescope git commits<cr>", { desc = "Find todos" })
		-- keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		keymap.set("n", "<leader>gr", builtin.lsp_references, { noremap = true, silent = true })
		keymap.set("n", "<leader>gd", builtin.lsp_definitions, { noremap = true, silent = true })
	end,
}
