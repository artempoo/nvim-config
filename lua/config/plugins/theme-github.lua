return {
	"projekt0n/github-nvim-theme",
	name = "github-theme",
	enabled = require("config.profile").theme == "github",
	lazy = false,
	priority = 1100,
	config = function()
		vim.opt.termguicolors = true
		vim.opt.background = "light"
		local theme = require("config.theme")

		-- Keep GitHub Light configured below so it is easy to restore, but use
		-- Neovim's restrained built-in light theme for now.
		local use_builtin_quiet = false
		if use_builtin_quiet then
			vim.cmd.colorscheme("quiet")
			vim.api.nvim_set_hl(0, "Comment", { fg = "#8C959F", italic = true })
			vim.api.nvim_set_hl(0, "SpecialComment", { fg = "#8C959F", italic = true })
			vim.api.nvim_set_hl(0, "@comment", { fg = "#8C959F", italic = true })
			return
		end

		require("github-theme").setup({
			options = {
				transparent = true,
				dim_inactive = false,
				darken = {
					floats = false,
					sidebars = {
						enable = false,
					},
				},
			},
		})

		local palette = {
			strong = "#0D1117",
			ink = "#24292F",
			soft = "#4B535D",
			muted = "#8C959F",
			pink = "#BD4F7A",
			line_number = "#B8C0C8",
			line_number_current = "#6E7781",
			indent = "#E1E4E8",
			indent_scope = "#C8CDD2",
			buffer_accent = "#0969DA",
			buffer_background = "#DDF4FF",
			close = "#E0DEF4",
			close_visible = "#EB6F92",
		}

		theme.set("github_light_default", {
			notify_background = "#FFFFFF",
			lualine = {
				normal = {
					a = { fg = palette.ink, bg = "NONE", gui = "bold" },
					b = { fg = palette.line_number_current, bg = "NONE" },
					c = { fg = palette.line_number_current, bg = "NONE" },
				},
				insert = { a = { fg = palette.ink, bg = "NONE", gui = "bold" } },
				visual = { a = { fg = palette.pink, bg = "NONE", gui = "bold" } },
				replace = { a = { fg = palette.ink, bg = "NONE", gui = "bold" } },
				command = { a = { fg = palette.ink, bg = "NONE", gui = "bold" } },
				inactive = {
					a = { fg = palette.muted, bg = "NONE" },
					b = { fg = palette.muted, bg = "NONE" },
					c = { fg = palette.muted, bg = "NONE" },
				},
			},
			bufferline = {
				close_button = { fg = palette.close, bg = "NONE", bold = true },
				close_button_visible = { fg = palette.close_visible, bg = "NONE", bold = true },
				close_button_selected = {
					fg = palette.buffer_accent,
					bg = palette.buffer_background,
					bold = true,
				},
				buffer_selected = { fg = palette.ink, bg = palette.buffer_background, bold = true },
				indicator_selected = { fg = palette.buffer_accent, bg = palette.buffer_background },
				separator_selected = { fg = palette.buffer_background, bg = palette.buffer_background },
			},
		})

		local function make_monochrome()
			if vim.g.colors_name ~= "github_light_default" then
				return
			end

			local strong = palette.strong
			local ink = palette.ink
			local soft = palette.soft
			local muted = palette.muted
			local pink = palette.pink
			local strong_groups = {
				Function = true,
				Tag = true,
			}
			local purple_groups = {
				Statement = true,
				Conditional = true,
				Repeat = true,
				Keyword = true,
				Exception = true,
				Type = true,
				StorageClass = true,
				Structure = true,
				Typedef = true,
			}
			local soft_groups = {
				Operator = true,
				Delimiter = true,
				Constant = true,
				String = true,
				Character = true,
				Number = true,
				Boolean = true,
				Float = true,
			}
			local syntax_groups = {
				"Normal", "Identifier", "Function", "Statement", "Conditional", "Repeat",
				"Label", "Operator", "Keyword", "Exception", "PreProc", "Include", "Define",
				"Macro", "PreCondit", "Type", "StorageClass", "Structure", "Typedef", "Special",
				"SpecialChar", "Tag", "Delimiter", "Debug", "Constant", "String", "Character",
				"Number", "Boolean", "Float",
			}

			for _, group in ipairs(syntax_groups) do
				local color = purple_groups[group] and pink
					or (strong_groups[group] and strong or (soft_groups[group] and soft or ink))
				vim.api.nvim_set_hl(0, group, { fg = color, bold = false })
			end

			-- GitHub Theme defines many specialized captures such as @function.call,
			-- @tag.attribute and @lsp.typemod.*. Replace the foreground of every
			-- syntax/LSP capture so none of those variants can restore bright colors.
			for name, highlight in pairs(vim.api.nvim_get_hl(0, {})) do
				-- @ibl.* are UI groups for indent guides, not Treesitter syntax.
				if name:sub(1, 1) == "@" and not name:find("^@ibl%.") then
					local resolved = vim.api.nvim_get_hl(0, { name = name, link = false })
					local lower_name = name:lower()
					local is_comment = lower_name:find("comment", 1, true) ~= nil
					local is_purple = lower_name:find("^@keyword")
						or lower_name:find("^@type")
						or lower_name:find("^@storageclass")
						or lower_name:find("^@lsp%.type%.type[%.@]")
						or lower_name:find("^@lsp%.type%.class[%.@]")
						or lower_name:find("^@lsp%.type%.struct[%.@]")
						or lower_name:find("^@lsp%.type%.enum[%.@]")
						or lower_name:find("^@lsp%.type%.interface[%.@]")
						or lower_name:find("^@lsp%.type%.typeparam")
					local is_strong = lower_name:find("function", 1, true)
						or lower_name:find("method", 1, true)
						or lower_name:find("^@tag")
					local is_soft = lower_name:find("string", 1, true)
						or lower_name:find("number", 1, true)
						or lower_name:find("boolean", 1, true)
						or lower_name:find("constant", 1, true)
						or lower_name:find("operator", 1, true)
						or lower_name:find("punctuation", 1, true)
					resolved.fg = is_comment and muted
						or (is_purple and pink or (is_strong and strong or (is_soft and soft or ink)))
					resolved.bold = false
					resolved.italic = is_comment
					resolved.link = nil
					vim.api.nvim_set_hl(0, name, resolved)
				end
			end

			vim.api.nvim_set_hl(0, "Comment", { fg = muted, italic = true })
			vim.api.nvim_set_hl(0, "SpecialComment", { fg = muted, italic = true })
			vim.api.nvim_set_hl(0, "LineNr", { fg = palette.line_number })
			vim.api.nvim_set_hl(0, "LineNrAbove", { fg = palette.line_number })
			vim.api.nvim_set_hl(0, "LineNrBelow", { fg = palette.line_number })
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = palette.line_number_current, bold = false })
			vim.api.nvim_set_hl(0, "IblIndent", { fg = palette.indent, bold = false })
			vim.api.nvim_set_hl(0, "IblScope", { fg = palette.indent_scope, bold = false })
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = palette.indent_scope, bold = false })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
		end

		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "github_light_default",
			callback = make_monochrome,
		})
		vim.api.nvim_create_autocmd({ "FileType", "LspAttach" }, {
			callback = function()
				vim.schedule(make_monochrome)
			end,
		})

		vim.cmd.colorscheme("github_light_default")
		make_monochrome()
	end,
}
