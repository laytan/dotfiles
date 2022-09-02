local group = vim.api.nvim_create_augroup('sleuther', {})
vim.api.nvim_create_autocmd(
  'BufEnter', { group = group, command = 'silent Sleuth' }
)
