return {
	"nolleh/warp.nvim",
	config = true, -- Default keymap: <leader>w
	-- Or customize:
	-- config = function()
	--   require("warp").setup({
	--     default_keymap = "<leader>wf",  -- or false to disable
	--   })
	-- end,
	keys = { "<leader>w" }, -- your binding key (trigger lazy loading)
}
