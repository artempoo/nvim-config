return {
	"williamboman/mason.nvim",
	version = "v1.8.0",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup()

		require("mason-tool-installer").setup({
			ensure_installed = {
				"eslint_d",
				"rust-analyzer",
				"rustfmt",
				"jdtls",
			},
		})
	end,
}
