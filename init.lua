require("config.lazy")
require("config.option")
require("config.mappings")

-- vim.cmd("syntax off");
-- vim.wo.foldmethod = "manual" -- отключает автоматическое фолдинг
--       vim.wo.spell = false        -- отключает проверку орфографии
--       vim.wo.wrap = false         -- отключает перенос строк

-- Глобальные настройки диагностики: не обновлять в режиме вставки, минимум шума
vim.diagnostic.config({
	update_in_insert = false,
	virtual_text = false,
	underline = true,
	severity_sort = true,
})

-- Для Java: скрывать диагностику в Insert и включать после выхода
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
	pattern = { "*.java" },
	callback = function()
		vim.diagnostic.disable(0)
	end,
})

-- Заглушаем только уведомления прогресса (это notification, не request)
vim.lsp.handlers["$/progress"] = function() end
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
	pattern = { "*.java" },
	callback = function()
		vim.diagnostic.enable(0)
	end,
})

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
