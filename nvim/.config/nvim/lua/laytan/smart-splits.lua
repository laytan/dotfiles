local ss = require('smart-splits')
ss.setup({ silent = true })

vim.keymap.set('n', '¬', ss.resize_right) -- Alt-l in tmux
vim.keymap.set('n', '<A-l>', ss.resize_right)

vim.keymap.set('n', '∆', ss.resize_down) -- Alt-j in tmux
vim.keymap.set('n', '<A-j>', ss.resize_down) -- Alt-j in tmux

vim.keymap.set('n', '˚', ss.resize_up) -- Alt-k in tmux
vim.keymap.set('n', '<A-k>', ss.resize_up)

vim.keymap.set('n', '˙', ss.resize_left) -- Alt-h in tmux
vim.keymap.set('n', '<A-h>', ss.resize_left)

vim.keymap.set('n', '<C-l>', ss.move_cursor_right)
vim.keymap.set('n', '<C-j>', ss.move_cursor_down)
vim.keymap.set('n', '<C-k>', ss.move_cursor_up)
vim.keymap.set('n', '<C-h>', ss.move_cursor_left)
vim.keymap.set('n', '<leader><leader>l', ss.swap_buf_right)
vim.keymap.set('n', '<leader><leader>j', ss.swap_buf_down)
vim.keymap.set('n', '<leader><leader>k', ss.swap_buf_up)
vim.keymap.set('n', '<leader><leader>h', ss.swap_buf_left)
