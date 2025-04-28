return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			autotag = {
				enable = true,
			},
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"git_config",
				"gitattributes",
				"gitcommit",
				"graphql",
				"c",
				"cairo",
				"comment",
				"java",
				"make",
				"cmake",
				"nginx",
				"php",
				"python",
				"sql",
				"asm", -- Общий ассемблер (GAS, NASM)
				-- "nasm",     -- Если используете NASM (раскомментируйте)
				-- "masm",     -- Если используете MASM (раскомментируйте)
			},
			auto_install = true,
			sync_install = false,
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		})

		-- Автоматически устанавливаем filetype для .asm и .s файлов
		-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		-- 	pattern = { "*.asm", "*.s", "*.inc" },
		-- 	callback = function()
		-- 		vim.bo.filetype = "asm" -- или "nasm", если используете NASM
		-- 	end,
		-- })
	end,
}
