return {
	"mfussenegger/nvim-jdtls",
	dependencies = {
		"nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
	},
	ft = { "java" },
	config = function()
		local jdtls = require("jdtls")
		local cmp_lsp = require("cmp_nvim_lsp")

		-- Настройка для Java файлов
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "java" },
			callback = function()
				-- Находим корень проекта
				local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
				local root_dir = require("jdtls.setup").find_root(root_markers)
				if not root_dir then
					return
				end

				-- Путь к jdtls (установлен через Mason)
				local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
				
				-- Находим launcher jar
				local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
				if launcher_jar == "" then
					vim.notify("jdtls не найден. Установите через :Mason", vim.log.levels.WARN)
					return
				end

				-- Определяем конфигурацию по ОС
				local os_name = vim.loop.os_uname().sysname
				local config_name = "config_linux"
				if os_name == "Darwin" then
					config_name = "config_mac"
				elseif os_name == "Windows_NT" then
					config_name = "config_win"
				end
				local config_dir = jdtls_path .. "/" .. config_name

				-- Workspace директория
				local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
				local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

				-- Команда для запуска jdtls
				local cmd = {
					"java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-Xmx1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
				}

				-- Поддержка Lombok (если установлен)
				local lombok_path = jdtls_path .. "/lombok.jar"
				if vim.fn.filereadable(lombok_path) == 1 then
					table.insert(cmd, "-javaagent:" .. lombok_path)
				end

				-- Добавляем jar и параметры конфигурации
				table.insert(cmd, "-jar")
				table.insert(cmd, launcher_jar)
				table.insert(cmd, "-configuration")
				table.insert(cmd, config_dir)
				table.insert(cmd, "-data")
				table.insert(cmd, workspace_dir)

				-- Capabilities для LSP (включаем поддержку snippets для автодополнения)
				local capabilities = vim.tbl_deep_extend("force", {}, cmp_lsp.default_capabilities(), {
					textDocument = {
						completion = {
							completionItem = {
								snippetSupport = true,
							},
						},
					},
				})

				-- Конфигурация jdtls
				local config = {
					cmd = cmd,
					root_dir = root_dir,
					settings = {
						java = {
							eclipse = {
								downloadSources = true,
							},
							maven = {
								downloadSources = true,
							},
							implementationsCodeLens = {
								enabled = true,
							},
							referencesCodeLens = {
								enabled = true,
							},
							references = {
								includeDecompiledSources = true,
							},
							configuration = {
								updateBuildConfiguration = "interactive",
							},
							completion = {
								favoriteStaticMembers = {
									"org.junit.Assert.*",
									"org.junit.Assume.*",
									"org.junit.jupiter.api.Assertions.*",
									"org.junit.jupiter.api.Assumptions.*",
									"org.junit.jupiter.api.DynamicContainer.*",
									"org.junit.jupiter.api.DynamicTest.*",
									"org.mockito.Mockito.*",
									"org.mockito.ArgumentMatchers.*",
									"org.mockito.Answers.*",
								},
							},
							sources = {
								organizeImports = {
									starThreshold = 9999,
									staticStarThreshold = 9999,
								},
							},
							codeGeneration = {
								toString = {
									template = "${object.className} [${member.name()}=${member.value}, ${otherMembers}]",
								},
								useBlocks = true,
							},
						},
					},
					capabilities = capabilities,
					init_options = {
						bundles = {},
					},
					on_attach = function(client, bufnr)
						-- Включаем форматирование по сохранению
						if client.server_capabilities.documentFormattingProvider then
							vim.api.nvim_create_autocmd("BufWritePre", {
								buffer = bufnr,
								callback = function()
									vim.lsp.buf.format({ bufnr = bufnr })
								end,
							})
						end
					end,
				}

				-- Запускаем jdtls
				jdtls.start_or_attach(config)
			end,
		})
	end,
}
