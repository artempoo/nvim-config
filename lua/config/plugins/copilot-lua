return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			-- Включаем Copilot
			enabled = true,
			
			-- Настройки предложений
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<Tab>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			
			-- Настройки панели
			panel = {
				enabled = true,
				auto_refresh = true,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
					open = "<M-CR>",
				},
			},
			
			-- Настройки файлов
			filetypes = {
				markdown = true,
				help = true,
				gitcommit = true,
				gitrebase = true,
				hgcommit = true,
				svn = true,
				cvs = true,
				["."] = true,
			},
			
			-- Настройки сервера
			server_opts_overrides = {
				trace = "verbose",
				settings = {
					advanced = {
						listCount = 10,
						inlineSuggestCount = 3,
					},
				},
			},
		})
		
		print("Copilot.lua loaded!")
	end,
} 