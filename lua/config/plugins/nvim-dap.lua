return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Настройка DAP UI
			dapui.setup({
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						position = "bottom",
						size = 10,
					},
				},
			})

			-- Автоматическое открытие/закрытие UI
			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			-- Настройка codelldb
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.expand("~/.local/share/codelldb/extension/adapter/codelldb"),
					args = { "--port", "${port}" },
				},
			}

			-- Базовые конфигурации
			dap.configurations.cpp = {
				-- Конфигурация по умолчанию (без аргументов)
				{
					name = "Launch (no args)",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
				-- Конфигурация с фиксированными аргументами (пример: ./main -v text.txt)
				{
					name = "Launch (-v text.txt)",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = { "-v", "text.txt" },
				},
				-- Конфигурация с интерактивным вводом аргументов
				{
					name = "Launch (custom args)",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = function()
						local input = vim.fn.input("Program arguments (space separated): ")
						return vim.split(input, " ")
					end,
				},
			}
			dap.configurations.c = dap.configurations.cpp

			-- Горячие клавиши
			vim.keymap.set("n", "<F5>", function()
				-- Показываем меню выбора конфигурации
				require("dap").continue()
			end)
			vim.keymap.set("n", "<F6>", function()
				-- Запуск с последней конфигурацией
				local last_config = require("dap").configurations[vim.bo.filetype][1]
				require("dap").run(last_config)
			end)
			vim.keymap.set("n", "<F10>", function()
				dap.step_over()
			end)
			vim.keymap.set("n", "<F11>", function()
				dap.step_into()
			end)
			vim.keymap.set("n", "<F12>", function()
				dap.step_out()
			end)
			vim.keymap.set("n", "<Leader>b", function()
				dap.toggle_breakpoint()
			end)
			vim.keymap.set("n", "<Leader>B", function()
				dap.set_breakpoint(vim.fn.input("Condition: "))
			end)
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		config = function()
			-- Инициализация будет выполнена в основном конфиге nvim-dap
		end,
	},
}
