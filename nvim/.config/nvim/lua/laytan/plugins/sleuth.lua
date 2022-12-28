-- Automatically adjusts tab width etc. to match that used in the buffer.
return {
  'tpope/vim-sleuth',
  event = 'BufEnter',
  config = function()
    local group = vim.api.nvim_create_augroup('sleuther', {})
    vim.api.nvim_create_autocmd(
      'BufEnter', { group = group, command = 'silent Sleuth' }
    )
  end,
}
