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

		-- Java через nvim-jdtls (инициализируем в автокоманде FileType)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "java" },
			callback = function()
				local ok, jdtls = pcall(require, "jdtls")
				if not ok then
					return
				end

				local project_root = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
				if not project_root or project_root == "" then
					return
				end

				local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(project_root, ":p:h:t")

				local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
				local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
				-- Выбор конфигурации по ОС
				local sys = vim.loop.os_uname().sysname
				local config_dir = jdtls_path .. (sys == "Darwin" and "/config_mac" or (sys == "Windows_NT" and "/config_win" or "/config_linux"))

				if launcher == "" then
					vim.notify("jdtls launcher not found. Run :Mason and install jdtls", vim.log.levels.WARN)
					return
				end

				local cmd = {
					"java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-Xms1g",
				}

				-- Подключаем lombok, если найден
				local lombok_path = jdtls_path .. "/lombok/lombok.jar"
				if vim.fn.filereadable(lombok_path) == 1 then
					table.insert(cmd, "-javaagent:" .. lombok_path)
				end

				vim.list_extend(cmd, {
					"-jar",
					launcher,
					"-configuration",
					config_dir,
					"-data",
					workspace_dir,
				})

				-- Вернём snippetSupport в capabilities (нужен для полноценных подсказок),
				-- но автотрингер мы отключаем на стороне cmp для java.
				local jdtls_cap = vim.tbl_deep_extend("force", {}, capabilities)
				local jdtls_cfg = {
					cmd = cmd,
					root_dir = project_root,
					settings = {
						java = {
							configuration = { updateBuildConfiguration = "disabled" },
							autobuild = { enabled = false },
							signatureHelp = { enabled = true },
							completion = { favoriteStaticMembers = {} },
							runtimes = {},
						},
					},
					capabilities = jdtls_cap,
					init_options = {
						bundles = {},
					},
				}

				jdtls.start_or_attach(jdtls_cfg)
			end,
		})

	end,
}

-- https://www.youtube.com/watch?v=4PzSNN45tcA&t=134s
