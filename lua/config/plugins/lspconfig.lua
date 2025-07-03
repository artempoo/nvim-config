return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- Отключаем deprecated предупреждения
		vim.deprecate = function() end
		
		-- Отключаем все предупреждения lspconfig
		local original_notify = vim.notify
		vim.notify = function(msg, level, opts)
			if string.find(msg, "tsserver is deprecated") or string.find(msg, "Feature will be removed") then
				return
			end
			return original_notify(msg, level, opts)
		end
		
		local nvim_lsp = require("lspconfig")

		local on_attach = function(client, bufnr)
			-- format on save
			if client.server_capabilities.documentFormattingProvider then
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = vim.api.nvim_create_augroup("Format", { clear = true }),
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format()
					end,
				})
			end
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Настройка TypeScript LSP напрямую
		nvim_lsp.tsserver.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		-- Настройка других LSP серверов
		nvim_lsp.emmet_ls.setup({
			capabilities = capabilities,
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
				"jsx",
				"tsx",
			},
		})

		nvim_lsp.cssls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		nvim_lsp.html.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		nvim_lsp.jsonls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		nvim_lsp.eslint.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		nvim_lsp.pyright.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
}

-- https://www.youtube.com/watch?v=4PzSNN45tcA&t=134s
