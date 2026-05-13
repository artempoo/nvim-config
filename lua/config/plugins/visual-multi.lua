return {
	{
		"mg979/vim-visual-multi",
		lazy = false,
		init = function()
			-- Через g:VM_maps (только Vimscript → корректный Dict): «курсор сюда» на пробел+m+m
			vim.cmd([[
				let g:VM_maps = get(g:, 'VM_maps', {})
				if type(g:VM_maps) != v:t_dict
					let g:VM_maps = {}
				endif
				let g:VM_maps['Add Cursor At Pos'] = '<leader>mm'
			]])
		end,
		config = function()
			local function add_cursor()
				vim.cmd([[call vm#commands#add_cursor_at_pos(0)]])
			end
			vim.keymap.set("n", "<C-c>", add_cursor, {
				desc = "VM: add cursor here",
			})
		end,
	},
}
