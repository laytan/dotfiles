return {
  -- Dependency of lots of plugins.
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  { 'folke/neodev.nvim', lazy = true, config = true },

  -- Normal buffer/vim operations on the quickfix list.
  { 'itchyny/vim-qfedit' },

  { 'lewis6991/gitsigns.nvim', config = true, event = 'BufEnter' },

  {
    'm4xshen/smartcolumn.nvim',
    opts = { colorcolumn = '100' },
    event = 'BufEnter',
  },

  {
    'mbbill/undotree',
    keys = '<leader>u',
    config = function()
      vim.keymap.set('n', '<leader>u', ':silent :UndotreeToggle<cr>')
    end,
  },

  { 'numToStr/Comment.nvim', event = 'BufEnter', config = true },

  {
    'iamcco/markdown-preview.nvim',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    -- CmdlineEnter so we get auto-complete for the commands.
    event = 'CmdlineEnter',
  },

  -- Powerful surround textobjects/actions.
  { 'kylechui/nvim-surround', event = 'VeryLazy', config = true },

  -- Put but without clearing put register.
  {
    'vim-scripts/ReplaceWithRegister',
    keys = { { 'gr', nil, 'x' }, 'gr', 'grr' },
  },

  -- Quickly spin up a local server for files.
  {
    'aurum77/live-server.nvim',
    build = function()
      require('live_server.util').install()
    end,
    -- CmdlineEnter so we get auto-complete for the commands.
    event = 'CmdlineEnter',
    config = true,
  },

  -- Shortcuts for inserting and removing debug and print statements.
  {
    'andrewferrier/debugprint.nvim',
    event = 'VeryLazy',
    opts = {
      filetypes = {
        ['php'] = {
          left      = [[dump(']],
          right     = [[');]],
          mid_var   = [[', $]],
          right_var = [[);]],
        },
        ['odin'] = {
          left      = [[fmt.printf("]],
          right     = [[")]],
          mid_var   = [[", ]],
          right_var = [[)]],
        },
      },
    },
  },
}
