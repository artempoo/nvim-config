return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local function setup_lualine()
			require("lualine").setup({
				options = {
					theme = require("config.theme").get("lualine", "auto"),
					globalstatus = true,
					component_separators = "",
					section_separators = "",
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "branch" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
			})
		end

		setup_lualine()
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.schedule(setup_lualine)
			end,
		})
	end,
}

