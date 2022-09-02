local group = vim.api.nvim_create_augroup('laytan_drupal', {})
vim.api.nvim_create_autocmd(
  'BufEnter', {
    group = group,
    pattern = { '*.module', '*.theme', '*.install', '*.sfc' },
    command = 'setlocal filetype=php',
  }
)

