return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = true,
  cmd = 'Spectre',
  keys = {
    {
      '<leader>sr',
      '<cmd>lua require("spectre").toggle()<CR>',
      desc = 'Toggle Spectre',
    },
    {
      '<leader>sw',
      '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
      desc = 'Search current word',
    },
  },
}
