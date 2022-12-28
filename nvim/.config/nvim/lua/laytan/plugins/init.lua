return {
  -- Dependency of lots of plugins.
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'kyazdani42/nvim-web-devicons', lazy = true },

  -- Pretty vim.notify output.
  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require('notify')
      notify.setup({ timeout = 1500, background_colour = '#000000' })
      vim.notify = notify
    end,
  },

  -- Undo navigation.
  {
    'mbbill/undotree',
    keys = '<leader>u',
    config = function()
      vim.keymap.set('n', '<leader>u', ':silent :UndotreeToggle<cr>')
    end,
  },

  -- Better and language aware commenting.
  { 'numToStr/Comment.nvim', event = 'BufEnter', config = {} },

  -- Live preview markdown.
  {
    'iamcco/markdown-preview.nvim',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    -- CmdlineEnter so we get auto-complete for the commands.
    event = 'CmdlineEnter',
  },

  -- GO utility and debugging.
  { 'olexsmir/gopher.nvim', ft = 'go', config = {} },

  -- Powerful note taking.
  -- CmdlineEnter so we get auto-complete for the commands.
  { 'phaazon/mind.nvim', branch = 'v2.2', event = 'CmdlineEnter', config = {} },

  -- Powerful surround textobjects/actions.
  { 'kylechui/nvim-surround', event = 'VeryLazy', config = {} },

  -- Show cursor location/movement in sidebar.
  {
    'gen740/SmoothCursor.nvim',
    event = { 'CursorMoved', 'CursorMovedI' },
    config = function()
      require('smoothcursor').setup()
      vim.cmd('highlight SmoothCursor guifg=#8aadf4')
    end,
  },

  -- Put but without clearing put register.
  { 'vim-scripts/ReplaceWithRegister', event = 'VeryLazy' },

  -- Quickly spin up a local server for files.
  {
    'aurum77/live-server.nvim',
    build = function()
      require('live_server.util').install()
    end,
    -- CmdlineEnter so we get auto-complete for the commands.
    event = 'CmdlineEnter',
    config = {},
  },

  -- Shortcuts for inserting and removing debug and print statements.
  {
    'andrewferrier/debugprint.nvim',
    event = 'VeryLazy',
    config = {
      filetypes = {
        ['php'] = {
          left = [[dump(']],
          right = [[');]],
          mid_var = [[', $]],
          right_var = [[);]],
        },
      },
    },
  },

  -- Colors text that resolves to a color in that color (works with Sass variables).
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufEnter',
    config = {
      user_default_options = {
        rgb_fn = true,
        hsl_fn = true,
        tailwind = 'lsp',
        sass = { enable = true },
      },
    },
  },
}
