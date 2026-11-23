local M = {
	name = nil,
	styles = {},
}

function M.set(name, styles)
	M.name = name
	M.styles = styles or {}
end

function M.get(key, fallback)
	if vim.g.colors_name ~= M.name then
		return fallback
	end

	local value = M.styles[key]
	if value == nil then
		return fallback
	end
	return value
end

return M
