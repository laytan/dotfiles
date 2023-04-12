-- File tree
return {
  'kyazdani42/nvim-tree.lua',
  keys = { { '<leader>T', ':NvimTreeFindFileToggle<cr>' } },
  opts = {
    auto_reload_on_write = true,
    disable_netrw = true,
    reload_on_bufenter = true,
    view = {
      float = { enable = true, open_win_config = { width = 45 } },
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
  },
}
