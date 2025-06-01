return {
	"williamboman/mason.nvim",
	version = "v1.8.0",
	dependencies = {
		{
			"williamboman/mason-lspconfig.nvim",
			version = "v1.20.0",
		},
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup()

		require("mason-lspconfig").setup({
			automatic_installation = true, -- ← временно отключено
			ensure_installed = {
				"cssls",
				"eslint", -- или "eslint"
				"html",
				"jsonls",
				"ts_ls", -- вместо "ts_ls"
				"tailwindcss",
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"eslint_d",
			},
		})
	end,
}
