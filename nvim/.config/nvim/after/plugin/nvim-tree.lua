require('nvim-tree').setup(
  {
    auto_reload_on_write = true,
    reload_on_bufenter = true,
    view = {
      side = 'right',
      width = 45,
      mappings = {
        list = {
          { key = 'd', action = 'trash' },
          { key = 'D', action = 'remove' },
        },
      },
    },
    renderer = {
      highlight_git = true,
      highlight_opened_files = 'icon',
      special_files = {},
    },
    diagnostics = { enable = true, show_on_dirs = true },
    git = { ignore = false },
    actions = {
      change_dir = { enable = false },
      open_file = { quit_on_open = true },
    },
    trash = { cmd = 'trash' },
  }
)

vim.keymap.set('n', '<leader>T', ':NvimTreeFindFile<cr>')

