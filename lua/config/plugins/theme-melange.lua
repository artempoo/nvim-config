return {
	"savq/melange-nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.opt.termguicolors = true

		local function set_transparent_background()
			for _, group in ipairs({ "Normal", "NormalNC", "NormalFloat", "SignColumn", "EndOfBuffer" }) do
				vim.api.nvim_set_hl(0, group, { bg = "NONE" })
			end
		end

		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "melange",
			callback = set_transparent_background,
		})

		vim.cmd.colorscheme("melange")
		set_transparent_background()
	end,
}
