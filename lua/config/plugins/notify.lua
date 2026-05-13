return {
	"rcarriga/nvim-notify",
	priority = 1000,
	opts = {
		timeout = 12000,
		background_colour = "Normal",
	},
	config = function(_, opts)
		local notify = require("notify")
		notify.setup(opts)
		vim.notify = notify
		-- История уведомлений (Telescope; иначе :Notifications)
		vim.keymap.set("n", "<Leader>un", function()
			pcall(require("telescope").load_extension, "notify")
			local ok = pcall(vim.cmd, "Telescope notify")
			if not ok then
				require("notify")._print_history()
			end
		end, { desc = "Notify history" })
	end,
}
