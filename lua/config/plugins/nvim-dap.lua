return {
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local mason_dap = require("mason-nvim-dap")
			local dap = require("dap")
			local dapui = require("dapui")
			local dap_virtual_text = require("nvim-dap-virtual-text")

			dap_virtual_text.setup()

			mason_dap.setup({
				ensure_installed = { "codelldb", "cppdbg" },
				automatic_installation = true,
				handlers = {
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})

			-- Исполняемый файл: a.out или main в cwd — без запроса; иначе спросить путь
			local function get_program()
				local cwd = vim.fn.getcwd()
				local candidates = { cwd .. "/a.out", cwd .. "/main" }
				-- имя без расширения из текущего файла (main.c -> main)
				local f = vim.api.nvim_buf_get_name(0)
				if f and (f:match("%.c$") or f:match("%.cpp$")) then
					local base = vim.fn.fnamemodify(f, ":t:r")
					if base and base ~= "" then
						table.insert(candidates, 2, cwd .. "/" .. base)
					end
				end
				for _, path in ipairs(candidates) do
					if vim.fn.filereadable(path) == 1 then
						return path
					end
				end
				return vim.fn.input("Path to executable: ", cwd .. "/", "file")
			end
			local configurations = {
				{
					name = "Launch (CodeLLDB)",
					type = "codelldb",
					request = "launch",
					program = get_program,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
				{
					name = "Launch (cppdbg)",
					type = "cppdbg",
					request = "launch",
					program = get_program,
					cwd = "${workspaceFolder}",
					stopAtEntry = false,
					MIMode = "lldb",
				},
				{
					name = "Attach to lldbserver :1234",
					type = "cppdbg",
					request = "launch",
					MIMode = "lldb",
					miDebuggerServerAddress = "localhost:1234",
					miDebuggerPath = "/usr/bin/lldb",
					cwd = "${workspaceFolder}",
					program = get_program,
				},
			}
			dap.configurations.c = configurations
			dap.configurations.cpp = configurations

			-- Конфиг для текущего буфера: c/cpp или оба
			local function get_configs()
				local ft = vim.bo.filetype
				local cfg = dap.configurations[ft]
				if cfg and #cfg > 0 then
					return cfg
				end
				-- файл не c/cpp — пробуем cpp и c
				cfg = dap.configurations.cpp or dap.configurations.c
				return cfg or {}
			end

			-- DAP UI (твой расклад: слева 4 панели, снизу REPL + консоль)
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

			vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

			dap.listeners.before.attach["dapui_config"] = dapui.open
			dap.listeners.before.launch["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			-- Не закрывать при выходе — успеешь прочитать сообщение. Закрыть: <Leader>dq
			-- dap.listeners.before.event_exited["dapui_config"] = dapui.close

			-- Твои привязки клавиш
			vim.keymap.set("n", "<F5>", function()
				if dap.session() then
					dap.continue()
				else
					local configs = get_configs()
					if #configs > 0 then
						dap.run(configs[1])
					else
						vim.notify("DAP: нет конфигурации для " .. vim.bo.filetype .. ". Открой .c/.cpp или установи cppdbg: MasonInstall cppdbg", vim.log.levels.WARN)
					end
				end
			end)
			vim.keymap.set("n", "<F6>", function()
				local configs = get_configs()
				if #configs > 0 then
					dap.run(configs[1])
				else
					vim.notify("DAP: нет конфигурации. Установи адаптер: :MasonInstall cppdbg", vim.log.levels.WARN)
				end
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
			-- Инициализация в основном конфиге nvim-dap
		end,
	},
}
