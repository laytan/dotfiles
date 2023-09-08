-- Go to end of line
vim.keymap.set('i', '<C-e>', '<esc><S-A>')

-- Move selection up/down
vim.keymap.set('v', 'K', ':m \'<-2<cr>gv=gv')
vim.keymap.set('v', 'J', ':m \'>+1<cr>gv=gv')

-- Copy from cursor until end of line
vim.keymap.set('n', 'Y', 'y$')

-- Keep cursor at one position when going next or previous
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Make jumplist work for multi-line j or k
vim.keymap.set('n', '<expr> k', '(v:count > 5 ? "m\'" . v:count : "") . \'k\'')
vim.keymap.set('n', '<expr> j', '(v:count > 5 ? "m\'" . v:count : "") . \'j\'')

-- Center cursor after <C-d> or <C-u>
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

vim.keymap.set('n', '<C-m>', '<cmd>:cnext<cr>')
vim.keymap.set('n', '<C-n>', '<cmd>:cprev<cr>')

-- Open URL under cursor.
vim.keymap.set('n', 'gx', ':silent !open <c-r><c-a><cr>')
