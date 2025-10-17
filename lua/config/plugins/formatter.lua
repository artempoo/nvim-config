return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},
			-- Включаем автоформатирование для разрешённых ft. Спец-файлы исключаем
			format_on_save = function(bufnr)
				local name = vim.api.nvim_buf_get_name(bufnr)
				local ft = vim.bo[bufnr].filetype
				-- Не трогаем .clang-format, даже если это yaml
				if name:match("/%.clang%-format$") then
					return nil
				end
				-- Белый список форматов с автоформатированием
				local allowed = {
					javascript = true,
					typescript = true,
					javascriptreact = true,
					typescriptreact = true,
					css = true,
					html = true,
					json = true,
					yaml = true,
					markdown = true,
					lua = true,
					python = true,
					c = true,
					h = true,
					cpp = true,
				}
				if not allowed[ft] then
					return nil
				end
				-- Для разрешённых используем только внешние форматтеры (без LSP fallback)
				return { lsp_fallback = false, async = false, timeout_ms = 1000 }
			end,
			formatters = {
				["clang-format"] = {
					prepend_args = { "--style=file" },
				},
			},
		})

		-- Удалили отдельную автокоманду: теперь управляем через format_on_save (с белым списком)

		vim.keymap.set({ "n", "v" }, "<leader>cL", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
