return {
	"rcarriga/nvim-notify",
	priority = 1000,
	opts = {
		timeout = 2500,
	},
	config = function(_, opts)
		local notify = require("notify")

		local function setup_notify()
			local background = require("config.theme").get("notify_background")
			if not background then
				local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
				local fallback = vim.api.nvim_get_color_by_name(vim.o.background == "light" and "white" or "black")
				background = string.format("#%06X", normal.bg or fallback)
			end
			opts.background_colour = background
			notify.setup(opts)
		end

		setup_notify()
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.schedule(setup_notify)
			end,
		})
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
