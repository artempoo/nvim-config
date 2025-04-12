local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup("config.plugins")
--
-- require("catppuccin").setup({
-- 	flavour = "auto", -- latte, frappe, macchiato, mocha
-- 	background = { -- :h background
-- 		light = "auto",
-- 		dark = "mocha",
-- 	},
-- 	transparent_background = true, -- disables setting the background color.
-- 	show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
-- 	term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
-- 	dim_inactive = {
-- 		enabled = false, -- dims the background color of inactive window
-- 		shade = "dark",
-- 		percentage = 0.15, -- percentage of the shade to apply to the inactive window
-- 	},
-- 	no_italic = false, -- Force no italic
-- 	no_bold = false, -- Force no bold
-- 	no_underline = false, -- Force no underline
-- 	styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
-- 		comments = { "italic" }, -- Change the style of comments
-- 		conditionals = { "italic" },
-- 		loops = {},
-- 		functions = { "bold" },
-- 		keywords = {},
-- 		strings = {},
-- 		variables = {},
-- 		numbers = {},
-- 		booleans = {},
-- 		properties = {},
-- 		types = {},
-- 		operators = {},
-- 		-- miscs = {}, -- Uncomment to turn off hard-coded styles
-- 	},
-- 	color_overrides = {},
-- 	custom_highlights = {},
-- 	default_integrations = true,
-- 	integrations = {
-- 		cmp = true,
-- 		gitsigns = true,
-- 		nvimtree = true,
-- 		treesitter = true,
-- 		notify = true,
-- 		mini = {
-- 			enabled = true,
-- 			indentscope_color = "",
-- 		},
-- 		-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
-- 	},
-- })
--
-- -- setup must be called before loading
-- vim.cmd.colorscheme("catppuccin")

require("rose-pine").setup({
	variant = "auto", -- auto, main, moon, or dawn
	dark_variant = "main", -- main, moon, or dawn
	dim_inactive_windows = false,
	extend_background_behind_borders = true,

	enable = {
		terminal = true,
		legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
		migrations = true, -- Handle deprecated options automatically
	},

	styles = {
		bold = true,
		italic = true,
		transparency = true,
	},

	groups = {
		border = "muted",
		link = "iris",
		panel = "surface",

		error = "love",
		hint = "iris",
		info = "foam",
		note = "pine",
		todo = "rose",
		warn = "gold",

		git_add = "foam",
		git_change = "rose",
		git_delete = "love",
		git_dirty = "rose",
		git_ignore = "muted",
		git_merge = "iris",
		git_rename = "pine",
		git_stage = "iris",
		git_text = "rose",
		git_untracked = "subtle",

		h1 = "iris",
		h2 = "foam",
		h3 = "rose",
		h4 = "gold",
		h5 = "pine",
		h6 = "foam",
	},

	palette = {
		-- Override the builtin palette per variant
		-- moon = {
		--     base = '#18191a',
		--     overlay = '#363738',
		-- },
	},

	-- NOTE: Highlight groups are extended (merged) by default. Disable this
	-- per group via `inherit = false`
	highlight_groups = {
		-- Comment = { fg = "foam" },
		-- StatusLine = { fg = "love", bg = "love", blend = 15 },
		-- VertSplit = { fg = "muted", bg = "muted" },
		-- Visual = { fg = "base", bg = "text", inherit = false },
	},

	before_highlight = function(group, highlight, palette)
		-- Disable all undercurls
		-- if highlight.undercurl then
		--     highlight.undercurl = false
		-- end
		--
		-- Change palette colour
		-- if highlight.fg == palette.pine then
		--     highlight.fg = palette.foam
		-- end
	end,
})

vim.cmd("colorscheme rose-pine")

require("Comment").setup()
require("live-server").setup()
--
require("cmp").setup({
	sources = {
		{ name = "nvim_lsp" },
	},
})
require("cmp_nvim_lsp").setup()

require("ibl").setup({})
