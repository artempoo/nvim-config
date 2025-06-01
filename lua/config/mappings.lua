vim.g.mapleader = " "

--NeoTree
vim.keymap.set("n", "<leader>e", ":Neotree float<CR>")
vim.keymap.set("n", "<leader>sp", ":vsplit<CR>")
vim.keymap.set("n", "<leader>on", ":only<CR>")
vim.keymap.set("n", "<leader>fr", ":%s/")
vim.keymap.set("n", "<leader>ls", ":LiveServerStart<CR>")
vim.keymap.set("n", "<leader>lt", ":LiveServerStop<CR>")

vim.keymap.set("n", "<leader>sg", ":split<CR>")
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>")
vim.keymap.set("n", "<leader>te", ":tabedit<CR>")

vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sl", "<C-w>l")

vim.keymap.set("n", "<TAB>t", ":tabnew:tabedit<CR>")

-- останавливаем и закрываем отладчик
vim.keymap.set("n", "<Leader>dq", function()
	-- 1. Остановить отладчик (если запущен)
	pcall(require("dap").terminate)

	-- 2. Закрыть все окна DAP UI
	pcall(require("dapui").close)

	-- 3. Удалить "зависшие" буферы (DAP Console и др.)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if buf_name:match("DAP") then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end

	-- 4. Вернуться к исходному виду окон
	vim.cmd("only")
end, { desc = "[D]AP [Q]uit: Force close debugger UI" })

-- Прервать отладку (аналог иконки №7 в REPL)
vim.keymap.set("n", "<Leader>di", function()
	require("dap").disconnect() -- Остановить отладчик + закрыть сессию
	require("dapui").close() -- Закрыть интерфейс
end, { desc = "[D]ebug [I]nterrupt" })
