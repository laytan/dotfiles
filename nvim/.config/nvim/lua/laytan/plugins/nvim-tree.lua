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
    on_attach = function(bufnr)
      local api = require('nvim-tree.api')
      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.del('n', 'd', { buffer = bufnr })
      vim.keymap.set('n', 'd', api.fs.trash, opts('Trash'))

      vim.keymap.del('n', 'D', { buffer = bufnr })
      vim.keymap.set('n', 'D', api.fs.remove, opts('Delete'))
    end,
  },
}
