vim.g.mapleader = " "

--NeoTree
vim.keymap.set("n", "<leader>e", ":Neotree float<CR>")
-- vim.keymap.set("n", "<leader>stv", ":vsplit +term<CR>")
vim.keymap.set("n", "<leader>fr", ":%s/")
vim.keymap.set("n", "<leader>ls", ":LiveServerStart<CR>")
vim.keymap.set("n", "<leader>lt", ":LiveServerStop<CR>")

vim.keymap.set("n", "<leader>sg", ":split<CR>")
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>")
vim.keymap.set("n", "<leader>te", ":tabedit<CR>")

vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sl", "<C-w>l")

vim.keymap.set("n", "<TAB>t", ":tabnew:tabedit<CR>")
