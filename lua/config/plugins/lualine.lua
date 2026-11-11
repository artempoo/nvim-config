return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local transparent_theme = {
			normal = {
				a = { fg = "#24292F", bg = "NONE", gui = "bold" },
				b = { fg = "#6E7781", bg = "NONE" },
				c = { fg = "#6E7781", bg = "NONE" },
			},
			insert = { a = { fg = "#24292F", bg = "NONE", gui = "bold" } },
			visual = { a = { fg = "#6F5A8A", bg = "NONE", gui = "bold" } },
			replace = { a = { fg = "#24292F", bg = "NONE", gui = "bold" } },
			command = { a = { fg = "#24292F", bg = "NONE", gui = "bold" } },
			inactive = {
				a = { fg = "#8C959F", bg = "NONE" },
				b = { fg = "#8C959F", bg = "NONE" },
				c = { fg = "#8C959F", bg = "NONE" },
			},
		}

		require("lualine").setup({
			options = {
				theme = transparent_theme,
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

		vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
	end,
}

