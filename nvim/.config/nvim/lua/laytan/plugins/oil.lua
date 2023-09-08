return {
  'stevearc/oil.nvim',
  opts = {
    delete_to_trash = true,
    trash_command   = 'trash',
    view_options = {
      show_hidden = true,
    },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = { { '-', ':Oil<cr>' } },
}
