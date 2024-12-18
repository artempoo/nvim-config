local global = vim.g
local o = vim.opt

o.confirm = true -- Confirm to save changes before exiting modified buffer
o.cursorline = true -- Enable highlighting of the current line
-- o.list = true -- Show some invisible characters (tabs...
o.syntax = "on"
o.mouse = "a" -- Enable mouse mode
o.number = true -- номер строки перед каждой строкой
o.pumblend = 10 -- Popup blend
o.pumheight = 10 -- Maximum number of entries in a popup
-- o.relativenumber = true -- Relative line numbers
o.shiftround = true -- Round indent
o.shiftwidth = 2 -- Size of an indent
o.tabstop = 2
--o.shortmess:append({ W = true, I = true, c = true })
o.showmode = false -- Dont show mode since we have a statusline
o.sidescrolloff = 8 -- Columns of context
o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
o.smartcase = true -- Don't ignore case with capitals
o.smartindent = true -- Insert indents automatically
o.splitbelow = true -- Put new windows below current
o.splitright = true -- Put new windows right of current
o.termguicolors = true -- True color support
o.timeoutlen = 500 -- speed must be under 500ms inorder for keys to work, increase if you are not able to.
o.undofile = true
o.undolevels = 10000
o.updatetime = 200 -- Save swap file and trigger CursorHold
o.wildmode = "longest:full,full" -- Command-line completion mode
o.wrap = false -- Disable line wrap
o.autoindent = true
o.title = true
o.showmatch = true
o.termguicolors = true
o.clipboard = "unnamedplus" -- использование системного буфера
o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }

-- vim.wo.number = true
-- vim.opt.hlsearch = true
-- vim.opt.backup = false
-- vim.opt.showcmd = true
-- vim.opt.cmdheight = 1
-- vim.opt.laststatus = 2
-- vim.opt.expandtab = true
-- vim.opt.scrolloff = 10
-- vim.opt.shell = "zsh"
-- --vim.opt.inccomand = 'split'
-- vim.opt.ignorecase = true
-- vim.opt.smarttab = true
-- vim.opt.breakindent = true
--vim.opt.path:append { '**' } -- поиск внутри папок
--vim.opt.wildignore:append { '*/node_modules/*'}
-- vim.opt.guicursor =
-- "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.opt.guicursor = "n:ver1,v:ver1,i:ver1,i:blinkwait1-blinkoff50-blinkon175"

o.shiftround = true -- Round indent

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- vim.cmd([[
--   highlight Normal guibg=none
--   highlight NonText guibg=none
--   highlight Normal ctermbg=none
--   highlight NonText ctermbg=none
-- ]])
