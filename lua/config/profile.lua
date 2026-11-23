local profiles = {
	macos = {
		theme = "github",
		shell = "zsh",
		shell_login_args = { "-lic" },
		open_command = "open",
	},
	arch = {
		theme = "rose-pine",
		shell = "zsh",
		shell_login_args = { "-lic" },
		open_command = "xdg-open",
	},
}

local system = (vim.uv or vim.loop).os_uname().sysname
local detected = system == "Darwin" and "macos" or "arch"
local name = vim.env.NVIM_PROFILE or detected
local selected = profiles[name]

if not selected then
	error("Неизвестный NVIM_PROFILE: " .. name)
end

return vim.tbl_extend("force", { name = name }, selected)
