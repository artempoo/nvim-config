return {
	"neovim/nvim-lspconfig",
	-- Закрепляем стабильный тег, совместимый с Neovim 0.10
	tag = "v0.1.7",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- Конфигурация LSP

		local nvim_lsp = require("lspconfig")

		local on_attach = function(client, bufnr)
			-- защита: если bufnr не число, не вешаем автокоманды
			if type(bufnr) ~= "number" then
				return
			end

			-- Отладочная информация для PHP
			if client.name == "phpactor" then
				vim.notify("PhpActor LSP подключен для PHP (bufnr: " .. bufnr .. ")", vim.log.levels.INFO)
				vim.g.php_lsp_attached = true

				-- Фильтрация диагностики для WordPress через автокоманду
				vim.api.nvim_create_autocmd("DiagnosticChanged", {
					buffer = bufnr,
					callback = function()
						local diagnostics = vim.diagnostic.get(bufnr, { client_id = client.id })
						if #diagnostics == 0 then
							return
						end

						local wp_patterns = {
							"wp_",
							"get_",
							"the_",
							"is_",
							"has_",
							"add_",
							"remove_",
							"update_",
							"register_",
							"unregister_",
							"do_",
							"apply_",
							"WP_",
							"ABSPATH",
						}

						local filtered = {}
						for _, diag in ipairs(diagnostics) do
							local should_filter = false
							if diag.message then
								local msg_lower = diag.message:lower()
								-- Фильтруем ошибки о неопределённых функциях/константах WordPress
								if msg_lower:match("undefined") then
									for _, pattern in ipairs(wp_patterns) do
										if diag.message:match(pattern) then
											should_filter = true
											break
										end
									end
								end
							end
							if not should_filter then
								table.insert(filtered, diag)
							end
						end

						-- Обновляем диагностику только если были отфильтрованы ошибки
						if #filtered < #diagnostics then
							vim.diagnostic.set(client.id, bufnr, filtered)
						end
					end,
				})
			end

			-- Форматирование по сохранению через LSP: только для C/.h по явному запросу
			-- Остальные форматы отключены, чтобы не трогать Makefile, .clang-format и т.п.
			if client.server_capabilities.documentFormattingProvider then
				local ft = vim.bo[bufnr].filetype
				if ft == "c" or ft == "h" then
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = vim.api.nvim_create_augroup("FormatCOnly", { clear = false }),
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end
			end
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Настройка TypeScript LSP напрямую
		nvim_lsp.tsserver.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		-- Настройка других LSP серверов
		nvim_lsp.clangd.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "c", "h" },
			-- cmd = { "clangd", "--background-index" }, -- опционально
		})

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

		nvim_lsp.gopls.setup({
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

		-- Настройка PHP LSP через PhpActor
		-- Для лучшей поддержки WordPress рекомендуется установить WordPress stubs:
		-- composer require --dev php-stubs/wordpress-stubs
		-- Это поможет PhpActor понимать WordPress функции и константы
		nvim_lsp.phpactor.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "php" },
			cmd = { "phpactor", "language-server" },
			root_dir = function(fname)
				-- Сначала ищем composer.json, .git или composer.lock
				local root = require("lspconfig.util").root_pattern("composer.json", ".git", "composer.lock")(fname)
				if root then
					return root
				end
				-- Для WordPress тем: ищем style.css или functions.php в корне темы
				local wp_root = require("lspconfig.util").root_pattern("style.css", "functions.php")(fname)
				if wp_root then
					return wp_root
				end
				-- Если не найдено, используем директорию файла как корень
				local dir = vim.fs.dirname(fname)
				if dir and dir ~= "" then
					return dir
				end
				-- В крайнем случае - текущая рабочая директория
				return vim.fn.getcwd()
			end,
			init_options = {
				["language_server_phpstan.enabled"] = false,
				["language_server_psalm.enabled"] = false,
			},
			settings = {
				phpactor = {
					-- Настройки для работы с WordPress
					completion = {
						enabled = true,
					},
					-- Игнорируем некоторые ошибки, характерные для WordPress
					diagnostics = {
						enabled = true,
					},
				},
			},
		})

		-- Настройка Rust LSP
		nvim_lsp.rust_analyzer.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					checkOnSave = {
						command = "clippy",
					},
					rustfmt = {
						enableRangeFormatting = true,
					},
				},
			},
		})

		-- Настройка Zig LSP
		nvim_lsp.zls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		-- nvim_lsp.mesonlsp.setup({
		-- 	on_attach = on_attach,
		-- 	capabilities = capabilities,
		-- })
	end,
}

-- https://www.youtube.com/watch?v=4PzSNN45tcA&t=134s
