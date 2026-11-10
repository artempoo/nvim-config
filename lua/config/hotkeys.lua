local M = {}

local sections = {
	{ "ФАЙЛЫ И ПОИСК",
		{ "<Space>ff", "Найти файл" },
		{ "<Space>fg", "Найти текст в проекте" },
		{ "<Space>fb", "Показать открытые буферы" },
		{ "<Space>e / <Space>E", "Проводник: корень проекта / текущая папка" },
		{ "<Space>o", "Открыть или закрыть файловый менеджер Oil" },
		{ "q (в Oil)", "Закрыть файловый менеджер Oil" },
		{ "<Space>fr", "Заменить текст в текущем файле" },
		{ "<Space>fs", "Поиск введённого текста в проекте" },
	},
	{ "КОД И LSP",
		{ "gd", "Перейти к определению" },
		{ "gr", "Найти использования символа" },
		{ "K", "Показать документацию" },
		{ "<Space>rn", "Переименовать символ" },
		{ "<Space>ca", "Доступные действия над кодом" },
		{ "<Space>d", "Показать диагностику строки" },
		{ "[d / ]d", "Предыдущая / следующая ошибка" },
		{ "<Space>cL", "Форматировать файл или выделение" },
	},
	{ "ПЕРЕВОД",
		{ "<Space>t (visual)", "Перевести выделение: русский ↔ английский" },
	},
	{ "БУФЕРЫ, ВКЛАДКИ И ОКНА",
		{ "<Tab>e / <Tab>w", "Следующий / предыдущий буфер" },
		{ "<Tab>q", "Закрыть текущий буфер" },
		{ "<Tab>l / <Tab>r", "Закрыть буферы слева / справа" },
		{ "<Space>te", "Открыть новую вкладку" },
		{ "sh / sj / sk / sl", "Окно слева / снизу / сверху / справа" },
		{ "m, / m.", "Переместить строку вниз / вверх" },
	},
	{ "ТЕРМИНАЛ И ИНСТРУМЕНТЫ",
		{ "<Space>t", "Открыть терминал снизу" },
		{ "Esc", "Выйти из режима терминала" },
		{ "<Space>ts", "Найти слово на learn.javascript.ru" },
		{ "<Space>sl / <Space>sls", "Запустить / остановить Live Server" },
	},
	{ "ОТЛАДКА",
		{ "F5 / F6", "Продолжить / перезапустить отладку" },
		{ "F10 / F11 / F12", "Шаг через / внутрь / наружу" },
		{ "<Space>b / <Space>B", "Обычная / условная точка останова" },
		{ "<Space>dq", "Остановить отладку и закрыть её окна" },
		{ "<Space>di", "Прервать отладочную сессию" },
	},
	{ "МУЛЬТИКУРСОР",
		{ "<Ctrl-c>", "Добавить курсор в текущей позиции" },
		{ "<Ctrl-n>", "Добавить следующее совпадение" },
		{ "w / e / b", "Перемещаться при ручной расстановке курсоров" },
		{ "<Ctrl-g>", "Завершить расстановку и управлять всеми курсорами" },
		{ "<Ctrl-Up/Down>", "Добавить курсор строкой выше / ниже" },
		{ "c", "Заменить все выбранные фрагменты" },
	},
	{ "JAVA И GIT",
		{ "<Space>jb", "Собрать Java-проект с quickfix" },
		{ "<Space>jB", "Собрать Java-проект в терминале" },
		{ "<Space>gl", "Показать граф Git" },
	},
}

function M.open()
	local lines = {
		"  ГОРЯЧИЕ КЛАВИШИ",
		"  j/k — прокрутка · / — поиск · n/N — результаты · q или Esc — закрыть",
		"",
	}
	local headings = {}
	for _, section in ipairs(sections) do
		table.insert(headings, #lines)
		table.insert(lines, section[1])
		for index = 2, #section do
			local item = section[index]
			table.insert(lines, string.format("  %-24s %s", item[1], item[2]))
		end
		table.insert(lines, "")
	end

	local width = math.max(1, math.min(88, vim.o.columns - 4))
	local height = math.max(1, math.min(#lines, vim.o.lines - 4))
	local bufnr = vim.api.nvim_create_buf(false, true)
	local winid = vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.max(0, math.floor((vim.o.lines - height) / 2)),
		col = math.max(0, math.floor((vim.o.columns - width) / 2)),
		style = "minimal",
		border = "rounded",
		title = " Памятка ",
		title_pos = "center",
	})

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].modifiable = false
	vim.bo[bufnr].filetype = "hotkeys"
	vim.wo[winid].cursorline = true
	vim.wo[winid].wrap = false

	local close = function()
		if vim.api.nvim_win_is_valid(winid) then
			vim.api.nvim_win_close(winid, true)
		end
	end
	vim.keymap.set("n", "q", close, { buffer = bufnr, silent = true })
	vim.keymap.set("n", "<Esc>", close, { buffer = bufnr, silent = true })

	local namespace = vim.api.nvim_create_namespace("hotkeys_help")
	vim.api.nvim_buf_add_highlight(bufnr, namespace, "Title", 0, 0, -1)
	vim.api.nvim_buf_add_highlight(bufnr, namespace, "Comment", 1, 0, -1)
	for _, line in ipairs(headings) do
		vim.api.nvim_buf_add_highlight(bufnr, namespace, "Function", line, 0, -1)
	end
end

vim.api.nvim_create_user_command("Hotkeys", M.open, { desc = "Показать памятку горячих клавиш" })
vim.keymap.set("n", "<leader>h", M.open, { desc = "Показать памятку горячих клавиш" })

return M
