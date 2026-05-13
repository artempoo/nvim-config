-- Файловый браузер (explorer) - используем Snacks Explorer (как в LazyVim)
-- Маппинги настроены в lua/config/plugins/snacks-explorer.lua
-- vim.keymap.set("n", "<leader>sp", ":vsplit<CR>")
-- vim.keymap.set("n", "<leader>on", ":only<CR>")
vim.keymap.set("n", "<leader>fr", ":%s/")
vim.keymap.set("n", "<leader>sl", ":LiveServerStart<CR>")
vim.keymap.set("n", "<leader>sls", ":LiveServerStop<CR>")

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>t", ":belowright terminal zsh<CR>")

-- Normal mode (одна строка)
-- vim.keymap.set("n", "m,", ":m .+1<CR>", { silent = true, desc = "Move line down" })
-- vim.keymap.set("n", "m.", ":m .-2<CR>", { silent = true, desc = "Move line up" })
vim.keymap.set("n", "m,", ":<C-u>execute 'm .+' . v:count1<CR>==", { silent = true })
vim.keymap.set("n", "m.", ":<C-u>execute 'm .-' . (v:count1 + 1)<CR>==", { silent = true })

-- Visual mode (выделение)
vim.keymap.set("v", "m,", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
vim.keymap.set("v", "m.", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

vim.keymap.set("n", "P", "P`]", { silent = true, desc = "Paste & jump to end" })

-- vim.keymap.set("n", "<leader>sg", ":split<CR>")
-- vim.keymap.set("n", "<leader>sv", ":vsplit<CR>")
vim.keymap.set("n", "<leader>te", ":tabedit<CR>")

vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sl", "<C-w>l")

vim.keymap.set("n", "<TAB>t", ":tabnew:tabedit<CR>")

vim.keymap.set("v", "<leader>t", "y:lua run_translate()<CR>")

function run_translate()
	local text = vim.fn.getreg('"')
	local escaped = vim.fn.shellescape(text)
	local result = vim.fn.system("trans -b " .. escaped)
	print(result)
end

-- di( удалить аргументы между (...)
-- vap - выделить блок с пробелом
-- vap - выделить блок без пробела
-- yap - копировать блок с пробелом
-- yip - копировать блок без пробела

local function move_line(direction)
	local step = direction == "down" and "+1" or "-2"
	vim.cmd("m ." .. step)
end

-- Закрыть DAP полностью: остановить отладчик, убрать все окна, оставить одно с кодом
vim.keymap.set("n", "<Leader>dq", function()
	pcall(require("dap").terminate)
	pcall(require("dapui").close)

	local function is_dap_buf(bufnr)
		local name = vim.api.nvim_buf_get_name(bufnr)
		return name and (name:match("DAP") or name:match("dap"))
	end

	-- Переключиться на первое окно с не-DAP буфером
	local tab = vim.api.nvim_get_current_tabpage()
	local wins = vim.api.nvim_tabpage_list_wins(tab)
	local good_win
	for _, w in ipairs(wins) do
		local b = vim.api.nvim_win_get_buf(w)
		if not is_dap_buf(b) then
			good_win = w
			break
		end
	end
	if good_win and vim.api.nvim_get_current_win() ~= good_win then
		vim.api.nvim_set_current_win(good_win)
	end

	-- Закрыть все окна с DAP-буферами
	for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
		if vim.api.nvim_win_is_valid(w) and is_dap_buf(vim.api.nvim_win_get_buf(w)) then
			pcall(vim.api.nvim_win_close, w, true)
		end
	end

	-- Удалить DAP-буферы и оставить одно окно
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if is_dap_buf(buf) then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end
	vim.cmd("only")
end, { desc = "[D]AP [Q]uit: close all debugger UI" })

-- Прервать отладку (аналог иконки №7 в REPL)
vim.keymap.set("n", "<Leader>di", function()
	require("dap").disconnect() -- Остановить отладчик + закрыть сессию
	require("dapui").close() -- Закрыть интерфейс
end, { desc = "[D]ebug [I]nterrupt" })

-- LSP маппинги
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Проверка статуса LSP
vim.keymap.set("n", "<leader>ls", function()
	local clients = vim.lsp.get_active_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("LSP серверы не запущены для этого буфера", vim.log.levels.WARN)
	else
		local msg = "Активные LSP серверы:\n"
		for _, client in ipairs(clients) do
			msg = msg .. "- " .. client.name .. "\n"
		end
		vim.notify(msg, vim.log.levels.INFO)
	end
end, { desc = "Show LSP status" })

-- Детальная диагностика LSP для PHP
vim.keymap.set("n", "<leader>ld", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype
	local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

	local msg = "=== Диагностика LSP ===\n"
	msg = msg .. "Filetype: " .. (ft or "не установлен") .. "\n"
	msg = msg .. "Буфер: " .. bufnr .. "\n"
	msg = msg .. "Файл: " .. (vim.api.nvim_buf_get_name(bufnr) or "неизвестен") .. "\n\n"

	if #clients == 0 then
		msg = msg .. "❌ LSP клиенты не подключены к буферу\n"
		msg = msg .. "\nПроверьте:\n"
		msg = msg .. "1. Установлен ли phpactor: which phpactor\n"
		msg = msg .. "2. Правильно ли установлен filetype: :set filetype?\n"
		msg = msg .. "3. Есть ли composer.json или .git в корне проекта\n"
	else
		msg = msg .. "✅ Подключенные LSP клиенты:\n"
		for _, client in ipairs(clients) do
			msg = msg .. "\n--- " .. client.name .. " ---\n"
			msg = msg .. "ID: " .. client.id .. "\n"
			msg = msg .. "Root: " .. (client.config.root_dir or "не указан") .. "\n"
			msg = msg .. "Capabilities:\n"
			if client.server_capabilities.completionProvider then
				msg = msg .. "  ✅ Автодополнение: включено\n"
			else
				msg = msg .. "  ❌ Автодополнение: отключено\n"
			end
			if client.server_capabilities.hoverProvider then
				msg = msg .. "  ✅ Hover: включено\n"
			end
			if client.server_capabilities.definitionProvider then
				msg = msg .. "  ✅ Определения: включено\n"
			end
		end
	end

	-- Проверка cmp
	local cmp_ok, cmp = pcall(require, "cmp")
	if cmp_ok then
		msg = msg .. "\n--- CMP (автодополнение) ---\n"
		msg = msg .. "✅ CMP загружен\n"
		local sources = cmp.get_config().sources
		if sources then
			msg = msg .. "Источники автодополнения:\n"
			for _, source_group in ipairs(sources) do
				if type(source_group) == "table" then
					for _, source in ipairs(source_group) do
						msg = msg .. "  - " .. (source.name or "unknown") .. "\n"
					end
				end
			end
		end
	else
		msg = msg .. "\n❌ CMP не загружен\n"
	end

	vim.notify(msg, vim.log.levels.INFO)
	print(msg)
end, { desc = "LSP detailed diagnostics" })

-- Автодополнение
vim.keymap.set("i", "<C-Space>", "<cmd>lua require('cmp').complete()<CR>", { desc = "Trigger completion" })

-- Тест автодополнения через LSP
vim.keymap.set("n", "<leader>lt", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

	if #clients == 0 then
		vim.notify(
			"❌ Нет подключенных LSP клиентов. Запустите :LspInfo для деталей",
			vim.log.levels.ERROR
		)
		return
	end

	-- Пробуем вызвать автодополнение программно
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]

	vim.notify(
		"Тестирую автодополнение...\nПозиция: строка "
			.. row
			.. ", колонка "
			.. (col + 1)
			.. "\nТекст: "
			.. (line or ""),
		vim.log.levels.INFO
	)

	-- Пробуем вызвать completion через LSP
	for _, client in ipairs(clients) do
		if client.server_capabilities.completionProvider then
			vim.lsp.buf_request(bufnr, "textDocument/completion", {
				textDocument = { uri = vim.uri_from_bufnr(bufnr) },
				position = { line = row - 1, character = col },
			}, function(err, result, ctx)
				if err then
					vim.notify(
						"❌ Ошибка запроса автодополнения: " .. tostring(err),
						vim.log.levels.ERROR
					)
				elseif result and #result > 0 then
					vim.notify(
						"✅ Автодополнение работает! Найдено "
							.. #result
							.. " предложений",
						vim.log.levels.INFO
					)
				else
					vim.notify(
						"⚠️ Автодополнение вернуло пустой результат",
						vim.log.levels.WARN
					)
				end
			end)
		end
	end
end, { desc = "Test LSP completion" })

-- Поиск документации в браузере
vim.keymap.set("n", "<leader>ts", function()
	local word = vim.fn.expand("<cword>")
	local url = "https://learn.javascript.ru/search?query=" .. word
	vim.fn.system("open '" .. url .. "'")
end, { desc = "Search learn.javascript.ru documentation" })

-- Java build: автоопределение Gradle/Maven/javac и запуск :make с quickfix
local function java_build()
	-- стартовая директория поиска
	local start_dir = vim.fn.expand("%:p:h")
	if start_dir == "" then
		start_dir = vim.loop.cwd()
	end

	-- находим корень Maven/Gradle вверх по дереву
	local function find_up(names)
		local found = vim.fs.find(names, { upward = true, path = start_dir })
		if #found > 0 then
			return vim.fs.dirname(found[1]), found[1]
		end
		return nil, nil
	end

	local gradle_root, gradle_file = find_up({ "gradlew", "build.gradle.kts", "build.gradle" })
	local maven_root, pom_file = find_up({ "mvnw", "pom.xml" })

	if gradle_root then
		local gradlew = vim.loop.fs_stat(gradle_root .. "/gradlew") and (gradle_root .. "/gradlew") or "gradle"
		local cmd = string.format([[bash -lc 'cd "%s" && %s build']], gradle_root, gradlew)
		vim.notify("Gradle build @ " .. gradle_root .. "\n" .. cmd)
		vim.o.makeprg = cmd
		-- errorformat: gradle обычно проксирует javac
		vim.o.errorformat = table.concat({
			"%E%f:%l:%c: %m",
			"%E%f:%l: %m",
			"%C%t%*[^:]: %m",
			"%-G%.%#",
		}, ",")
	elseif maven_root then
		local mvnw = vim.loop.fs_stat(maven_root .. "/mvnw") and (maven_root .. "/mvnw") or "mvn"
		local cmd = string.format(
			[[bash -lc 'cd "%s" && %s -q -DskipTests=false -Dstyle.color=never package']],
			maven_root,
			mvnw
		)
		vim.notify("Maven package @ " .. maven_root .. "\n" .. cmd)
		vim.o.makeprg = cmd
		-- errorformat для Maven + fallback
		vim.o.errorformat = table.concat({
			"%E[ERROR] %f:%\\[%l,%c%\\] %m",
			"%W[WARNING] %f:%\\[%l,%c%\\] %m",
			"%E%f:%l:%c: %m",
			"%E%f:%l: %m",
			"%C%t%*[^:]: %m",
			"%-G%.%#",
		}, ",")
	else
		-- простой вариант для проектов без билд-системы (ищем ближайший src вверх)
		local src_root = select(1, find_up({ "src" })) or start_dir
		vim.fn.mkdir(src_root .. "/out", "p")
		local cmd = string.format(
			[[bash -lc 'cd "%s" && find src -name "*.java" > sources.txt && javac -d out @sources.txt']],
			src_root
		)
		vim.notify("javac compile @ " .. src_root .. "\n" .. cmd)
		vim.o.makeprg = cmd
		vim.o.errorformat = table.concat({
			"%E%f:%l:%c: %m",
			"%E%f:%l: %m",
			"%C%t%*[^:]: %m",
			"%-G%.%#",
		}, ",")
	end

	-- запускаем сборку и открываем quickfix только при ошибках
	vim.cmd("make!")
	-- если есть ошибки, открыть, иначе закрыть/сообщить успех
	local qf = vim.fn.getqflist({ size = 0 })
	if qf and qf.size and qf.size > 0 then
		vim.cmd("copen")
	else
		vim.cmd("cclose")
		vim.notify("Build finished: no errors found")
	end
end

vim.keymap.set("n", "<leader>jb", java_build, { desc = "Java: Build project" })

-- Альтернативная команда для тех, кому удобнее командой
vim.api.nvim_create_user_command("JavaBuild", java_build, { desc = "Build Java project (Gradle/Maven/javac)" })

-- Терминальная сборка с живым логом (Gradle/Maven) из корня проекта
local function java_build_term()
	local start_dir = vim.fn.expand("%:p:h")
	if start_dir == "" then
		start_dir = vim.loop.cwd()
	end

	local function find_up(names)
		local found = vim.fs.find(names, { upward = true, path = start_dir })
		if #found > 0 then
			return vim.fs.dirname(found[1]), found[1]
		end
		return nil, nil
	end

	local gradle_root = select(1, find_up({ "gradlew", "build.gradle.kts", "build.gradle" }))
	local maven_root = select(1, find_up({ "mvnw", "pom.xml" }))

	local cwd, cmd
	if gradle_root then
		local gradlew = vim.loop.fs_stat(gradle_root .. "/gradlew") and "./gradlew" or "gradle"
		cwd = gradle_root
		cmd = gradlew .. " build"
	elseif maven_root then
		local mvnw = vim.loop.fs_stat(maven_root .. "/mvnw") and "./mvnw" or "mvn"
		cwd = maven_root
		cmd = mvnw .. " -q -DskipTests=false -Dstyle.color=never package"
	else
		vim.notify("Не найден Gradle/Maven проект выше по дереву", vim.log.levels.WARN)
		return
	end

	-- открыть нижний сплит-терминал и запустить команду в корне проекта
	vim.cmd("botright 15split")
	local term_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, term_buf)
	-- Используем оболочку для корректной инициализации окружения
	local shell = vim.o.shell ~= "" and vim.o.shell or "zsh"
	vim.api.nvim_buf_set_lines(term_buf, 0, -1, false, { "Running: " .. cmd, "cwd: " .. cwd, "" })
	vim.fn.termopen({ shell, "-lc", cmd }, { cwd = cwd })
	vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>jB", java_build_term, { desc = "Java: Build project (terminal log)" })
vim.api.nvim_create_user_command(
	"JavaBuildTerm",
	java_build_term,
	{ desc = "Build Java project in terminal (Gradle/Maven)" }
)
