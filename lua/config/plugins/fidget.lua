return {
	"j-hui/fidget.nvim",
	version = "1.6.1",
	event = "VeryLazy",
	opts = {
		progress = {
			display = {
				done_ttl = 2,
				progress_ttl = math.huge,
			},
		},
		notification = {
			window = {
				normal_hl = "FidgetNormal",
				align = "bottom",
				border = "rounded",
				border_hl = "FidgetBorder",
				winblend = 20,
				max_width = 60,
				x_padding = 1,
				y_padding = 1,
			},
		},
	},
	config = function(_, opts)
		local function update_highlights()
			local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
			local comment = vim.api.nvim_get_hl(0, { name = "Comment" })
			local border = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
			vim.api.nvim_set_hl(0, "FidgetNormal", {
				fg = comment.fg or normal.fg,
				bg = normal.bg,
			})
			vim.api.nvim_set_hl(0, "FidgetBorder", {
				fg = border.fg or comment.fg or normal.fg,
				bg = normal.bg,
			})
		end

		update_highlights()
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = update_highlights,
		})
		require("fidget").setup(opts)
	end,
}
