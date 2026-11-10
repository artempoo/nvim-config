local M = {}

local function split_lines(text)
	return vim.split(text, "\n", { plain = true })
end

local function clean_text(text)
	text = text:gsub("\r\n", "\n"):gsub("\r", "\n")
	text = text:gsub("\239\187\191", "") -- BOM
	text = text:gsub("\194\173", "") -- soft hyphen
	text = text:gsub("\226\128\139", "") -- zero-width space
	text = text:gsub("\226\128\140", "") -- zero-width non-joiner
	text = text:gsub("\226\128\141", "") -- zero-width joiner
	text = text:gsub("\226\129\160", "") -- word joiner
	text = text:gsub("\194\160", " ") -- non-breaking space
	text = text:gsub("\226\128\175", " ") -- narrow non-breaking space
	text = text:gsub("%c", function(char)
		if char == "\n" then
			return char
		end
		if char == "\t" then
			return " "
		end
		return ""
	end)
	return vim.trim(text)
end

local function clean_error(text)
	text = text:gsub("\27%[[%d;?]*[ -/]*[@-~]", "")
	text = clean_text(text)

	local lines = {}
	local seen = {}
	for _, line in ipairs(split_lines(text)) do
		line = vim.trim(line):gsub("^%[ERROR%]%s*", "")
		if line ~= "" and not seen[line] then
			seen[line] = true
			table.insert(lines, line)
		end
	end
	return table.concat(lines, "; ")
end

local function close_window(winid)
	if vim.api.nvim_win_is_valid(winid) then
		vim.api.nvim_win_close(winid, true)
	end
end

local function detect_direction(text)
	local cyrillic = vim.fn.strchars(vim.fn.substitute(text, "[^А-Яа-яЁё]", "", "g"))
	local latin = vim.fn.strchars(vim.fn.substitute(text, "[^A-Za-z]", "", "g"))

	if cyrillic > latin then
		return "en", "Русский → English"
	end

	return "ru", "English → Русский"
end

local function start_wait_notification(direction)
	local wait_message = "Перевожу: " .. direction .. "…"
	local ok, progress = pcall(require, "fidget.progress")
	if not ok then
		vim.api.nvim_echo({ { wait_message, "DiagnosticInfo" } }, false, {})
		return function(success, message)
			vim.api.nvim_echo({ {
				(success and "✓ " or "✗ ") .. message,
				success and "DiagnosticOk" or "DiagnosticError",
			} }, false, {})
		end
	end

	local handle = progress.handle.create({
		message = wait_message,
		lsp_client = { name = "Перевод" },
	})

	return function(success, message)
		handle:report({ message = message })
		handle:finish()
		if not success then
			require("fidget.notification").notify(message, vim.log.levels.ERROR, {
				annote = "Перевод",
			})
		end
	end
end

local function show_result(source, translation, selection, direction)
	local lines = { "ИСХОДНЫЙ ТЕКСТ", "" }
	vim.list_extend(lines, split_lines(source))
	table.insert(lines, "")
	local translation_heading = #lines
	table.insert(lines, "ПЕРЕВОД · " .. direction)
	table.insert(lines, "")
	vim.list_extend(lines, split_lines(translation))
	table.insert(lines, "")
	table.insert(lines, "Y — копировать перевод · Enter — заменить выделение · q/Esc — закрыть")

	local max_line_width = 0
	for _, line in ipairs(lines) do
		max_line_width = math.max(max_line_width, vim.fn.strdisplaywidth(line))
	end
	local width = math.max(1, math.min(88, max_line_width + 4, vim.o.columns - 4))
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
		title = " Перевод ",
		title_pos = "center",
	})

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].modifiable = false
	vim.bo[bufnr].filetype = "translation"
	vim.wo[winid].cursorline = true
	vim.wo[winid].wrap = true

	local namespace = vim.api.nvim_create_namespace("translation_window")
	vim.api.nvim_buf_add_highlight(bufnr, namespace, "Title", 0, 0, -1)
	vim.api.nvim_buf_add_highlight(bufnr, namespace, "Title", translation_heading, 0, -1)
	vim.api.nvim_buf_add_highlight(bufnr, namespace, "Comment", #lines - 1, 0, -1)

	local close = function()
		close_window(winid)
	end
	vim.keymap.set("n", "q", close, { buffer = bufnr, silent = true })
	vim.keymap.set("n", "<Esc>", close, { buffer = bufnr, silent = true })
	vim.keymap.set("n", "Y", function()
		vim.fn.setreg("+", translation)
		vim.notify("Перевод скопирован в буфер обмена", vim.log.levels.INFO)
	end, { buffer = bufnr, silent = true })
	vim.keymap.set("n", "<CR>", function()
		if not vim.api.nvim_buf_is_valid(selection.bufnr) then
			vim.notify("Исходный буфер уже закрыт", vim.log.levels.ERROR)
			return
		end

		local replacement = split_lines(translation)
		local end_row = selection.end_row
		local end_col = selection.end_col
		if selection.mode == "V" then
			selection.start_col = 0
			end_row = end_row + 1
			end_col = 0
		else
			local end_line = vim.api.nvim_buf_get_lines(selection.bufnr, end_row, end_row + 1, false)[1] or ""
			local char = end_line:sub(end_col + 1):match("^.[\128-\191]*") or ""
			end_col = end_col + #char
		end

		vim.api.nvim_buf_set_text(
			selection.bufnr,
			selection.start_row,
			selection.start_col,
			end_row,
			end_col,
			replacement
		)
		close()
	end, { buffer = bufnr, silent = true })
end

function M.translate_visual()
	local mode = vim.fn.mode()
	local old_register = vim.fn.getreginfo("z")
	vim.cmd([[normal! "zy]])
	local source = clean_text(vim.fn.getreg("z"))
	vim.fn.setreg("z", old_register)

	if source == "" then
		vim.notify("Не удалось получить выделенный текст", vim.log.levels.WARN)
		return
	end

	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local selection = {
		bufnr = vim.api.nvim_get_current_buf(),
		mode = mode,
		start_row = start_pos[2] - 1,
		start_col = start_pos[3] - 1,
		end_row = end_pos[2] - 1,
		end_col = end_pos[3] - 1,
	}
	local target_language, direction = detect_direction(source)
	local finish_wait = start_wait_notification(direction)

	local engines = { "google", "bing" }
	local errors = {}

	local function run_translation(index)
		local engine = engines[index]
		vim.system({ "trans", "-b", "-e", engine, ":" .. target_language, source }, { text = true }, function(result)
			local translation = clean_text(result.stdout or "")
			if result.code ~= 0 or translation == "" then
				local message = clean_error(result.stderr or "")
				table.insert(errors, engine .. ": " .. (message ~= "" and message or "нет ответа"))
				if index < #engines then
					run_translation(index + 1)
					return
				end
			end

			vim.schedule(function()
				if result.code ~= 0 or translation == "" then
					finish_wait(false, table.concat(errors, " · "))
					return
				end
				finish_wait(true, "Перевод готов · " .. engine)
				show_result(source, translation, selection, direction)
			end)
		end)
	end

	run_translation(1)
end

return M
