return {
	desc = "Snacks File Explorer",
	"folke/snacks.nvim",
	opts = {
		explorer = {
			-- Настройки прозрачности
			win = {
				winblend = 0, -- Прозрачность окна (0 = непрозрачно, 100 = полностью прозрачно)
			},
		},
	},
	keys = {
		{
			"<leader>fe",
			function()
				-- Получаем root директорию проекта (ищем .git, composer.json и т.д.)
				local root =
					require("lspconfig.util").root_pattern(".git", "composer.json", "package.json", ".gitignore")(
						vim.fn.expand("%:p")
					)
				if not root then
					root = vim.fn.getcwd()
				end
				require("snacks").explorer({ cwd = root })
			end,
			desc = "Explorer Snacks (root dir)",
		},
		{
			"<leader>fE",
			function()
				require("snacks").explorer()
			end,
			desc = "Explorer Snacks (cwd)",
		},
		{ "<leader>e", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
		{ "<leader>E", "<leader>fE", desc = "Explorer Snacks (cwd)", remap = true },
	},
	config = function(_, opts)
		require("snacks").setup(opts)

		-- Настройка прозрачности для explorer окон
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "snacks_explorer",
			callback = function()
				vim.wo.winblend = 0 -- Убираем прозрачность
				-- Убираем фон, если он установлен
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
				vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })

				-- Навигация: переключение между полем поиска и списком файлов
				-- Попробуем разные варианты навигации
				local buf = vim.api.nvim_get_current_buf()

				-- Переключение на список файлов (из поля поиска)
				vim.keymap.set("i", "<C-j>", function()
					-- Переключаемся на окно со списком файлов
					local wins = vim.api.nvim_list_wins()
					for _, win in ipairs(wins) do
						local bufnr = vim.api.nvim_win_get_buf(win)
						local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
						if ft == "snacks_explorer" then
							vim.api.nvim_set_current_win(win)
							-- Пытаемся переключиться в нормальный режим для навигации по списку
							vim.cmd("stopinsert")
							return
						end
					end
				end, { buffer = buf, desc = "Switch to file list" })

				-- Переключение на поле поиска (из списка файлов)
				vim.keymap.set("n", "<C-k>", function()
					-- Переключаемся на окно с полем поиска
					local wins = vim.api.nvim_list_wins()
					for _, win in ipairs(wins) do
						local bufnr = vim.api.nvim_win_get_buf(win)
						local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
						if ft == "snacks_explorer" then
							vim.api.nvim_set_current_win(win)
							vim.cmd("startinsert")
							return
						end
					end
				end, { buffer = buf, desc = "Switch to search field" })
			end,
		})
	end,
}
