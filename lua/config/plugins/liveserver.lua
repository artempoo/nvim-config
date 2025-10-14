return {
	"barrett-ruth/live-server.nvim",
	build = "npm install -g live-server",
	cmd = { "LiveServerStart", "LiveServerStop" },
	config = function()
		require("live-server").setup({
			port = 8080,
			host = "127.0.0.1",
			root = vim.fn.getcwd(),
			open = true,
			ignore = "node_modules",
			file = "index.html",
			wait = 1000,
			logLevel = 2,
		})
	end,
}
