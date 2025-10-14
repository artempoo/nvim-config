return {
	"goolord/alpha-nvim",
	dependencies = {
		"echasnovski/mini.icons",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local Path = require("plenary.path")
		local alpha = require("alpha")
		local theta = require("alpha.themes.theta")

		-- Хранилище путей проектов: Lua-файл вида
		-- return { palette = { red = "#ff0000", ... }, projects = { { name=..., path=..., icon=..., color="red" }, ... } }
		local projects_file = vim.fn.stdpath("data") .. "/projects.lua"
		local default_icon = "󰝰"

		-- Значения палитры по умолчанию (если в projects.lua нет своей)
		local default_palette = {
			red = "#E06C75",
			orange = "#D19A66",
			yellow = "#E5C07B",
			green = "#98C379",
			cyan = "#56B6C2",
			blue = "#61AFEF",
			purple = "#C678DD",
			pink = "#FF79C6",
			rose = "#eb6f92",
			gold = "#f6c177",
			foam = "#9ccfd8",
			iris = "#c4a7e7",
			pine = "#31748f",
		}
		local palette = vim.deepcopy(default_palette)

		-- Создаёт/обновляет hl-группу для иконок
		local function ensure_icon_hl(name, hex)
			if not name or not hex or hex == "" then return nil end
			local group = "AlphaProjectIcon_" .. name
			vim.api.nvim_set_hl(0, group, { fg = hex })
			return group
		end

		local function read_projects()
			local p = Path:new(projects_file)
			if not p:exists() then return {} end
			local chunk, err = loadfile(projects_file)
			if not chunk then
				vim.notify("projects.lua load error: " .. tostring(err), vim.log.levels.WARN)
				return {}
			end
			local ok, data = pcall(chunk)
			if not ok or type(data) ~= "table" then return {} end
			-- Поддержка двух форматов: старый (массив проектов) и новый (таблица с palette/projects)
			if vim.tbl_islist(data) then
				return data
			end
			if type(data.projects) == "table" then
				if type(data.palette) == "table" then
					palette = vim.tbl_extend("force", {}, default_palette, data.palette)
				end
				return data.projects
			end
			return {}
		end

		local function write_projects(items)
			local dir = Path:new(projects_file):parent()
			dir:mkdir({ parents = true, mode = 493 })
			-- Сохраняем текущую пользовательскую палитру, если она есть в файле
			local existing_palette = nil
			local chunk = loadfile(projects_file)
			if chunk then
				local ok, data = pcall(chunk)
				if ok and type(data) == "table" and type(data.palette) == "table" then
					existing_palette = data.palette
				end
			end
			local out = {
				palette = existing_palette or palette,
				projects = items,
			}
			local body = "return " .. vim.inspect(out)
			Path:new(projects_file):write(body .. "\n", "w")
		end

		local function add_current_project()
			local cwd = vim.loop.cwd()
			if not cwd or cwd == "" then
				vim.notify("Не удалось определить текущую директорию", vim.log.levels.WARN)
				return
			end
			local items = read_projects()
			for _, it in ipairs(items) do
				if it.path == cwd then
					vim.notify("Проект уже в списке: " .. cwd)
					return
				end
			end
			local name = vim.fn.fnamemodify(cwd, ":t")
			table.insert(items, { name = name, path = cwd, icon = default_icon })
			write_projects(items)
			vim.notify("Добавлен проект: " .. name)
			-- Обновим дашборд
			vim.cmd("AlphaRedraw")
		end

		local function set_icon_current()
			local cwd = vim.loop.cwd()
			if not cwd or cwd == "" then
				vim.notify("Не удалось определить текущую директорию", vim.log.levels.WARN)
				return
			end
			local items = read_projects()
			local idx = nil
			for i, it in ipairs(items) do
				if it.path == cwd then idx = i break end
			end
			if not idx then
				vim.notify("Текущая директория не найдена в проектах", vim.log.levels.WARN)
				return
			end
			local current = items[idx]
			local icon = vim.fn.input("Иконка для '" .. (current.name or current.path) .. "': ", current.icon or default_icon)
			if icon == nil or icon == "" then icon = default_icon end
			items[idx].icon = icon
			write_projects(items)
			vim.notify("Иконка обновлена: " .. icon)
			vim.cmd("AlphaRedraw")
		end

		local function set_icon_color_current()
			local cwd = vim.loop.cwd()
			if not cwd or cwd == "" then
				vim.notify("Не удалось определить текущую директорию", vim.log.levels.WARN)
				return
			end
			local items = read_projects()
			local idx = nil
			for i, it in ipairs(items) do
				if it.path == cwd then idx = i break end
			end
			if not idx then
				vim.notify("Текущая директория не найдена в проектах", vim.log.levels.WARN)
				return
			end
			-- Показать подсказку с доступными ключами
			local keys = {}
			for k, _ in pairs(palette) do table.insert(keys, k) end
			table.sort(keys)
			local prompt = "Цвет иконки [" .. table.concat(keys, ", ") .. "]: "
			local prev = items[idx].color or ""
			local choice = vim.fn.input(prompt, prev)
			if choice == nil or choice == "" then
				vim.notify("Цвет не изменён")
				return
			end
			if not palette[choice] then
				vim.notify("Неизвестный цвет: " .. choice, vim.log.levels.WARN)
				return
			end
			items[idx].color = choice
			write_projects(items)
			vim.notify("Цвет иконки обновлён: " .. choice)
			vim.cmd("AlphaRedraw")
		end

		local function edit_projects()
			local p = Path:new(projects_file)
			if not p:exists() then
				write_projects({})
			end
			vim.cmd("edit " .. projects_file)
			-- Отключаем автоформаттеры для этого буфера
			vim.b.conform_disable = true
			vim.b.disable_autoformat = true
			vim.bo.filetype = "lua"
		end

		-- Для projects.lua просто запрещаем автоформаттеры на чтение/сохранение
		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePre" }, {
			pattern = projects_file,
			callback = function()
				vim.b.conform_disable = true
				vim.b.disable_autoformat = true
				vim.bo.filetype = "lua"
			end,
		})

		vim.api.nvim_create_user_command("ProjectsAddCurrent", add_current_project, { desc = "Add current CWD to projects" })
		vim.api.nvim_create_user_command("ProjectsSetIcon", set_icon_current, { desc = "Set icon for current project" })
		vim.api.nvim_create_user_command("ProjectsSetIconColor", set_icon_color_current, { desc = "Set icon color from palette for current project" })
		vim.api.nvim_create_user_command("ProjectsEdit", edit_projects, { desc = "Edit projects.json" })

		-- Локальный конструктор кнопок (аналог themes.*.button)
		local function make_button(label, command, keybinding)
			local opts = {
				position = "left",           -- текст выровнен влево
				shortcut = "",               -- не показываем хоткей визуально
				align_shortcut = "left",
				width = 50,
				cursor = 0,
			}
			local function on_press()
				local key = vim.api.nvim_replace_termcodes(command, true, false, true)
				vim.api.nvim_feedkeys(key, "t", false)
			end
			local btn = { type = "button", val = label, on_press = on_press, opts = opts }
			if keybinding and keybinding ~= "" then
				-- Возвращаем локальную привязку к буферу дашборда (как работало ранее)
				btn.keymap = { "n", keybinding, command, { noremap = true, silent = true, nowait = true, buffer = true } }
			end
			return btn
		end

		local function projects_buttons()
			local items = read_projects()
			if #items == 0 then
				return {}
			end
			local btns = {}
			for idx, it in ipairs(items) do
				local key = string.format("%d", (idx % 9))
				if key == "0" then key = "9" end
			local icon = it.icon or default_icon
			local name = it.name or it.path
			local label = icon .. "  " .. name
			local cmd = string.format(":lua vim.fn.setreg('+', [[%s]]); vim.notify('Путь скопирован в буфер', vim.log.levels.INFO)<CR>", it.path)
			local button = make_button(label, cmd, key)
			-- Если указан цвет — подсветим только иконку внутри строки кнопки
			if it.color and palette[it.color] then
				local group = ensure_icon_hl(it.color, palette[it.color])
				if group then
					local icon_len = #icon -- байтовая длина символа-иконки
					button.opts.hl = { { group, 0, icon_len } }
				end
			end
			table.insert(btns, button)
				if idx >= 7 then break end -- показываем до 7 проектов
			end
			return btns
		end

		-- Кастомный ASCII баннер
		local header_file = vim.fn.stdpath("config") .. "/alpha_header.txt"
		local function read_header_lines()
			local p = Path:new(header_file)
			if not p:exists() then return nil end
			local ok, content = pcall(function() return p:read() end)
			if not ok or not content or content == "" then return nil end
			local lines = {}
			for line in (content .. "\n"):gmatch("([^\n]*)\n") do
				table.insert(lines, line)
			end
			return lines
		end
		local function ensure_header_file()
			local p = Path:new(header_file)
			if p:exists() then return end
			local sample = table.concat({
				"███╗   ██╗██╗   ██╗██╗███╗   ███╗",
				"████╗  ██║██║   ██║██║████╗ ████║",
				"██╔██╗ ██║██║   ██║██║██╔████╔██║",
				"██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
				"██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
				"╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
				"",
			}, "\n")
			p:write(sample .. "\n", "w")
		end
		-- Команда редактирования баннера
		vim.api.nvim_create_user_command("AlphaHeaderEdit", function()
			ensure_header_file()
			vim.cmd("edit " .. header_file)
		end, { desc = "Edit Alpha dashboard header (ASCII art)" })

		local header_lines = read_header_lines()
		local header
		if header_lines then
			-- Градиент в одном текстовом элементе: раскрашиваем каждую строку через opts.hl
			local gradient_keys = { "rose", "gold", "foam", "iris", "pine", "blue", "purple", "pink", "red", "orange", "yellow", "green", "cyan" }
			local colors = {}
			for _, k in ipairs(gradient_keys) do
				if palette[k] then table.insert(colors, { key = k, hex = palette[k] }) end
			end
			if #colors == 0 then
				colors = { { key = "iris", hex = "#c4a7e7" } }
			end
			local function pick_color(idx, total)
				if total <= 1 then return colors[1] end
				local pos = (idx - 1) / (total - 1)
				local ci = math.floor(pos * (#colors - 1)) + 1
				return colors[ci]
			end
			local hl_per_line = {}
			for i = 1, #header_lines do
				local c = pick_color(i, #header_lines)
				local group = ensure_icon_hl("AlphaHeader_" .. c.key, c.hex) or "Normal"
				hl_per_line[i] = { { group, 0, -1 } } -- весь ряд в цвете
			end
			header = { type = "text", val = header_lines, opts = { position = "center", hl = hl_per_line } }
		else
			header = theta.header
		end
		local dashboard = theta.config
		-- Основное меню (добавить/редактировать) — отдельный блок
		local main_menu = {
			make_button("  Добавить текущий проект", ":ProjectsAddCurrent<CR>", "a"),
			make_button("  Редактировать список", ":ProjectsEdit<CR>", "e"),
		}

		-- Удалили дополнительные буферные keymaps, чтобы избежать смещения индексов

		-- Разметка: центрируем группы, но текст внутри кнопок выровнен влево
			dashboard.layout = {
			{ type = "padding", val = 1 },
			header,
			{ type = "padding", val = 1 },
			{ type = "group", opts = { position = "center" }, val = main_menu },
			{ type = "padding", val = 1 },
			{ type = "group", opts = { position = "center" }, val = projects_buttons() },
		}

		alpha.setup(dashboard)


	end,
}
