return {
  -- Dependency of lots of plugins.
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'kyazdani42/nvim-web-devicons', lazy = true },

  { 'folke/neodev.nvim', lazy = true, config = true },

  { 'jneen/ragel.vim', ft = 'ragel' },

  { 'Tetralux/odin.vim', ft = 'odin' },

  -- Pretty vim.notify output.
  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require('notify')
      notify.setup({ timeout = 1500, background_colour = '#000000' })
      vim.notify = notify
    end,
  },

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

  -- GO utility and debugging.
  { 'olexsmir/gopher.nvim', ft = 'go', config = true },

  -- Powerful note taking.
  -- CmdlineEnter so we get auto-complete for the commands.
  { 'phaazon/mind.nvim', branch = 'v2.2', event = 'CmdlineEnter', config = true },

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
          left = [[ray(']],
          right = [[');]],
          mid_var = [[', $]],
          right_var = [[);]],
        },
      },
    },
  },
}
