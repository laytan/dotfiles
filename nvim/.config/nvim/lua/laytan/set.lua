vim.g.mapleader = ' '
vim.g.cursorhold_updatetime = 500
vim.g.loaded_netrw = false
vim.g.loaded_netrwPlugin = false

vim.opt.encoding = 'UTF-8'

vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.relativenumber = true
vim.opt.nu = true

vim.opt.hlsearch = false

vim.opt.hidden = true

vim.opt.errorbells = false

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 8

vim.opt.signcolumn = 'yes'

vim.opt.clipboard = 'unnamedplus'

vim.opt.ts = 4

vim.opt.mouse = ''

vim.opt.termguicolors = true

vim.opt.spell = true
vim.opt.spelloptions = 'camel,noplainbuffer'

vim.opt.cmdheight = 0
vim.opt.laststatus = 3

vim.opt.conceallevel = 2

vim.opt.shortmess:append('s')

vim.opt.splitkeep = 'screen'
