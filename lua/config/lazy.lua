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
-- values shown are defaults and will be used if not provided
require("gruvbox-material").setup({
	background = {
		transparent = false, -- set the background to be opaque
	},
	float = {
		force_background = true, -- set to true to force backgrounds on floats even when
		-- background.transparent is set
		background_color = nil, -- set color for float backgrounds. If nil, uses the default color set
		-- by the color scheme
	},
	signs = {
		force_background = false, -- set to true to force backgrounds on signs even when
		-- background.transparent is set
		background_color = nil, -- set color for sign backgrounds. If nil, uses the default color set
		-- by the color scheme
	},
	customize = nil, -- customize the theme in any way you desire, see below what this
	-- configuration accepts
})
