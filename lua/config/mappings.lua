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

-- LSP маппинги
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Автодополнение
vim.keymap.set("i", "<C-Space>", "<cmd>lua require('cmp').complete()<CR>", { desc = "Trigger completion" })

-- Поиск документации в браузере
vim.keymap.set("n", "<leader>ts", function()
	local word = vim.fn.expand("<cword>")
	local url = "https://learn.javascript.ru/search?query=" .. word
	vim.fn.system("open '" .. url .. "'")
end, { desc = "Search learn.javascript.ru documentation" })


